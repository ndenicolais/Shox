import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shox/common/widgets/delete_dialog_widget.dart';
import 'package:shox/features/data_management/models/shoes_backup.dart';
import 'package:shox/l10n/app_localizations.dart';

/// Shows what the picked backup contains and warns that the current
/// collection will be replaced; true when the user confirms.
Future<bool> showRestoreBackupDialog(
  BuildContext context, {
  required ShoesBackup backup,
  required int currentCount,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final locale = Localizations.localeOf(context).toString();
  final createdAt = backup.manifest.createdAt;

  final summary = [
    if (backup.isLegacy)
      l10n.data_management_restore_dialog_legacy
    else if (createdAt != null)
      l10n.data_management_restore_dialog_date(
        DateFormat.yMMMMd(locale).add_Hm().format(createdAt),
      ),
    l10n.data_management_shoes_count(backup.shoes.length),
  ].join(' · ');

  final content = [
    summary,
    l10n.data_management_restore_dialog_warning(currentCount),
    if (backup.isLegacy) l10n.data_management_restore_dialog_legacy_note,
  ].join('\n\n');

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => DeleteDialogWidget(
      title: l10n.data_management_restore_dialog_title,
      content: content,
      confirmLabel: l10n.data_management_restore_confirm,
      onCancelPressed: () => Navigator.of(context).pop(false),
      onConfirmPressed: () => Navigator.of(context).pop(true),
    ),
  );
  return confirmed ?? false;
}
