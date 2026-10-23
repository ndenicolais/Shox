import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/common/widgets/delete_dialog_widget.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:shox/theme/app_spacing.dart';

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

/// Asks email/password users to type their password again before the
/// account is deleted; null when the dialog is dismissed.
Future<String?> showDeletePasswordDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (context) => const _DeletePasswordDialog(),
  );
}

class _DeletePasswordDialog extends StatefulWidget {
  const _DeletePasswordDialog();

  @override
  State<_DeletePasswordDialog> createState() => _DeletePasswordDialogState();
}

class _DeletePasswordDialogState extends State<_DeletePasswordDialog> {
  final TextEditingController _controller = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_controller.text.isEmpty) return;
    Navigator.of(context).pop(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.delete_account_screen_password_title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.delete_account_screen_password_text),
          SizedBox(height: AppSpacing.m.h),
          TextField(
            controller: _controller,
            autofocus: true,
            obscureText: _obscure,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              labelText: l10n.validator_password,
              prefixIcon: const Icon(MingCuteIcons.mgc_lock_line, size: 20),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscure
                      ? MingCuteIcons.mgc_eye_close_line
                      : MingCuteIcons.mgc_eye_2_line,
                  size: 20,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.custom_delete_dialog_cancel),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(l10n.delete_account_screen_password_confirm),
        ),
      ],
    );
  }
}
