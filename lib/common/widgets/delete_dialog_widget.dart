import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:shox/theme/app_spacing.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/common/widgets/button_widget.dart';

/// Confirmation dialog (delete, leave without saving...): warning icon,
/// title, message and cancel / confirm buttons.
class DeleteDialogWidget extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onCancelPressed;
  final VoidCallback onConfirmPressed;

  /// Overrides the default "Cancel" / "Delete" button labels.
  final String? cancelLabel;
  final String? confirmLabel;

  const DeleteDialogWidget({
    super.key,
    required this.title,
    required this.content,
    required this.onCancelPressed,
    required this.onConfirmPressed,
    this.cancelLabel,
    this.confirmLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      contentPadding: const EdgeInsets.all(AppSpacing.xl),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: theme.colorScheme.error.withValues(alpha: 0.1),
            child: Icon(
              MingCuteIcons.mgc_alert_line,
              size: 28,
              color: theme.colorScheme.error,
            ),
          ),
          const SizedBox(height: AppSpacing.m),
          Text(
            title,
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Expanded(
                child: ButtonWidget(
                  isOutline: true,
                  onPressed: onCancelPressed,
                  text: cancelLabel ?? l10n.custom_delete_dialog_cancel,
                ),
              ),
              const SizedBox(width: AppSpacing.s),
              Expanded(
                child: ButtonWidget(
                  onPressed: onConfirmPressed,
                  text: confirmLabel ?? l10n.custom_delete_dialog_confirm,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
