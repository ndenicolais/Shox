import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shox/features/shoes/models/shoes_filter.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';

ShoesModel shoe({
  String id = '1',
  String brand = 'Nike',
  Color colorPrimary = const Color(0xFF000000),
  List<int>? colorExtra,
  String category = 'Sneakers',
  String type = 'Running',
  String season = 'Summer',
  bool isFavorite = false,
  DateTime? dateAdded,
}) {
  return ShoesModel(
    id: id,
    imageUrl: 'https://example.com/$id.png',
    colorPrimary: colorPrimary,
    colorExtra: colorExtra,
    brand: brand,
    size: '42',
    category: category,
    type: type,
    season: season,
    isFavorite: isFavorite,
    dateAdded: dateAdded ?? DateTime(2026, 1, 1),
  );
}

List<String> brandsOf(List<ShoesModel> shoes) =>
    shoes.map((s) => s.brand).toList();

void main() {
  group('ShoesFilter.apply', () {
    test('returns every shoe when no filter is set', () {
      final list = [shoe(id: '1'), shoe(id: '2')];

      expect(const ShoesFilter().apply(list), hasLength(2));
    });

    test('sorts by most recently added first', () {
      final list = [
        shoe(id: 'old', brand: 'Old', dateAdded: DateTime(2020, 1, 1)),
        shoe(id: 'new', brand: 'New', dateAdded: DateTime(2026, 1, 1)),
        shoe(id: 'mid', brand: 'Mid', dateAdded: DateTime(2023, 1, 1)),
      ];

      expect(brandsOf(const ShoesFilter().apply(list)), ['New', 'Mid', 'Old']);
    });

    test('never mutates nor reorders the source list', () {
      final list = [
        shoe(id: 'old', brand: 'Old', dateAdded: DateTime(2020, 1, 1)),
        shoe(id: 'new', brand: 'New', dateAdded: DateTime(2026, 1, 1)),
      ];

      const ShoesFilter().apply(list);

      expect(brandsOf(list), ['Old', 'New']);
    });

    test('matches the brand regardless of case', () {
      final list = [shoe(brand: 'Adidas'), shoe(id: '2', brand: 'Nike')];

      final result = const ShoesFilter(searchQuery: 'adi').apply(list);

      expect(brandsOf(result), ['Adidas']);
    });

    test('keeps only favorites when onlyFavorites is set', () {
      final list = [
        shoe(id: '1', brand: 'Plain'),
        shoe(id: '2', brand: 'Starred', isFavorite: true),
      ];

      final result = const ShoesFilter(onlyFavorites: true).apply(list);

      expect(brandsOf(result), ['Starred']);
    });

    test('filters by primary color', () {
      const red = Color(0xFFFF0000);
      final list = [
        shoe(id: '1', brand: 'Red', colorPrimary: red),
        shoe(id: '2', brand: 'Black'),
      ];

      final result = const ShoesFilter(colorPrimary: red).apply(list);

      expect(brandsOf(result), ['Red']);
    });

    test('filters by extra color and skips shoes without extras', () {
      const blue = Color(0xFF0000FF);
      final list = [
        shoe(id: '1', brand: 'WithBlue', colorExtra: [blue.toARGB32()]),
        shoe(id: '2', brand: 'EmptyExtras', colorExtra: const []),
        shoe(id: '3', brand: 'NoExtras'),
      ];

      final result = const ShoesFilter(colorExtra: blue).apply(list);

      expect(brandsOf(result), ['WithBlue']);
    });

    test('filters by category', () {
      final list = [
        shoe(id: '1', brand: 'Sneaker', category: 'Sneakers'),
        shoe(id: '2', brand: 'Boot', category: 'Boots'),
      ];

      final result = const ShoesFilter(category: 'Boots').apply(list);

      expect(brandsOf(result), ['Boot']);
    });

    test('the "All" category keeps every shoe', () {
      final list = [
        shoe(id: '1', category: 'Sneakers'),
        shoe(id: '2', category: 'Boots'),
      ];

      expect(const ShoesFilter(category: 'All').apply(list), hasLength(2));
    });

    test('a null category is treated as no category filter', () {
      final list = [
        shoe(id: '1', category: 'Sneakers'),
        shoe(id: '2', category: 'Boots'),
      ];

      expect(const ShoesFilter(category: null).apply(list), hasLength(2));
    });

    test('filters by type using the translated label', () {
      final list = [
        shoe(id: '1', brand: 'Runner', type: 'Running'),
        shoe(id: '2', brand: 'Walker', type: 'Walking'),
      ];

      final result = const ShoesFilter(
        type: 'Corsa',
        translatedTypeOptions: {'Running': 'Corsa', 'Walking': 'Camminata'},
      ).apply(list);

      expect(brandsOf(result), ['Runner']);
    });

    test('filters by season', () {
      final list = [
        shoe(id: '1', brand: 'Summery', season: 'Summer'),
        shoe(id: '2', brand: 'Wintery', season: 'Winter'),
      ];

      final result = const ShoesFilter(season: 'Winter').apply(list);

      expect(brandsOf(result), ['Wintery']);
    });

    test('combines several filters', () {
      final list = [
        shoe(
          id: '1',
          brand: 'Nike',
          category: 'Sneakers',
          season: 'Summer',
          isFavorite: true,
        ),
        shoe(
          id: '2',
          brand: 'Nike',
          category: 'Sneakers',
          season: 'Winter',
          isFavorite: true,
        ),
        shoe(id: '3', brand: 'Nike', category: 'Boots', season: 'Summer'),
      ];

      final result = const ShoesFilter(
        searchQuery: 'nike',
        onlyFavorites: true,
        category: 'Sneakers',
        season: 'Summer',
      ).apply(list);

      expect(result.map((s) => s.id).toList(), ['1']);
    });

    test('returns an empty list when nothing matches', () {
      final list = [shoe(brand: 'Nike')];

      expect(const ShoesFilter(searchQuery: 'puma').apply(list), isEmpty);
    });
  });

  group('ShoesFilter.isActive', () {
    test('is false with no filter set', () {
      expect(const ShoesFilter().isActive, isFalse);
    });

    test('is false when every dropdown sits on "All"', () {
      const filter = ShoesFilter(category: 'All', type: 'All', season: 'All');

      expect(filter.isActive, isFalse);
    });

    test('ignores the search query', () {
      expect(const ShoesFilter(searchQuery: 'nike').isActive, isFalse);
    });

    test('is true for each narrowing filter', () {
      const red = Color(0xFFFF0000);

      expect(const ShoesFilter(colorPrimary: red).isActive, isTrue);
      expect(const ShoesFilter(colorExtra: red).isActive, isTrue);
      expect(const ShoesFilter(category: 'Boots').isActive, isTrue);
      expect(const ShoesFilter(type: 'Running').isActive, isTrue);
      expect(const ShoesFilter(season: 'Winter').isActive, isTrue);
      expect(const ShoesFilter(onlyFavorites: true).isActive, isTrue);
    });
  });
}
