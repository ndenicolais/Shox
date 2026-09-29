import 'package:flutter/material.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';

/// Immutable description of the filters applied to the shoes list.
///
/// Pure logic: no Flutter context, no Firestore, no side effects on the
/// source list. Kept out of the widget tree so it can be unit tested.
@immutable
class ShoesFilter {
  /// Sentinel used by the UI dropdowns to mean "no filter on this field".
  static const String all = 'All';

  final String searchQuery;
  final bool onlyFavorites;
  final Color? colorPrimary;
  final Color? colorExtra;
  final String? category;
  final String? type;
  final String season;

  /// Translated labels for the shoe types, needed because [type] holds the
  /// value shown in the dropdown, while the model stores the untranslated one.
  final Map<String, String> translatedTypeOptions;

  /// Translated labels for the shoe categories, used only by the search so
  /// that users can type the category name in their own language.
  final Map<String, String> translatedCategoryOptions;

  const ShoesFilter({
    this.searchQuery = '',
    this.onlyFavorites = false,
    this.colorPrimary,
    this.colorExtra,
    this.category = all,
    this.type = all,
    this.season = all,
    this.translatedTypeOptions = const {},
    this.translatedCategoryOptions = const {},
  });

  /// True when at least one filter actually narrows the list.
  ///
  /// [searchQuery] is excluded on purpose: the search field has its own
  /// clear button, so it must not light up the filter icon.
  bool get isActive =>
      colorPrimary != null ||
      colorExtra != null ||
      (category != null && category != all) ||
      (type != null && type != all) ||
      season != all ||
      onlyFavorites;

  /// Returns a new list, sorted by most recently added first, containing only
  /// the shoes matching every filter. The [shoes] list is never mutated.
  List<ShoesModel> apply(List<ShoesModel> shoes) {
    final result = shoes.where(_matches).toList();
    result.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
    return result;
  }

  /// Case-insensitive match of [searchQuery] against brand, notes, type and
  /// category (both the stored value and its translated label).
  bool _matchesSearch(ShoesModel shoes) {
    final query = searchQuery.toLowerCase();
    final fields = [
      shoes.brand,
      shoes.notes,
      shoes.type,
      translatedTypeOptions[shoes.type],
      shoes.category,
      translatedCategoryOptions[shoes.category],
    ];
    return fields.any((field) => field?.toLowerCase().contains(query) ?? false);
  }

  bool _matches(ShoesModel shoes) {
    if (searchQuery.isNotEmpty && !_matchesSearch(shoes)) return false;
    if (onlyFavorites && !shoes.isFavorite) return false;
    if (colorPrimary != null && shoes.colorPrimary != colorPrimary) {
      return false;
    }
    if (colorExtra != null) {
      final extra = shoes.colorExtra;
      if (extra == null || extra.isEmpty) return false;
      if (!extra.contains(colorExtra!.toARGB32())) return false;
    }
    if (category != null && category != all && shoes.category != category) {
      return false;
    }
    if (type != null &&
        type != all &&
        (translatedTypeOptions[shoes.type] ?? shoes.type) != type) {
      return false;
    }
    if (season != all && shoes.season != season) return false;

    return true;
  }
}
