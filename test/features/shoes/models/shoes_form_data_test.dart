import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shox/features/shoes/models/shoes_form_data.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';

ShoesFormData formData({
  String brand = 'Nike',
  String season = 'Summer',
  String notes = '',
  bool colorPrimarySelected = true,
  List<Color> extraColors = const [],
  File? newImage,
  bool hasExistingImage = false,
}) {
  return ShoesFormData(
    brand: brand,
    size: '42',
    category: 'Sneakers',
    type: 'Running',
    season: season,
    notes: notes,
    colorPrimary: const Color(0xFF000000),
    colorPrimarySelected: colorPrimarySelected,
    extraColors: extraColors,
    newImage: newImage,
    hasExistingImage: hasExistingImage,
  );
}

void main() {
  final picked = File('picked.png');

  group('ShoesFormData.validate', () {
    test('requires a photo when adding a shoe', () {
      expect(formData().validate(), ShoesFormError.missingImage);
    });

    test('requires a photo when the stored one was removed', () {
      expect(
        formData(hasExistingImage: false).validate(),
        ShoesFormError.missingImage,
      );
    });

    test('accepts the stored photo when editing', () {
      expect(formData(hasExistingImage: true).validate(), isNull);
    });

    test('accepts a newly picked photo', () {
      expect(formData(newImage: picked).validate(), isNull);
    });

    test('requires a primary color', () {
      expect(
        formData(newImage: picked, colorPrimarySelected: false).validate(),
        ShoesFormError.missingColor,
      );
    });
  });

  group('ShoesFormData.toShoesModel', () {
    test('trims the brand and normalizes empty season and notes', () {
      final model =
          formData(brand: '  Nike ', season: '', notes: '').toShoesModel(
        imageUrl: 'path.png',
      );

      expect(model.brand, 'Nike');
      expect(model.season, 'All');
      expect(model.notes, isNull);
    });

    test('stores extra colors as ARGB ints, or null when empty', () {
      const blue = Color(0xFF0000FF);

      expect(
        formData(extraColors: [blue]).toShoesModel(imageUrl: '').colorExtra,
        [blue.toARGB32()],
      );
      expect(formData().toShoesModel(imageUrl: '').colorExtra, isNull);
    });

    test('keeps id, favorite flag and creation date of the edited shoe', () {
      final existing = ShoesModel(
        id: 'abc',
        imageUrl: 'https://example.com/abc.png',
        colorPrimary: const Color(0xFFFFFFFF),
        brand: 'Old',
        size: '40',
        category: 'Boots',
        isFavorite: true,
        dateAdded: DateTime(2024, 5, 1),
      );

      final model = formData().toShoesModel(
        imageUrl: existing.imageUrl,
        existing: existing,
      );

      expect(model.id, 'abc');
      expect(model.isFavorite, isTrue);
      expect(model.dateAdded, DateTime(2024, 5, 1));
      expect(model.brand, 'Nike');
    });
  });
}
