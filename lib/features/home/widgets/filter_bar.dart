import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/l10n/app_localizations.dart';

class FilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final String searchQuery;
  final ValueChanged<String> onChanged;
  final VoidCallback onReset;
  final VoidCallback onFilter;
  final VoidCallback onToggleGrid;
  final VoidCallback onToggleFavorites;
  final bool filtersActive;
  final IconData currentIcon;
  final bool showOnlyFavorites;

  const FilterBar({
    super.key,
    required this.searchController,
    required this.searchQuery,
    required this.onChanged,
    required this.onReset,
    required this.onFilter,
    required this.onToggleGrid,
    required this.onToggleFavorites,
    required this.filtersActive,
    required this.currentIcon,
    required this.showOnlyFavorites,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: searchController,
            onTapOutside: (event) =>
                FocusManager.instance.primaryFocus?.unfocus(),
            style: TextStyle(
              fontFamily: 'CustomFont',
              color: Theme.of(context).colorScheme.secondary,
            ),
            cursorColor: Theme.of(context).colorScheme.onSurface,
            onChanged: onChanged,
            decoration: InputDecoration(
              prefixIcon: Icon(
                MingCuteIcons.mgc_search_2_line,
                size: 18.sp,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      tooltip: AppLocalizations.of(context)!.a11y_clear_search,
                      icon: Icon(
                        Icons.clear,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      onPressed: onReset,
                    )
                  : null,
              labelText: AppLocalizations.of(context)!.home_screen_search_bar,
            ),
          ),
        ),
        IconButton(
          tooltip: AppLocalizations.of(context)!.a11y_filters,
          icon: _animatedIcon(
            filtersActive
                ? MingCuteIcons.mgc_filter_fill
                : MingCuteIcons.mgc_filter_line,
            filtersActive
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: onFilter,
        ),
        IconButton(
          tooltip: AppLocalizations.of(context)!.a11y_toggle_grid,
          icon: _animatedIcon(
            currentIcon,
            Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: onToggleGrid,
        ),
        IconButton(
          tooltip: showOnlyFavorites
              ? AppLocalizations.of(context)!.a11y_show_all_shoes
              : AppLocalizations.of(context)!.a11y_show_only_favorites,
          icon: _animatedIcon(
            showOnlyFavorites
                ? MingCuteIcons.mgc_heart_fill
                : MingCuteIcons.mgc_heart_line,
            showOnlyFavorites
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: onToggleFavorites,
        ),
      ],
    );
  }

  /// Icon that scales in when it changes (grid layout, active state...).
  Widget _animatedIcon(IconData icon, Color color) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (child, animation) =>
          ScaleTransition(scale: animation, child: child),
      child: Icon(icon, key: ValueKey(icon), color: color),
    );
  }
}
