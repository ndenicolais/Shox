import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:shox/core/utils/bg_remover.dart';
import 'package:shox/core/utils/permission_helper.dart';

class ImageService {
  final Logger _logger = Logger();
  final ImagePicker _picker = ImagePicker();

  Future<File?> cropImage(BuildContext context, File imageFile) async {
    final extension = imageFile.path.split('.').last.toLowerCase();
    final format = (extension == 'png')
        ? ImageCompressFormat.png
        : ImageCompressFormat.jpg;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      compressFormat: format,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle:
              AppLocalizations.of(context)!.shoes_adder_screen_crop_image_title,
          toolbarColor: Theme.of(context).colorScheme.secondary,
          toolbarWidgetColor: Theme.of(context).colorScheme.primary,
          activeControlsWidgetColor: Theme.of(context).colorScheme.secondary,
          initAspectRatio: CropAspectRatioPreset.original,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          lockAspectRatio: false,
          hideBottomControls: false,
          showCropGrid: true,
        ),
        IOSUiSettings(
          title:
              AppLocalizations.of(context)!.shoes_adder_screen_crop_image_title,
        ),
      ],
    );
    return croppedFile != null ? File(croppedFile.path) : null;
  }

  Future<File?> pickImage(BuildContext context, ImageSource source) async {
    File? selectedImage;
    await requestStoragePermission(context, () async {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        File? croppedImage = await cropImage(context, File(pickedFile.path));
        if (croppedImage != null) {
          selectedImage = await compressImage(croppedImage);
        }
      } else {
        _logger.e("Error: no image selected");
      }
    });
    return selectedImage;
  }

  Future<File> compressImage(File imageFile) async {
    final extension = imageFile.path.split('.').last.toLowerCase();
    final format =
        (extension == 'png') ? CompressFormat.png : CompressFormat.jpeg;

    final compressedBytes = await FlutterImageCompress.compressWithFile(
      imageFile.path,
      quality: 70,
      format: format,
    );

    final compressedFile = File(imageFile.path);
    await compressedFile.writeAsBytes(compressedBytes!);
    return compressedFile;
  }

  Future<Uint8List?> removeBackground(File imageFile) async {
    try {
      final noBgBytes = await removeImageBackground(imageFile);
      return noBgBytes;
    } catch (e) {
      _logger.e('Error removing background: $e');
      rethrow;
    }
  }
}
