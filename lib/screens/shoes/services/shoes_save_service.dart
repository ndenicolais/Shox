import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';
import 'package:shox/features/shoes/controller/shoes_controller.dart';

class ShoesSaveService {
  final ShoesController _shoesController = ShoesController();

  Future<void> saveShoes({
    required BuildContext context,
    required File imageFile,
    required Uint8List? imageNoBgBytes,
    required Color colorPrimary,
    required List<Color> extraColors,
    required String brand,
    required String size,
    required String category,
    required String type,
    required String season,
    required String notes,
  }) async {
    // Prepare image to upload
    File imageToUpload = imageFile;
    if (imageNoBgBytes != null) {
      final tempDir = Directory.systemTemp;
      final tempFile = File(
          '${tempDir.path}/shoes_no_bg_${DateTime.now().millisecondsSinceEpoch}.png');
      await tempFile.writeAsBytes(imageNoBgBytes);
      imageToUpload = tempFile;
    }

    final newShoes = ShoesModel(
      id: '',
      imageUrl: imageToUpload.path,
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
    );

    await _shoesController.addShoes(newShoes, imageToUpload);
  }
}
