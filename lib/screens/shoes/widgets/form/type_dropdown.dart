import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/theme/app_font_sizes.dart';

class TypeDropdown extends StatelessWidget {
  final String selectedCategory;
  final String selectedType;
  final TextEditingController typeController;
  final Map<String, List<String>> categoryToTypes;
  final Map<String, String> translatedTypeOptions;
  final Function(String) onTypeChanged;

  const TypeDropdown({
    super.key,
    required this.selectedCategory,
    required this.selectedType,
    required this.typeController,
    required this.categoryToTypes,
    required this.translatedTypeOptions,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = selectedCategory.isNotEmpty;

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
                MingCuteIcons.mgc_shoe_line,
                color: Theme.of(context).colorScheme.tertiary,
                size: 20.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                AppLocalizations.of(context)!
                    .shoes_adder_screen_field_type
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
            value: selectedType.isNotEmpty ? selectedType : null,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              filled: true,
              fillColor: isEnabled
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.5),
            ),
            borderRadius: BorderRadius.circular(12.r),
            hint: Text(
              AppLocalizations.of(context)!.shoes_adder_screen_select_type,
              style: GoogleFonts.montserrat(
                color: Theme.of(context)
                    .colorScheme
                    .tertiary
                    .withValues(alpha: isEnabled ? 0.6 : 0.3),
                fontSize: AppFontSizes.small,
              ),
            ),
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: isEnabled
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context)
                      .colorScheme
                      .secondary
                      .withValues(alpha: 0.3),
            ),
            dropdownColor: Theme.of(context).colorScheme.primary,
            style: GoogleFonts.montserrat(
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: AppFontSizes.small,
            ),
            onChanged: isEnabled
                ? (newValue) {
                    if (newValue != null) {
                      onTypeChanged(newValue);
                      typeController.text = newValue;
                    }
                  }
                : null,
            items: isEnabled
                ? categoryToTypes[selectedCategory]?.map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(
                        translatedTypeOptions[type] ?? type,
                        style: GoogleFonts.montserrat(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: AppFontSizes.small,
                        ),
                      ),
                    );
                  }).toList()
                : [],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (selectedCategory.isEmpty) {
                return null;
              }
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!
                    .shoes_adder_screen_toast_error_type;
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
