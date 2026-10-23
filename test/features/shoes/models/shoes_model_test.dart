import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';

void main() {
  group('ShoesModel.fromFirestore', () {
    test('reads a well-formed document', () {
      final shoe = ShoesModel.fromFirestore('id-1', {
        'imageUrl': 'https://example.com/a.png',
        'colorPrimary': 0xFF000000,
        'colorExtra': [0xFFFFFFFF],
        'brand': 'Nike',
        'size': '42',
        'category': 'Sneakers',
        'type': 'Running',
        'season': 'Summer',
        'notes': 'Gift',
        'isFavorite': true,
        'dateAdded': Timestamp.fromDate(DateTime(2024, 5, 1)),
        'dateUpdated': Timestamp.fromDate(DateTime(2024, 6, 1)),
      });

      expect(shoe.id, 'id-1');
      expect(shoe.colorPrimary, const Color(0xFF000000));
      expect(shoe.colorExtra, [0xFFFFFFFF]);
      expect(shoe.brand, 'Nike');
      expect(shoe.type, 'Running');
      expect(shoe.season, 'Summer');
      expect(shoe.isFavorite, isTrue);
      expect(shoe.dateAdded, DateTime(2024, 5, 1));
      expect(shoe.dateUpdated, DateTime(2024, 6, 1));
    });

    test('falls back to defaults instead of throwing on an empty document', () {
      final shoe = ShoesModel.fromFirestore('id-2', {});

      expect(shoe.imageUrl, '');
      expect(shoe.colorPrimary, const Color(ShoesModel.fallbackColor));
      expect(shoe.colorExtra, isEmpty);
      expect(shoe.brand, '');
      expect(shoe.size, '');
      expect(shoe.category, 'Other');
      expect(shoe.type, 'Other');
      expect(shoe.season, 'All');
      expect(shoe.isFavorite, isFalse);
    });

    test('tolerates wrongly typed fields', () {
      final shoe = ShoesModel.fromFirestore('id-3', {
        'colorPrimary': 'red',
        'colorExtra': [1.0, 'blue', null, 2],
        'brand': null,
        'size': 42,
        'category': '',
        'isFavorite': 'yes',
        'dateAdded': 'not a date',
        'dateUpdated': 1714521600000,
      });

      expect(shoe.colorPrimary, const Color(ShoesModel.fallbackColor));
      expect(shoe.colorExtra, [1, 2]);
      expect(shoe.brand, '');
      expect(shoe.size, '42');
      expect(shoe.category, 'Other');
      expect(shoe.isFavorite, isFalse);
      expect(
        shoe.dateUpdated,
        DateTime.fromMillisecondsSinceEpoch(1714521600000),
      );
    });

    test('derives the type from the category when it is missing', () {
      final shoe = ShoesModel.fromFirestore('id-4', {'category': 'Boots'});

      expect(shoe.type, 'Ankle Boots');
    });
  });

  group('ShoesModel.fromJson', () {
    test('parses ISO 8601 dates from a backup', () {
      final shoe = ShoesModel.fromJson('id-5', {
        'dateAdded': '2024-05-01T00:00:00.000',
        'dateUpdated': '2024-06-01T00:00:00.000',
      });

      expect(shoe.dateAdded, DateTime(2024, 5, 1));
      expect(shoe.dateUpdated, DateTime(2024, 6, 1));
    });
  });
}
