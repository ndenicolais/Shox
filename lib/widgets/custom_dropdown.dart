import 'package:flutter/material.dart';
import 'package:shox/theme/app_colors.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final AutovalidateMode? autovalidateMode;
  final List<DropdownMenuItem<T>> items;
  final FormFieldValidator<T>? validator;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.items,
    this.autovalidateMode,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      onChanged: onChanged,
      autovalidateMode: autovalidateMode,
      items: items,
      dropdownColor: Theme.of(context).colorScheme.primary,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.tertiary,
          fontFamily: 'CustomFont',
        ),
        errorStyle: const TextStyle(
          color: AppColors.errorColor,
          fontFamily: 'CustomFont',
          fontWeight: FontWeight.bold,
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.errorColor,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ),
      style: TextStyle(
        color: Theme.of(context).colorScheme.secondary,
        fontFamily: 'CustomFont',
      ),
      validator: validator,
    );
  }
}
