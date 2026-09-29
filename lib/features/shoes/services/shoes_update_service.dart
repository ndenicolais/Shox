import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';
import 'package:shox/features/shoes/controller/shoes_controller.dart';

class ShoesUpdateService {
  final ShoesController _shoesController = Get.find<ShoesController>();

  Future<void> updateShoes({
    required BuildContext context,
    required ShoesModel existingShoes,
    required File? newImageFile,
    required Uint8List? imageNoBgBytes,
    required Color colorPrimary,
    required List<Color> extraColors,
    required String brand,
    required String size,
    required String category,
    required String type,
    required String season,
    required String notes,
    required bool imageRemoved,
  }) async {
    // Se il background è stato rimosso, scrivi i bytes su un file temp
    File? imageToUpload = newImageFile;
    if (newImageFile != null && imageNoBgBytes != null) {
      final tempDir = Directory.systemTemp;
      final tempFile = File(
        '${tempDir.path}/shoes_no_bg_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await tempFile.writeAsBytes(imageNoBgBytes);
      imageToUpload = tempFile;
    }

    final updatedShoes = ShoesModel(
      id: existingShoes.id,
      imageUrl:
          imageToUpload?.path ?? (imageRemoved ? '' : existingShoes.imageUrl),
      colorPrimary: colorPrimary,
      colorExtra: extraColors.isNotEmpty
          ? extraColors.map((c) => c.toARGB32()).toList()
          : null,
      brand: brand.trim(),
      size: size,
      category: category,
      type: type,
      season: season.isNotEmpty ? season : 'All',
      notes: notes.isNotEmpty ? notes : null,
      dateAdded: existingShoes.dateAdded,
      dateUpdated: DateTime.now(),
    );

    // Lista delle immagini da rimuovere se l'immagine è stata rimossa
    final removedImages = imageRemoved && existingShoes.imageUrl.isNotEmpty
        ? [existingShoes.imageUrl]
        : null;

    await _shoesController.updateShoes(
      updatedShoes,
      newImage: imageToUpload,
      removedImages: removedImages,
    );
  }
}
