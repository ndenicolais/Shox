import 'package:shox/l10n/app_localizations.dart';

class ChangelogEntry {
  final String version;
  final List<String> Function(AppLocalizations l10n) bulletsBuilder;

  const ChangelogEntry({
    required this.version,
    required this.bulletsBuilder,
  });
}

final List<ChangelogEntry> changelogEntries = [
  ChangelogEntry(
    version: '5.0.0',
    bulletsBuilder: (l10n) => [
      l10n.changelog_v5_0_0_bullet_1,
      l10n.changelog_v5_0_0_bullet_2,
      l10n.changelog_v5_0_0_bullet_3,
      l10n.changelog_v5_0_0_bullet_4,
      l10n.changelog_v5_0_0_bullet_5,
      l10n.changelog_v5_0_0_bullet_6,
      l10n.changelog_v5_0_0_bullet_7,
      l10n.changelog_v5_0_0_bullet_8,
      l10n.changelog_v5_0_0_bullet_9,
      l10n.changelog_v5_0_0_bullet_10,
      l10n.changelog_v5_0_0_bullet_11,
      l10n.changelog_v5_0_0_bullet_12,
      l10n.changelog_v5_0_0_bullet_13,
    ],
  ),
];
