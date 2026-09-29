import 'package:flutter/material.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:shox/theme/app_radius.dart';
import 'package:shox/theme/app_spacing.dart';

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

/// Warning icon, title and explanation at the top of the screen.
class DeleteAccountHeader extends StatelessWidget {
  const DeleteAccountHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final error = theme.colorScheme.error;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xxl,
        horizontal: AppSpacing.xxl,
      ),
      child: Column(
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: error.withValues(alpha: 0.12),
              border: Border.all(
                color: error.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child:
                Icon(MingCuteIcons.mgc_delete_2_line, size: 44, color: error),
          ),
          const SizedBox(height: AppSpacing.m),
          Text(
            l10n.delete_account_screen_text_a,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.m),
          Text(
            l10n.delete_account_screen_text_b,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// Card listing what gets deleted with the account.
class DeleteAccountConsequencesCard extends StatelessWidget {
  const DeleteAccountConsequencesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final items = [
      (MingCuteIcons.mgc_user_3_line, l10n.delete_account_screen_item_a),
      (MingCuteIcons.mgc_box_2_line, l10n.delete_account_screen_item_b),
      (MingCuteIcons.mgc_photo_album_line, l10n.delete_account_screen_item_c),
    ];

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.l,
              AppSpacing.l,
              AppSpacing.l,
              AppSpacing.s,
            ),
            child: Row(
              children: [
                Icon(
                  MingCuteIcons.mgc_information_line,
                  color: theme.colorScheme.onSurface,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  l10n.delete_account_screen_what_happens,
                  style: theme.textTheme.titleSmall,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.l),
            child: Column(
              children: [
                for (final (index, (icon, label)) in items.indexed) ...[
                  if (index > 0) const SizedBox(height: AppSpacing.s),
                  _ConsequenceRow(icon: icon, label: label),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConsequenceRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ConsequenceRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final error = Theme.of(context).colorScheme.error;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          child: Icon(icon, size: 18, color: error),
        ),
        const SizedBox(width: AppSpacing.s),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ),
      ],
    );
  }
}

/// Red banner stating that the deletion cannot be undone.
class DeleteAccountWarningBanner extends StatelessWidget {
  const DeleteAccountWarningBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final error = theme.colorScheme.error;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: error.withValues(alpha: 0.35), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(MingCuteIcons.mgc_alert_line, color: error, size: 22),
          const SizedBox(width: AppSpacing.s),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.delete_account_screen_text_c,
              style: theme.textTheme.bodyMedium?.copyWith(color: error),
            ),
          ),
        ],
      ),
    );
  }
}
