import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';
import 'package:shox/features/shoes/controller/shoes_controller.dart';

class ShoesUpdateService {
  final ShoesController _shoesController = ShoesController();

  Future<void> updateShoes({
    required BuildContext context,
    required ShoesModel existingShoes,
    required File? newImageFile,
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
    final updatedShoes = ShoesModel(
      id: existingShoes.id,
      imageUrl:
          newImageFile?.path ?? (imageRemoved ? '' : existingShoes.imageUrl),
      colorPrimary: colorPrimary,
      colorExtra: extraColors.isNotEmpty
          ? extraColors.map((c) => c.value).toList()
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
      newImage: newImageFile,
      removedImages: removedImages,
    );
  }
}
