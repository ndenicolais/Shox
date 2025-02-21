import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
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
      icon: Icon(
        MingCuteIcons.mgc_down_line,
        color: Theme.of(context).colorScheme.tertiary,
      ),
      dropdownColor: Theme.of(context).colorScheme.primary,
      decoration: InputDecoration(
        labelText: label,
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.errorColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ),
      style: GoogleFonts.montserrat(
        color: Theme.of(context).colorScheme.secondary,
      ),
      validator: validator,
    );
  }
}
