import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shox/theme/app_font_sizes.dart';

class ErrorStateWidget extends StatelessWidget {
  final String message;

  const ErrorStateWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: GoogleFonts.montserrat(
          color: Theme.of(context).colorScheme.tertiary,
          fontSize: AppFontSizes.mediumLarge,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
