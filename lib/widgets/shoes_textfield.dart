import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shox/theme/app_colors.dart';

class ShoesTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization? textCapitalization;
  final int? maxLength;

  const ShoesTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.validator,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      decoration: InputDecoration(
        labelText: labelText,
        counterStyle: GoogleFonts.montserrat(
          color: Theme.of(context).colorScheme.tertiary,
        ),
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
      keyboardType: keyboardType,
      textCapitalization: textCapitalization!,
      textInputAction: textInputAction,
      style: GoogleFonts.montserrat(
        color: Theme.of(context).colorScheme.secondary,
      ),
      validator: validator,
      maxLength: maxLength,
      cursorColor: Theme.of(context).colorScheme.secondary,
    );
  }
}
