import 'package:flutter/material.dart';
import 'package:shox/theme/app_spacing.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/l10n/app_localizations.dart';

class FilterSheet extends StatelessWidget {
  final Color? selectedColor;
  final Color? selectedColorExtra;
  final String? selectedCategory;
  final String? selectedType;
  final String selectedSeason;
  final Map<String, String> translatedCategoryOptions;
  final Map<String, String> translatedTypeOptions;
  final Map<String, String> translatedSeasonOptions;
  final Map<String, List<String>> categoryToTypes;
  final Function(Color) onColorSelected;
  final Function(Color) onColorExtraSelected;
  final Function(String?) onCategoryChanged;
  final Function(String?) onTypeChanged;
  final Function(String?) onSeasonChanged;
  final VoidCallback onReset;
  final VoidCallback onApply;
  final List<Color> colorList;

  const FilterSheet({
    super.key,
    required this.selectedColor,
    required this.selectedColorExtra,
    required this.selectedCategory,
    required this.selectedType,
    required this.selectedSeason,
    required this.translatedCategoryOptions,
    required this.translatedTypeOptions,
    required this.translatedSeasonOptions,
    required this.categoryToTypes,
    required this.onColorSelected,
    required this.onColorExtraSelected,
    required this.onCategoryChanged,
    required this.onTypeChanged,
    required this.onSeasonChanged,
    required this.onReset,
    required this.onApply,
    required this.colorList,
  });

  List<String> _getAvailableTypeOptions() {
    if (selectedCategory == null || selectedCategory == 'All') {
      return ['All', ...translatedTypeOptions.values];
    }

    final availableTypes = categoryToTypes[selectedCategory] ?? [];
    final translatedAvailableTypes = availableTypes
        .map((type) => translatedTypeOptions[type] ?? type)
        .toList();

    return ['All', ...translatedAvailableTypes];
  }

  /// Dropdown values keep the stored 'All' sentinel; only its label is
  /// translated.
  String _label(BuildContext context, String item) =>
      item == 'All' ? AppLocalizations.of(context)!.home_screen_chip_all : item;

  List<DropdownMenuItem<String>> _items(
    BuildContext context,
    List<String> values,
  ) =>
      values
          .map(
            (item) => DropdownMenuItem<String>(
              value: item,
              child: Text(_label(context, item)),
            ),
          )
          .toList();

  Widget _sectionLabel(BuildContext context, String text) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.xs),
        child: Text(
          text.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall,
        ),
      );

  Widget _swatches(
    BuildContext context, {
    required Color? selected,
    required Function(Color) onSelected,
  }) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: colorList.map((color) {
          final bool isSelected = selected == color;
          return Semantics(
            button: true,
            selected: isSelected,
            child: InkResponse(
              onTap: () => onSelected(color),
              radius: 22,
              child: Container(
                width: 36,
                height: 36,
                margin: const EdgeInsets.only(right: AppSpacing.xs, top: 4),
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? colors.onSurface : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: colors.outline),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const icon = Icon(MingCuteIcons.mgc_down_line);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.l,
        0,
        AppSpacing.l,
        AppSpacing.xl,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.home_screen_filter_title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.l),
            _sectionLabel(context, l10n.home_screen_filter_color_primary),
            _swatches(
              context,
              selected: selectedColor,
              onSelected: onColorSelected,
            ),
            const SizedBox(height: AppSpacing.m),
            _sectionLabel(context, l10n.extra_colors),
            _swatches(
              context,
              selected: selectedColorExtra,
              onSelected: onColorExtraSelected,
            ),
            const SizedBox(height: AppSpacing.l),
            DropdownButtonFormField<String>(
              initialValue: selectedCategory != null
                  ? translatedCategoryOptions[selectedCategory]
                  : null,
              items: _items(
                context,
                ['All', ...translatedCategoryOptions.values],
              ),
              icon: icon,
              decoration: InputDecoration(
                labelText: l10n.home_screen_filter_category,
              ),
              onChanged: onCategoryChanged,
            ),
            if (selectedCategory != null) ...[
              const SizedBox(height: AppSpacing.s),
              DropdownButtonFormField<String>(
                initialValue: selectedType,
                items: _items(context, _getAvailableTypeOptions()),
                icon: icon,
                decoration: InputDecoration(
                  labelText: l10n.home_screen_filter_type,
                ),
                onChanged: onTypeChanged,
              ),
            ],
            const SizedBox(height: AppSpacing.s),
            DropdownButtonFormField<String>(
              initialValue: selectedSeason,
              items: _items(
                context,
                ['All', ...translatedSeasonOptions.values],
              ),
              icon: icon,
              decoration: InputDecoration(
                labelText: l10n.home_screen_filter_season,
              ),
              onChanged: onSeasonChanged,
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReset,
                    child: Text(l10n.home_screen_filter_reset),
                  ),
                ),
                const SizedBox(width: AppSpacing.s),
                Expanded(
                  child: FilledButton(
                    onPressed: onApply,
                    child: Text(l10n.home_screen_filter_apply),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
