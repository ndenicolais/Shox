import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shox/generated/l10n.dart';

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
      backgroundColor: Theme.of(context).colorScheme.secondary,
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
          fontFamily: 'CustomFont',
        ),
      ),
      content: Text(
        content,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 18.sp,
          fontFamily: 'CustomFont',
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
            S.current.custom_delete_dialog_cancel,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 14.sp,
              fontFamily: 'CustomFont',
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
            S.current.custom_delete_dialog_confirm,
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: 14.sp,
              fontFamily: 'CustomFont',
            ),
          ),
        ),
      ],
    );
  }
}
