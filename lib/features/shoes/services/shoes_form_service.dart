import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:shox/features/shoes/controller/shoes_controller.dart';
import 'package:shox/features/shoes/models/brand_suggestions.dart';
import 'package:shox/features/shoes/models/shoes_form_data.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';

/// Persists the add/edit shoe form through [ShoesController].
class ShoesFormService {
  final ShoesController _shoesController = Get.find<ShoesController>();

  /// Brands already in the collection, suggested while typing.
  Future<BrandSuggestions> loadBrandSuggestions() =>
      _shoesController.getBrandSuggestions();

  /// Adds a new shoe, or updates [existing] when given.
  ///
  /// Call only after [ShoesFormData.validate] returned null.
  Future<void> save(ShoesFormData data, {ShoesModel? existing}) async {
    final File? imageToUpload = await _prepareImage(data);

    if (existing == null) {
      await _shoesController.addShoes(
        data.toShoesModel(imageUrl: imageToUpload!.path),
        imageToUpload,
      );
      return;
    }

    // The stored photo is deleted only when the user removed it; validate()
    // guarantees a new one was picked in that case.
    final bool storedPhotoRemoved = !data.hasExistingImage;
    await _shoesController.updateShoes(
      data.toShoesModel(
        imageUrl: imageToUpload?.path ?? existing.imageUrl,
        existing: existing,
      ),
      newImage: imageToUpload,
      removedImages: storedPhotoRemoved && existing.imageUrl.isNotEmpty
          ? [existing.imageUrl]
          : null,
    );
  }

  /// Returns the file to upload: the background-free PNG when available,
  /// otherwise the picked photo, or null when the photo did not change.
  Future<File?> _prepareImage(ShoesFormData data) async {
    final File? picked = data.newImage;
    final Uint8List? noBgBytes = data.imageNoBgBytes;
    if (picked == null || noBgBytes == null) return picked;

    final tempFile = File(
      '${Directory.systemTemp.path}/shoes_no_bg_'
      '${DateTime.now().millisecondsSinceEpoch}.png',
    );
    await tempFile.writeAsBytes(noBgBytes);
    return tempFile;
  }
}
