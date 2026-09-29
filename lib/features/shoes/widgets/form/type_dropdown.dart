import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shox/theme/app_spacing.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/theme/app_font_sizes.dart';
import 'package:shox/features/shoes/widgets/form/form_field_card.dart';

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

    return FormFieldCard(
      icon: MingCuteIcons.mgc_shoe_line,
      label: AppLocalizations.of(context)!.shoes_adder_screen_field_type,
      child: DropdownButtonFormField<String>(
        initialValue: selectedType.isNotEmpty ? selectedType : null,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.s.w, vertical: AppSpacing.xs.h),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          filled: true,
          fillColor: isEnabled
              ? Theme.of(context).cardColor
              : Theme.of(context).cardColor.withValues(alpha: 0.5),
        ),
        borderRadius: BorderRadius.circular(12.r),
        hint: Text(
          AppLocalizations.of(context)!.shoes_adder_screen_select_type,
          style: TextStyle(
            fontFamily: 'CustomFont',
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
              : Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3),
        ),
        dropdownColor: Theme.of(context).cardColor,
        style: TextStyle(
          fontFamily: 'CustomFont',
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
                    style: TextStyle(
                      fontFamily: 'CustomFont',
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
    );
  }
}
