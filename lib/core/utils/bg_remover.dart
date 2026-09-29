import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:image_background_remover/image_background_remover.dart';
import 'package:shox/core/utils/mask_refinement.dart';

// Dimensione massima lato lungo inviata al modello AI (ottimale per ONNX u2net)
const int _maxInputDimension = 1024;

bool _ortInitialized = false;

Future<Uint8List> removeImageBackground(File imageFile) async {
  // Inizializza ONNX Runtime una sola volta
  if (!_ortInitialized) {
    await BackgroundRemover.instance.initializeOrt();
    _ortInitialized = true;
  }

  final Uint8List originalBytes = await imageFile.readAsBytes();

  // Pre-elaborazione: ridimensiona all'input ottimale per il modello AI
  final Uint8List preparedBytes =
      await compute(_prepareImageForModel, originalBytes);

  // Rimozione sfondo con AI
  final ui.Image resultImage =
      await BackgroundRemover.instance.removeBg(preparedBytes);

  // Converti in RGBA grezzo per la post-elaborazione
  final byteData =
      await resultImage.toByteData(format: ui.ImageByteFormat.rawRgba);
  if (byteData == null) throw Exception('Conversione immagine fallita');

  // Post-elaborazione: smoothing bordi alpha su isolate separato
  final Uint8List refined = await compute(
    _postProcessAlpha,
    _ProcessArgs(
      byteData.buffer.asUint8List(),
      resultImage.width,
      resultImage.height,
    ),
  );

  return refined;
}

/// Ridimensiona a max [_maxInputDimension] sul lato lungo (interpolazione cubica).
Uint8List _prepareImageForModel(Uint8List bytes) {
  final decoded = img.decodeImage(bytes);
  if (decoded == null) return bytes;

  if (decoded.width <= _maxInputDimension &&
      decoded.height <= _maxInputDimension) {
    return bytes;
  }

  final resized = img.copyResize(
    decoded,
    width: decoded.width >= decoded.height ? _maxInputDimension : null,
    height: decoded.height > decoded.width ? _maxInputDimension : null,
    interpolation: img.Interpolation.cubic,
  );

  return Uint8List.fromList(img.encodePng(resized));
}

class _ProcessArgs {
  final Uint8List rgba;
  final int width;
  final int height;

  const _ProcessArgs(this.rgba, this.width, this.height);
}

/// Rimuove artefatti con column-wise top-profile smoothing.
///
/// Per ogni colonna X trova il pixel più in alto con foreground → forma una curva.
/// L'artefatto crea uno spike verso l'alto rilevabile con una mediana mobile.
/// Tutto sopra il profilo mediato + margine viene azzerato.
Uint8List _postProcessAlpha(_ProcessArgs args) {
  final image = img.Image.fromBytes(
    width: args.width,
    height: args.height,
    bytes: args.rgba.buffer,
    numChannels: 4,
  );

  final w = args.width;
  final h = args.height;

  // Estrai alpha in array flat per accesso veloce
  final alpha = Uint8List(w * h);
  for (int y = 0; y < h; y++) {
    for (int x = 0; x < w; x++) {
      alpha[y * w + x] = image.getPixel(x, y).a.toInt();
    }
  }

  // Step 1: rimuovi rumore puntuale
  for (int i = 0; i < alpha.length; i++) {
    if (alpha[i] < 15) alpha[i] = 0;
  }

  // Step 2: per ogni colonna trova il pixel foreground più in alto (y minimo)
  // y piccolo = in alto nell'immagine; h = nessun foreground in questa colonna
  final topRow = Int32List(w)..fillRange(0, w, h);
  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++) {
      if (alpha[y * w + x] > 0) {
        topRow[x] = y;
        break;
      }
    }
  }

  // Step 3: mediana mobile del profilo superiore
  // Finestra più ampia (~15% larghezza) → profilo più stabile e robusto
  final windowHalf = (w * 0.15).round().clamp(15, 150);
  final smoothedTop = Int32List(w);
  final window = <int>[];
  for (int x = 0; x < w; x++) {
    window.clear();
    for (int kx = -windowHalf; kx <= windowHalf; kx++) {
      final sx = (x + kx).clamp(0, w - 1);
      if (topRow[sx] < h) window.add(topRow[sx]);
    }
    if (window.isEmpty) {
      smoothedTop[x] = 0;
    } else {
      window.sort();
      smoothedTop[x] = window[window.length ~/ 2];
    }
  }

  // Step 4: azzera i pixel sopra il profilo mediato + margine ridotto (5px)
  // Margine piccolo = taglia più vicino al bordo reale della scarpa → elimina residui
  const int topMargin = 5;
  for (int y = 0; y < h; y++) {
    for (int x = 0; x < w; x++) {
      if (smoothedTop[x] > 0 && y < smoothedTop[x] - topMargin) {
        alpha[y * w + x] = 0;
      }
    }
  }

  // Step 5: erosione — la maschera del modello (320px) ingrandita "sborda" di
  // qualche pixel e lascia un bordino dello sfondo attorno alla scarpa
  final eroded = MaskRefinement.erode(
    alpha,
    w,
    h,
    MaskRefinement.erosionRadiusFor(math.max(w, h)),
  );

  // Step 6: Gaussian blur per smussare i bordi del ritaglio
  final alphaImg = img.Image(width: w, height: h, numChannels: 1);
  for (int y = 0; y < h; y++) {
    for (int x = 0; x < w; x++) {
      alphaImg.setPixelR(x, y, eroded[y * w + x]);
    }
  }
  final smoothed = img.gaussianBlur(alphaImg, radius: 1);
  final feathered = Uint8List(w * h);
  for (int y = 0; y < h; y++) {
    for (int x = 0; x < w; x++) {
      feathered[y * w + x] = smoothed.getPixel(x, y).r.toInt();
    }
  }

  // Step 7: i pixel di bordo prendono il colore della scarpa invece di quello
  // dello sfondo rimosso (niente alone chiaro/scuro)
  final rgba = MaskRefinement.decontaminateEdges(args.rgba, feathered, w, h);

  // Step 8: ricomponi l'immagine finale
  for (int i = 0; i < w * h; i++) {
    rgba[i * 4 + 3] = feathered[i];
  }
  final result = img.Image.fromBytes(
    width: w,
    height: h,
    bytes: rgba.buffer,
    numChannels: 4,
  );

  return Uint8List.fromList(img.encodePng(result));
}
