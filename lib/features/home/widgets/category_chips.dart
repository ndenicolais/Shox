import 'package:flutter/material.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/features/shoes/models/shoes_filter.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:shox/theme/app_spacing.dart';

/// Horizontal quick filters: all, favorites and one chip per category.
class CategoryChips extends StatelessWidget {
  /// Stored category value → translated label.
  final Map<String, String> categories;

  /// Stored category value, or [ShoesFilter.all].
  final String? selectedCategory;
  final bool onlyFavorites;
  final ValueChanged<String> onCategorySelected;
  final VoidCallback onFavoritesToggled;

  const CategoryChips({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onlyFavorites,
    required this.onCategorySelected,
    required this.onFavoritesToggled,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bool allSelected =
        selectedCategory == null || selectedCategory == ShoesFilter.all;

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _chip(
            context,
            label: l10n.home_screen_chip_all,
            selected: allSelected && !onlyFavorites,
            onSelected: () {
              if (onlyFavorites) onFavoritesToggled();
              onCategorySelected(ShoesFilter.all);
            },
          ),
          _chip(
            context,
            label: l10n.home_screen_chip_favorites,
            icon: onlyFavorites
                ? MingCuteIcons.mgc_heart_fill
                : MingCuteIcons.mgc_heart_line,
            selected: onlyFavorites,
            onSelected: onFavoritesToggled,
          ),
          for (final entry in categories.entries)
            _chip(
              context,
              label: entry.value,
              selected: selectedCategory == entry.key,
              onSelected: () => onCategorySelected(
                selectedCategory == entry.key ? ShoesFilter.all : entry.key,
              ),
            ),
        ],
      ),
    );
  }

  Widget _chip(
    BuildContext context, {
    required String label,
    required bool selected,
    required VoidCallback onSelected,
    IconData? icon,
  }) {
    final theme = Theme.of(context);
    final Color foreground =
        selected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.xs),
      child: ChoiceChip(
        label: Text(label),
        avatar: icon != null ? Icon(icon, size: 16, color: foreground) : null,
        selected: selected,
        onSelected: (_) => onSelected(),
        labelStyle: theme.textTheme.labelMedium?.copyWith(
          color: foreground,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
        ),
        side: selected
            ? BorderSide(color: theme.colorScheme.primary)
            : BorderSide(color: theme.colorScheme.outline),
      ),
    );
  }
}
