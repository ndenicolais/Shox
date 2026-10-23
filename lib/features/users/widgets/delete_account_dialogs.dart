import 'package:flutter/material.dart';
import 'package:shox/common/widgets/delete_dialog_widget.dart';
import 'package:shox/l10n/app_localizations.dart';

/// Warns that the account and all its data will be deleted for good; true
/// when the user confirms.
Future<bool> showDeleteAccountDialog(BuildContext context) async {
  final l10n = AppLocalizations.of(context)!;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => DeleteDialogWidget(
      title: l10n.delete_account_screen_delete_dialog_title,
      content: l10n.delete_account_screen_delete_dialog_text,
      onCancelPressed: () => Navigator.of(context).pop(false),
      onConfirmPressed: () => Navigator.of(context).pop(true),
    ),
  );
  return confirmed ?? false;
}

/// Asks whether to export a backup before deleting the account; null when
/// the dialog is dismissed.
Future<bool?> showBackupChoiceDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.delete_account_screen_backup_title),
      content: Text(l10n.delete_account_screen_backup_text),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.delete_account_screen_skip_backup),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.delete_account_screen_backup_button),
        ),
      ],
    ),
  );
}
