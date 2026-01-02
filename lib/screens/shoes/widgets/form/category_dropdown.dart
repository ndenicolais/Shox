import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/theme/app_font_sizes.dart';

class CategoryDropdown extends StatelessWidget {
  final String selectedCategory;
  final TextEditingController categoryController;
  final TextEditingController typeController;
  final Map<String, String> translatedCategoryOptions;
  final Function(String) onCategoryChanged;

  const CategoryDropdown({
    super.key,
    required this.selectedCategory,
    required this.categoryController,
    required this.typeController,
    required this.translatedCategoryOptions,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
          width: 1.w,
        ),
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                MingCuteIcons.mgc_grid_line,
                color: Theme.of(context).colorScheme.tertiary,
                size: 20.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                AppLocalizations.of(context)!
                    .shoes_adder_screen_field_category
                    .toUpperCase(),
                style: GoogleFonts.montserrat(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: AppFontSizes.small,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          DropdownButtonFormField<String>(
            value: selectedCategory.isNotEmpty ? selectedCategory : null,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              filled: true,
              fillColor: Theme.of(context).colorScheme.primary,
            ),
            borderRadius: BorderRadius.circular(12.r),
            hint: Text(
              AppLocalizations.of(context)!.shoes_adder_screen_select_category,
              style: GoogleFonts.montserrat(
                color: Theme.of(context)
                    .colorScheme
                    .tertiary
                    .withValues(alpha: 0.6),
                fontSize: AppFontSizes.small,
              ),
            ),
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Theme.of(context).colorScheme.secondary,
            ),
            dropdownColor: Theme.of(context).colorScheme.primary,
            style: GoogleFonts.montserrat(
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: AppFontSizes.small,
            ),
            onChanged: (newValue) {
              if (newValue != null) {
                onCategoryChanged(newValue);
                categoryController.text = newValue;
                typeController.text = '';
              }
            },
            items: translatedCategoryOptions.keys.map((category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(
                  translatedCategoryOptions[category] ?? category,
                  style: GoogleFonts.montserrat(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: AppFontSizes.small,
                  ),
                ),
              );
            }).toList(),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!
                    .shoes_adder_screen_toast_error_category;
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
