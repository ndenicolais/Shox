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
    version: '4.1.0',
    bulletsBuilder: (l10n) => [
      l10n.changelog_v4_1_0_bullet_1,
      l10n.changelog_v4_1_0_bullet_2,
      l10n.changelog_v4_1_0_bullet_3,
      l10n.changelog_v4_1_0_bullet_4,
      l10n.changelog_v4_1_0_bullet_5,
      l10n.changelog_v4_1_0_bullet_6,
      l10n.changelog_v4_1_0_bullet_7,
      l10n.changelog_v4_1_0_bullet_8,
      l10n.changelog_v4_1_0_bullet_9,
      l10n.changelog_v4_1_0_bullet_10,
      l10n.changelog_v4_1_0_bullet_11,
      l10n.changelog_v4_1_0_bullet_12,
      l10n.changelog_v4_1_0_bullet_13,
      l10n.changelog_v4_1_0_bullet_14,
      l10n.changelog_v4_1_0_bullet_15,
      l10n.changelog_v4_1_0_bullet_16,
      l10n.changelog_v4_1_0_bullet_17,
      l10n.changelog_v4_1_0_bullet_18,
      l10n.changelog_v4_1_0_bullet_19,
      l10n.changelog_v4_1_0_bullet_20,
      l10n.changelog_v4_1_0_bullet_21,
      l10n.changelog_v4_1_0_bullet_22,
      l10n.changelog_v4_1_0_bullet_23,
      l10n.changelog_v4_1_0_bullet_24,
      l10n.changelog_v4_1_0_bullet_25,
      l10n.changelog_v4_1_0_bullet_26,
      l10n.changelog_v4_1_0_bullet_27,
      l10n.changelog_v4_1_0_bullet_28,
      l10n.changelog_v4_1_0_bullet_29,
      l10n.changelog_v4_1_0_bullet_30,
      l10n.changelog_v4_1_0_bullet_31,
      l10n.changelog_v4_1_0_bullet_32,
      l10n.changelog_v4_1_0_bullet_33,
    ],
  ),
];
