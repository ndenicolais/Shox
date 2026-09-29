import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
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
    final l10n = AppLocalizations.of(context)!;
    return FormFieldCard(
      icon: MingCuteIcons.mgc_grid_line,
      label: l10n.shoes_adder_screen_field_category,
      child: DropdownButtonFormField<String>(
        initialValue: selectedCategory.isNotEmpty ? selectedCategory : null,
        hint: Text(l10n.shoes_adder_screen_select_category),
        icon: const Icon(MingCuteIcons.mgc_down_line),
        onChanged: (newValue) {
          if (newValue != null) {
            onCategoryChanged(newValue);
            categoryController.text = newValue;
            typeController.text = '';
          }
        },
        items: translatedCategoryOptions.keys
            .map(
              (category) => DropdownMenuItem<String>(
                value: category,
                child: Text(translatedCategoryOptions[category] ?? category),
              ),
            )
            .toList(),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => value == null || value.isEmpty
            ? l10n.shoes_adder_screen_toast_error_category
            : null,
      ),
    );
  }
}
