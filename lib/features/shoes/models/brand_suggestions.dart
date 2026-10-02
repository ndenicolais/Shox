import 'package:shox/features/shoes/models/shoes_model.dart';

/// Brands already used in the collection, offered while typing a new brand.
class BrandSuggestions {
  /// Max options shown under the brand field.
  static const int maxOptions = 5;

  final List<String> brands;

  const BrandSuggestions(this.brands);

  /// Distinct brands (case-insensitive), most used first, then A-Z.
  ///
  /// Keeps the most frequent spelling of each brand.
  factory BrandSuggestions.fromShoes(List<ShoesModel> shoes) {
    final counts = <String, int>{};
    final spellings = <String, Map<String, int>>{};
    for (final shoe in shoes) {
      final brand = shoe.brand.trim();
      if (brand.isEmpty) continue;
      final key = brand.toLowerCase();
      counts[key] = (counts[key] ?? 0) + 1;
      final variants = spellings.putIfAbsent(key, () => {});
      variants[brand] = (variants[brand] ?? 0) + 1;
    }

    String bestSpelling(String key) =>
        spellings[key]!.entries.reduce((a, b) => b.value > a.value ? b : a).key;

    final keys = counts.keys.toList()
      ..sort((a, b) {
        final byCount = counts[b]!.compareTo(counts[a]!);
        return byCount != 0 ? byCount : a.compareTo(b);
      });
    return BrandSuggestions(keys.map(bestSpelling).toList());
  }

  /// Brands matching [query]: prefix matches first, then substring matches.
  ///
  /// Empty query, or a query equal to a known brand, returns nothing.
  List<String> match(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return const [];
    if (brands.any((b) => b.toLowerCase() == q)) return const [];

    final prefix = brands.where((b) => b.toLowerCase().startsWith(q));
    final contains = brands.where(
      (b) => !b.toLowerCase().startsWith(q) && b.toLowerCase().contains(q),
    );
    return [...prefix, ...contains].take(maxOptions).toList();
  }
}
