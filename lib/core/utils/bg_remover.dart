import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_subject_segmentation/google_mlkit_subject_segmentation.dart';
import 'package:image/image.dart' as img;
import 'package:shox/core/utils/mask_refinement.dart';

/// Longest side sent to the segmenter: enough detail for a shoe photo while
/// keeping the confidence mask (one value per pixel) small.
const int _maxInputDimension = 1024;

/// The on-device ML Kit model is still being downloaded by Google Play
/// services (first use after install); retrying later will work.
class BackgroundModelDownloadingException implements Exception {
  const BackgroundModelDownloadingException();
}

/// Removes the background of [imageFile] on the device with ML Kit Subject
/// Segmentation and returns a PNG with a transparent background.
Future<Uint8List> removeImageBackground(File imageFile) async {
  final prepared = await compute(
    _prepareImage,
    await imageFile.readAsBytes(),
  );
  final input = File(
    '${Directory.systemTemp.path}/shox_bg_input_'
    '${DateTime.now().millisecondsSinceEpoch}.png',
  );
  await input.writeAsBytes(prepared.png);

  final segmenter = SubjectSegmenter(
    options: SubjectSegmenterOptions(
      enableForegroundBitmap: false,
      enableForegroundConfidenceMask: true,
      enableMultipleSubjects: SubjectResultOptions(
        enableConfidenceMask: false,
        enableSubjectBitmap: false,
      ),
    ),
  );

  try {
    final result =
        await segmenter.processImage(InputImage.fromFilePath(input.path));
    final mask = result.foregroundConfidenceMask;
    if (mask == null || mask.length != prepared.width * prepared.height) {
      throw Exception('Unexpected segmentation mask');
    }
    return compute(
      _composeWithMask,
      _ComposeArgs(prepared.rgba, prepared.width, prepared.height, mask),
    );
  } on PlatformException catch (e) {
    if ((e.message ?? '').toLowerCase().contains('download')) {
      throw const BackgroundModelDownloadingException();
    }
    rethrow;
  } finally {
    await segmenter.close();
    if (await input.exists()) await input.delete();
  }
}

class _PreparedImage {
  final Uint8List png;
  final Uint8List rgba;
  final int width;
  final int height;

  const _PreparedImage(this.png, this.rgba, this.width, this.height);
}

/// Decodes, applies EXIF orientation and scales down to
/// [_maxInputDimension], returning both the PNG to segment and its pixels.
_PreparedImage _prepareImage(Uint8List bytes) {
  final decoded = img.decodeImage(bytes);
  if (decoded == null) throw Exception('Unsupported image');
  var image = img.bakeOrientation(decoded);

  if (image.width > _maxInputDimension || image.height > _maxInputDimension) {
    image = img.copyResize(
      image,
      width: image.width >= image.height ? _maxInputDimension : null,
      height: image.height > image.width ? _maxInputDimension : null,
      interpolation: img.Interpolation.cubic,
    );
  }
  final rgba = image.convert(numChannels: 4);
  return _PreparedImage(
    Uint8List.fromList(img.encodePng(rgba)),
    Uint8List.fromList(rgba.getBytes(order: img.ChannelOrder.rgba)),
    rgba.width,
    rgba.height,
  );
}

class _ComposeArgs {
  final Uint8List rgba;
  final int width;
  final int height;
  final List<double> mask;

  const _ComposeArgs(this.rgba, this.width, this.height, this.mask);
}

/// Turns the confidence mask into alpha, trims the outermost pixel and
/// removes the background tint from the edges.
Uint8List _composeWithMask(_ComposeArgs args) {
  final w = args.width;
  final h = args.height;

  final alpha = MaskRefinement.erode(
    MaskRefinement.alphaFromConfidence(args.mask),
    w,
    h,
    1,
  );
  final rgba = MaskRefinement.decontaminateEdges(args.rgba, alpha, w, h);
  for (int i = 0; i < w * h; i++) {
    rgba[i * 4 + 3] = alpha[i];
  }

  final result = img.Image.fromBytes(
    width: w,
    height: h,
    bytes: rgba.buffer,
    numChannels: 4,
  );
  return Uint8List.fromList(img.encodePng(result));
}
