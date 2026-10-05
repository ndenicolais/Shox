import 'package:flutter/material.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/core/constants/changelog.dart';
import 'package:shox/l10n/app_localizations.dart';

class ChangelogDialogWidget extends StatelessWidget {
  final List<ChangelogEntry> entries;

  const ChangelogDialogWidget({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.changelog_dialog_title),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final entry in entries) ...[
              Text(
                'v${entry.version}',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              for (final section in entry.sections.entries) ...[
                const SizedBox(height: 12),
                _SectionHeader(type: section.key),
                const SizedBox(height: 6),
                for (final item in section.value)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('•  '),
                        Expanded(child: Text(item.textBuilder(l10n))),
                      ],
                    ),
                  ),
              ],
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            l10n.changelog_dialog_close,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final ChangeType type;

  const _SectionHeader({required this.type});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = Theme.of(context).colorScheme.primary;
    final (icon, label) = switch (type) {
      ChangeType.added => (
          MingCuteIcons.mgc_sparkles_line,
          l10n.changelog_section_added,
        ),
      ChangeType.improved => (
          MingCuteIcons.mgc_rocket_line,
          l10n.changelog_section_improved,
        ),
      ChangeType.fixed => (
          MingCuteIcons.mgc_bug_line,
          l10n.changelog_section_fixed,
        ),
      ChangeType.security => (
          MingCuteIcons.mgc_shield_line,
          l10n.changelog_section_security,
        ),
    };
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: color, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
