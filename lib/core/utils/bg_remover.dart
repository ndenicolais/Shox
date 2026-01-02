import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:image_background_remover/image_background_remover.dart';

Future<Uint8List> removeImageBackground(File imageFile) async {
  try {
    await BackgroundRemover.instance.initializeOrt();

    // Leggi l'immagine originale senza compressione per massima qualità
    final Uint8List imageBytes = await imageFile.readAsBytes();

    // Rimuovi lo sfondo con il modello AI
    final ui.Image resultImage =
        await BackgroundRemover.instance.removeBg(imageBytes);

    final byteData =
        await resultImage.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) {
      throw Exception('Impossibile convertire il risultato');
    }

    return byteData.buffer.asUint8List();
  } catch (e) {
    // Log dell'errore per debug
    print('Errore dettagliato rimozione sfondo: $e');
    rethrow;
  }
}
