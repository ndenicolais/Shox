import 'package:shox/features/shoes/models/shoes_model.dart';

/// Aggregate figures shown on the summary page of the PDF export.
class PdfCollectionSummary {
  /// Max rows in each ranking (brands, categories, colors).
  static const int maxRows = 5;

  final int totalPairs;
  final int favorites;
  final int brandCount;

  /// Brand → pairs, most used first then A-Z.
  final List<MapEntry<String, int>> topBrands;

  /// Category key → pairs, most used first then A-Z.
  final List<MapEntry<String, int>> topCategories;

  /// Primary color as ARGB int → pairs, most used first.
  final List<MapEntry<int, int>> topColors;

  const PdfCollectionSummary({
    required this.totalPairs,
    required this.favorites,
    required this.brandCount,
    required this.topBrands,
    required this.topCategories,
    required this.topColors,
  });

  factory PdfCollectionSummary.fromShoes(List<ShoesModel> shoes) {
    final brands = <String, int>{};
    final categories = <String, int>{};
    final colors = <int, int>{};
    for (final shoe in shoes) {
      final brand = shoe.brand.trim();
      if (brand.isNotEmpty) brands[brand] = (brands[brand] ?? 0) + 1;
      categories[shoe.category] = (categories[shoe.category] ?? 0) + 1;
      final argb = shoe.colorPrimary.toARGB32();
      colors[argb] = (colors[argb] ?? 0) + 1;
    }

    return PdfCollectionSummary(
      totalPairs: shoes.length,
      favorites: shoes.where((s) => s.isFavorite).length,
      brandCount: brands.length,
      topBrands: _ranked(brands, (a, b) => a.compareTo(b)),
      topCategories: _ranked(categories, (a, b) => a.compareTo(b)),
      topColors: _ranked(colors, (a, b) => a.compareTo(b)),
    );
  }

  static List<MapEntry<K, int>> _ranked<K>(
    Map<K, int> counts,
    int Function(K a, K b) tieBreak,
  ) {
    final entries = counts.entries.toList()
      ..sort((a, b) {
        final byCount = b.value.compareTo(a.value);
        return byCount != 0 ? byCount : tieBreak(a.key, b.key);
      });
    return entries.take(maxRows).toList();
  }
}
