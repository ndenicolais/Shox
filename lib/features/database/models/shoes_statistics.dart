import 'dart:ui';

import 'package:shox/features/shoes/models/shoes_model.dart';

/// Every aggregate shown by the Database and Profile screens, computed from
/// one read of the collection.
class ShoesStatistics {
  final int total;
  final int favorites;
  final Map<Color, int> byColor;
  final Map<String, int> byBrand;
  final Map<String, int> byCategory;
  final Map<String, int> byType;
  final ShoesModel? lastAdded;

  const ShoesStatistics({
    required this.total,
    required this.favorites,
    required this.byColor,
    required this.byBrand,
    required this.byCategory,
    required this.byType,
    required this.lastAdded,
  });

  factory ShoesStatistics.fromShoes(List<ShoesModel> shoes) {
    Map<K, int> countBy<K>(K Function(ShoesModel) key) {
      final counts = <K, int>{};
      for (final shoe in shoes) {
        counts.update(key(shoe), (n) => n + 1, ifAbsent: () => 1);
      }
      return counts;
    }

    ShoesModel? lastAdded;
    for (final shoe in shoes) {
      if (lastAdded == null || shoe.dateAdded.isAfter(lastAdded.dateAdded)) {
        lastAdded = shoe;
      }
    }

    return ShoesStatistics(
      total: shoes.length,
      favorites: shoes.where((shoe) => shoe.isFavorite).length,
      byColor: countBy((shoe) => Color(shoe.colorPrimary.toARGB32())),
      byBrand: countBy((shoe) => shoe.brand),
      byCategory: countBy((shoe) => shoe.category),
      byType: countBy((shoe) => shoe.type),
      lastAdded: lastAdded,
    );
  }

  String? get favoriteBrand => _mostFrequent(byBrand);
  String? get mostUsedCategory => _mostFrequent(byCategory);
  String? get mostUsedType => _mostFrequent(byType);
  Color? get mostUsedColor => _mostFrequent(byColor);

  /// Key with the highest count (the first one seen on a tie), or null when
  /// [counts] is empty.
  static K? _mostFrequent<K>(Map<K, int> counts) {
    if (counts.isEmpty) return null;
    return counts.entries.reduce((a, b) => b.value > a.value ? b : a).key;
  }
}
