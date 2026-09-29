import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';

/// Why the shoe form cannot be saved yet.
enum ShoesFormError { missingImage, missingColor }

/// Snapshot of the add/edit shoe form.
///
/// Pure logic: validation and model building live here so they stay out of
/// the widget and can be unit tested.
@immutable
class ShoesFormData {
  final String brand;
  final String size;
  final String category;
  final String type;
  final String season;
  final String notes;
  final Color colorPrimary;
  final bool colorPrimarySelected;
  final List<Color> extraColors;

  /// Photo picked in this session, if any.
  final File? newImage;

  /// PNG bytes of [newImage] with the background removed, if requested.
  final Uint8List? imageNoBgBytes;

  /// Whether the shoe being edited still has its stored photo.
  final bool hasExistingImage;

  const ShoesFormData({
    required this.brand,
    required this.size,
    required this.category,
    required this.type,
    required this.season,
    required this.notes,
    required this.colorPrimary,
    required this.colorPrimarySelected,
    this.extraColors = const [],
    this.newImage,
    this.imageNoBgBytes,
    this.hasExistingImage = false,
  });

  /// Returns the first blocking error, or null when the form can be saved.
  /// Field-level checks (brand, size...) are handled by the form validators.
  ShoesFormError? validate() {
    if (newImage == null && !hasExistingImage) {
      return ShoesFormError.missingImage;
    }
    if (!colorPrimarySelected) return ShoesFormError.missingColor;
    return null;
  }

  /// Builds the model to persist. [imageUrl] is the local path of the photo
  /// to upload, or the stored URL when the photo did not change. When
  /// [existing] is given, its id and creation date are preserved.
  ShoesModel toShoesModel({required String imageUrl, ShoesModel? existing}) {
    return ShoesModel(
      id: existing?.id ?? '',
      imageUrl: imageUrl,
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
      isFavorite: existing?.isFavorite ?? false,
      dateAdded: existing?.dateAdded,
      dateUpdated: existing != null ? DateTime.now() : null,
    );
  }
}
