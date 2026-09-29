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

  group('with shoes', () {
    setUp(() {
      when(() => repository.fetchShoes())
          .thenAnswer((_) async => List.of(shoes));
    });

    test('counts shoes by brand, category and type', () async {
      expect(await controller.getTotalShoesCount(), 3);
      expect(await controller.getShoesCountByBrand(), {'Nike': 2, 'Adidas': 1});
      expect(
        await controller.getShoesCountByCategory(),
        {'Sneakers': 2, 'Boots': 1},
      );
      expect(
        await controller.getShoesCountByType(),
        {'Running': 1, 'Ankle Boots': 1, 'Casual': 1},
      );
    });

    test('counts shoes by primary color as ARGB hex', () async {
      expect(
        await controller.getShoesCountByColor(),
        {'ff000000': 2, 'ffffffff': 1},
      );
    });

    test('finds the most used brand, category and color', () async {
      expect(await controller.getFavoriteBrand(), 'Nike');
      expect(await controller.getMostUsedCategory(), 'Sneakers');
      expect(await controller.getMostUsedColor(), 'ff000000');
      expect(
        await controller.getMostUsedColorAsColor(),
        const Color(0xFF000000),
      );
    });

    test('returns the most recently added shoe', () async {
      final last = await controller.getLastShoeAdded();
      expect(last?.category, 'Boots');
    });

    test('counts favorites', () async {
      expect(await controller.getFavoriteShoesCount(), 1);
    });

    test('bundles all counts in the statistics summary', () async {
      final stats = await controller.getShoesStatistics();
      expect(stats['totalCount'], 3);
      expect(stats['byBrand'], {'Nike': 2, 'Adidas': 1});
    });
  });

  group('with an empty collection', () {
    setUp(() {
      when(() => repository.fetchShoes()).thenAnswer((_) async => []);
    });

    test('has no "most used" values and no last shoe', () async {
      expect(await controller.getFavoriteBrand(), isNull);
      expect(await controller.getMostUsedCategory(), isNull);
      expect(await controller.getMostUsedType(), isNull);
      expect(await controller.getMostUsedColorAsColor(), isNull);
      expect(await controller.getLastShoeAdded(), isNull);
      expect(await controller.getFavoriteShoesCount(), 0);
    });
  });

  group('when the repository fails', () {
    setUp(() {
      when(() => repository.fetchShoes()).thenThrow(Exception('offline'));
    });

    test('count queries rethrow the error', () async {
      expect(controller.getTotalShoesCount(), throwsException);
      expect(controller.getShoesCountByBrand(), throwsException);
    });

    test('summary helpers fall back to null or zero', () async {
      expect(await controller.getFavoriteBrand(), isNull);
      expect(await controller.getLastShoeAdded(), isNull);
      expect(await controller.getFavoriteShoesCount(), 0);
    });
  });
}
