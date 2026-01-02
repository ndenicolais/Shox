import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FilterBarWidget extends StatelessWidget {
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

  const FilterBarWidget({
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
            style: GoogleFonts.montserrat(
              color: Theme.of(context).colorScheme.secondary,
            ),
            cursorColor: Theme.of(context).colorScheme.tertiary,
            onChanged: onChanged,
            decoration: InputDecoration(
              prefixIcon: Icon(
                MingCuteIcons.mgc_search_2_line,
                size: 18.sp,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      onPressed: onReset,
                    )
                  : null,
              labelText: AppLocalizations.of(context)!.home_screen_search_bar,
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            filtersActive
                ? MingCuteIcons.mgc_filter_fill
                : MingCuteIcons.mgc_filter_line,
            color: filtersActive
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.tertiary,
          ),
          onPressed: onFilter,
        ),
        IconButton(
          icon: Icon(
            currentIcon,
            color: Theme.of(context).colorScheme.tertiary,
          ),
          onPressed: onToggleGrid,
        ),
        IconButton(
          icon: Icon(
            showOnlyFavorites
                ? MingCuteIcons.mgc_heart_fill
                : MingCuteIcons.mgc_heart_line,
            color: showOnlyFavorites
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.tertiary,
          ),
          onPressed: onToggleFavorites,
        ),
      ],
    );
  }
}
