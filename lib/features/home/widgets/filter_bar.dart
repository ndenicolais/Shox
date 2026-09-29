import 'package:flutter/material.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:shox/theme/app_radius.dart';
import 'package:shox/theme/app_spacing.dart';

/// Home search field (pill) with the button that opens the filter sheet.
class FilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final VoidCallback onFilter;
  final bool filtersActive;

  const FilterBar({
    super.key,
    required this.searchController,
    required this.onChanged,
    required this.onClear,
    required this.onFilter,
    required this.filtersActive,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final pill = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.pill),
      borderSide: BorderSide.none,
    );

    return Row(
      children: [
        Expanded(
          child: ValueListenableBuilder<TextEditingValue>(
            valueListenable: searchController,
            builder: (context, value, _) => TextField(
              controller: searchController,
              onTapOutside: (event) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              onChanged: onChanged,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: l10n.home_screen_search_bar,
                prefixIcon: const Icon(MingCuteIcons.mgc_search_2_line),
                suffixIcon: value.text.isNotEmpty
                    ? IconButton(
                        tooltip: l10n.a11y_clear_search,
                        icon: const Icon(MingCuteIcons.mgc_close_line),
                        onPressed: onClear,
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: pill,
                enabledBorder: pill,
                focusedBorder: pill.copyWith(
                  borderSide: BorderSide(color: colors.primary, width: 1.5),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.s),
        Badge(
          isLabelVisible: filtersActive,
          backgroundColor: colors.secondary,
          smallSize: 10,
          child: IconButton.filled(
            tooltip: l10n.a11y_filters,
            style: IconButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
              minimumSize: const Size(48, 48),
            ),
            onPressed: onFilter,
            icon: const Icon(MingCuteIcons.mgc_filter_2_line),
          ),
        ),
      ],
    );
  }
}
