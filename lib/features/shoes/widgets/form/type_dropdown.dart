import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
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
    final l10n = AppLocalizations.of(context)!;
    final bool isEnabled = selectedCategory.isNotEmpty;

    return FormFieldCard(
      icon: MingCuteIcons.mgc_shoe_line,
      label: l10n.shoes_adder_screen_field_type,
      child: DropdownButtonFormField<String>(
        initialValue: selectedType.isNotEmpty ? selectedType : null,
        hint: Text(l10n.shoes_adder_screen_select_type),
        icon: const Icon(MingCuteIcons.mgc_down_line),
        onChanged: isEnabled
            ? (newValue) {
                if (newValue != null) {
                  onTypeChanged(newValue);
                  typeController.text = newValue;
                }
              }
            : null,
        items: isEnabled
            ? (categoryToTypes[selectedCategory] ?? [])
                .map(
                  (type) => DropdownMenuItem<String>(
                    value: type,
                    child: Text(translatedTypeOptions[type] ?? type),
                  ),
                )
                .toList()
            : const [],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (selectedCategory.isEmpty) return null;
          return value == null || value.isEmpty
              ? l10n.shoes_adder_screen_toast_error_type
              : null;
        },
      ),
    );
  }
}
