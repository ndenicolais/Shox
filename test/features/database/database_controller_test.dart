import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shox/features/database/controller/database_controller.dart';
import 'package:shox/features/database/repository/database_repository.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';

class MockRepository extends Mock implements DatabaseRepository {}

ShoesModel shoe({
  required String brand,
  String category = 'Sneakers',
  String type = 'Running',
  Color color = const Color(0xFF000000),
  bool isFavorite = false,
  DateTime? dateAdded,
}) {
  return ShoesModel(
    imageUrl: '',
    colorPrimary: color,
    brand: brand,
    size: '42',
    category: category,
    type: type,
    isFavorite: isFavorite,
    dateAdded: dateAdded ?? DateTime(2024, 1, 1),
  );
}

void main() {
  late MockRepository repository;
  late DatabaseController controller;

  final shoes = [
    shoe(brand: 'Nike', isFavorite: true, dateAdded: DateTime(2024, 3, 1)),
    shoe(
      brand: 'Nike',
      category: 'Boots',
      type: 'Ankle Boots',
      color: const Color(0xFFFFFFFF),
      dateAdded: DateTime(2024, 5, 1),
    ),
    shoe(brand: 'Adidas', type: 'Casual', dateAdded: DateTime(2024, 1, 1)),
  ];

  setUp(() {
    repository = MockRepository();
    controller = DatabaseController(repository: repository);
  });

  group('getStatistics', () {
    test('computes every aggregate from a single read', () async {
      when(() => repository.fetchShoes())
          .thenAnswer((_) async => List.of(shoes));

      final stats = await controller.getStatistics();

      expect(stats.total, 3);
      expect(stats.favorites, 1);
      expect(stats.byBrand, {'Nike': 2, 'Adidas': 1});
      expect(stats.byCategory, {'Sneakers': 2, 'Boots': 1});
      expect(stats.byType, {'Running': 1, 'Ankle Boots': 1, 'Casual': 1});
      expect(stats.byColor, {
        const Color(0xFF000000): 2,
        const Color(0xFFFFFFFF): 1,
      });
      expect(stats.favoriteBrand, 'Nike');
      expect(stats.mostUsedCategory, 'Sneakers');
      expect(stats.mostUsedColor, const Color(0xFF000000));
      expect(stats.lastAdded?.category, 'Boots');
      verify(() => repository.fetchShoes()).called(1);
    });

    test('has no "most used" values for an empty collection', () async {
      when(() => repository.fetchShoes()).thenAnswer((_) async => []);

      final stats = await controller.getStatistics();

      expect(stats.total, 0);
      expect(stats.favorites, 0);
      expect(stats.favoriteBrand, isNull);
      expect(stats.mostUsedCategory, isNull);
      expect(stats.mostUsedType, isNull);
      expect(stats.mostUsedColor, isNull);
      expect(stats.lastAdded, isNull);
    });

    test('rethrows repository errors', () async {
      when(() => repository.fetchShoes()).thenThrow(Exception('offline'));

      expect(controller.getStatistics(), throwsException);
    });
  });
}
