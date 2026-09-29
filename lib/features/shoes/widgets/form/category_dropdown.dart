import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shox/theme/app_spacing.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/theme/app_font_sizes.dart';
import 'package:shox/features/shoes/widgets/form/form_field_card.dart';

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
    return FormFieldCard(
      icon: MingCuteIcons.mgc_grid_line,
      label: AppLocalizations.of(context)!.shoes_adder_screen_field_category,
      child: DropdownButtonFormField<String>(
        initialValue: selectedCategory.isNotEmpty ? selectedCategory : null,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSpacing.s.w,
            vertical: AppSpacing.xs.h,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          filled: true,
          fillColor: Theme.of(context).cardColor,
        ),
        borderRadius: BorderRadius.circular(12.r),
        hint: Text(
          AppLocalizations.of(context)!.shoes_adder_screen_select_category,
          style: TextStyle(
            fontFamily: 'CustomFont',
            color:
                Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.6),
            fontSize: AppFontSizes.small,
          ),
        ),
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: Theme.of(context).colorScheme.secondary,
        ),
        dropdownColor: Theme.of(context).cardColor,
        style: TextStyle(
          fontFamily: 'CustomFont',
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
              style: TextStyle(
                fontFamily: 'CustomFont',
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
    );
  }
}
