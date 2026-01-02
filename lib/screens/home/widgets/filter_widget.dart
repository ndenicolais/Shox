import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shox/theme/app_font_sizes.dart';

class FilterWidget extends StatelessWidget {
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

  const FilterWidget({
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.home_screen_filter_title,
            style: GoogleFonts.montserrat(
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: AppFontSizes.medium,
              fontWeight: FontWeight.w600,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.r),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context)!.home_screen_filter_color_primary,
                style: GoogleFonts.montserrat(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: colorList.map((color) {
                return Padding(
                  padding: EdgeInsets.only(right: 8.r),
                  child: GestureDetector(
                    onTap: () => onColorSelected(color),
                    child: Container(
                      width: 24.w,
                      height: 24.h,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(50.r),
                        border: Border.all(
                          color: selectedColor == color
                              ? Theme.of(context).colorScheme.tertiary
                              : Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.r),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context)!.extra_colors,
                style: GoogleFonts.montserrat(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: colorList.map((color) {
                return Padding(
                  padding: EdgeInsets.only(right: 8.r),
                  child: GestureDetector(
                    onTap: () => onColorExtraSelected(color),
                    child: Container(
                      width: 24.w,
                      height: 24.h,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(50.r),
                        border: Border.all(
                          color: selectedColorExtra == color
                              ? Theme.of(context).colorScheme.tertiary
                              : Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 10.h),
          DropdownButtonFormField<String>(
            value: selectedCategory != null
                ? translatedCategoryOptions[selectedCategory]
                : null,
            items: ['All', ...translatedCategoryOptions.values].map((item) {
              return DropdownMenuItem<String>(
                  value: item,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.r),
                    child: Text(
                      item,
                      style: GoogleFonts.montserrat(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ));
            }).toList(),
            icon: Icon(
              MingCuteIcons.mgc_down_line,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            dropdownColor: Theme.of(context).colorScheme.primary,
            decoration: InputDecoration(
              labelText:
                  AppLocalizations.of(context)!.home_screen_filter_category,
            ),
            onChanged: onCategoryChanged,
          ),
          SizedBox(height: 10.h),
          if (selectedCategory != null)
            DropdownButtonFormField<String>(
              value: selectedType,
              items: _getAvailableTypeOptions().map((item) {
                return DropdownMenuItem<String>(
                    value: item,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.r),
                      child: Text(
                        item,
                        style: GoogleFonts.montserrat(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ));
              }).toList(),
              icon: Icon(
                MingCuteIcons.mgc_down_line,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              dropdownColor: Theme.of(context).colorScheme.primary,
              decoration: InputDecoration(
                labelText:
                    AppLocalizations.of(context)!.home_screen_filter_type,
              ),
              onChanged: onTypeChanged,
            ),
          SizedBox(height: 10.h),
          DropdownButtonFormField<String>(
            value: selectedSeason,
            items: ['All', ...translatedSeasonOptions.values].map((item) {
              return DropdownMenuItem<String>(
                  value: item,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.r),
                    child: Text(
                      item,
                      style: GoogleFonts.montserrat(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ));
            }).toList(),
            icon: Icon(
              MingCuteIcons.mgc_down_line,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            dropdownColor: Theme.of(context).colorScheme.primary,
            decoration: InputDecoration(
              labelText:
                  AppLocalizations.of(context)!.home_screen_filter_season,
            ),
            onChanged: onSeasonChanged,
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                      Theme.of(context).colorScheme.tertiary),
                ),
                onPressed: onReset,
                child: Text(
                  AppLocalizations.of(context)!.home_screen_filter_reset,
                  style: GoogleFonts.montserrat(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: AppFontSizes.normal,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                      Theme.of(context).colorScheme.secondary),
                ),
                onPressed: onApply,
                child: Text(
                  AppLocalizations.of(context)!.home_screen_filter_apply,
                  style: GoogleFonts.montserrat(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: AppFontSizes.normal,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
