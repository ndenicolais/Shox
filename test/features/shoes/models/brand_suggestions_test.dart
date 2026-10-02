import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shox/features/shoes/models/brand_suggestions.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';

ShoesModel _shoe(String brand) => ShoesModel(
      imageUrl: '',
      colorPrimary: Colors.black,
      brand: brand,
      size: '42',
      category: 'Sneakers',
      type: 'Sport',
      dateAdded: DateTime(2026, 1, 1),
    );

void main() {
  group('BrandSuggestions.fromShoes', () {
    test('dedupes case-insensitively, most used first, then A-Z', () {
      final suggestions = BrandSuggestions.fromShoes([
        _shoe('Adidas'),
        _shoe('nike'),
        _shoe('Nike'),
        _shoe(' Nike '),
        _shoe('Asics'),
        _shoe(''),
      ]);

      expect(suggestions.brands, ['Nike', 'Adidas', 'Asics']);
    });
  });

  group('match', () {
    const suggestions =
        BrandSuggestions(['Nike', 'New Balance', 'Adidas', 'Onitsuka']);

    test('returns prefix matches before substring matches', () {
      expect(suggestions.match('ni'), ['Nike', 'Onitsuka']);
    });

    test('returns nothing for an empty query or an exact match', () {
      expect(suggestions.match('  '), isEmpty);
      expect(suggestions.match('nike'), isEmpty);
    });

    test('caps the number of options', () {
      final many = BrandSuggestions(List.generate(10, (i) => 'Brand $i'));
      expect(many.match('brand'), hasLength(BrandSuggestions.maxOptions));
    });
  });
}
