import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shox/theme/app_colors.dart';

class CustomDeleteDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onCancelPressed;
  final VoidCallback onConfirmPressed;

  const CustomDeleteDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onCancelPressed,
    required this.onConfirmPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.errorColor,
      title: Text(
        title,
        style: GoogleFonts.montserrat(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 22.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Text(
        content,
        style: GoogleFonts.montserrat(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 16.sp,
        ),
      ),
      actions: [
        TextButton(
          onPressed: onCancelPressed,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(
              Theme.of(context).colorScheme.tertiary,
            ),
          ),
          child: Text(
            AppLocalizations.of(context)!.custom_delete_dialog_cancel,
            style: GoogleFonts.montserrat(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 12.sp,
            ),
          ),
        ),
        TextButton(
          onPressed: onConfirmPressed,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
          child: Text(
            AppLocalizations.of(context)!.custom_delete_dialog_confirm,
            style: GoogleFonts.montserrat(
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: 12.sp,
            ),
          ),
        ),
      ],
    );
  }
}
