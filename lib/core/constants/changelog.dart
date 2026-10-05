import 'package:shox/l10n/app_localizations.dart';

/// Kind of change, used to group the bullets of a version into sections.
/// The enum order is the order of the sections in the dialog.
enum ChangeType { added, improved, fixed, security }

class ChangelogItem {
  final ChangeType type;
  final String Function(AppLocalizations l10n) textBuilder;

  const ChangelogItem(this.type, this.textBuilder);
}

class ChangelogEntry {
  final String version;
  final List<ChangelogItem> items;

  const ChangelogEntry({
    required this.version,
    required this.items,
  });

  /// Items grouped by [ChangeType] in enum order; empty types are omitted.
  Map<ChangeType, List<ChangelogItem>> get sections => {
        for (final type in ChangeType.values)
          if (items.any((item) => item.type == type))
            type: items.where((item) => item.type == type).toList(),
      };
}

final List<ChangelogEntry> changelogEntries = [
  ChangelogEntry(
    version: '5.0.0',
    items: [
      ChangelogItem(ChangeType.added, (l) => l.changelog_v5_0_0_bullet_1),
      ChangelogItem(ChangeType.added, (l) => l.changelog_v5_0_0_bullet_2),
      ChangelogItem(ChangeType.improved, (l) => l.changelog_v5_0_0_bullet_3),
      ChangelogItem(ChangeType.improved, (l) => l.changelog_v5_0_0_bullet_4),
      ChangelogItem(ChangeType.improved, (l) => l.changelog_v5_0_0_bullet_5),
      ChangelogItem(ChangeType.improved, (l) => l.changelog_v5_0_0_bullet_6),
      ChangelogItem(ChangeType.improved, (l) => l.changelog_v5_0_0_bullet_7),
      ChangelogItem(ChangeType.improved, (l) => l.changelog_v5_0_0_bullet_8),
      ChangelogItem(ChangeType.fixed, (l) => l.changelog_v5_0_0_bullet_9),
      ChangelogItem(ChangeType.added, (l) => l.changelog_v5_0_0_bullet_10),
      ChangelogItem(ChangeType.added, (l) => l.changelog_v5_0_0_bullet_11),
      ChangelogItem(ChangeType.improved, (l) => l.changelog_v5_0_0_bullet_12),
      ChangelogItem(ChangeType.improved, (l) => l.changelog_v5_0_0_bullet_13),
      ChangelogItem(ChangeType.fixed, (l) => l.changelog_v5_0_0_bullet_14),
      ChangelogItem(ChangeType.improved, (l) => l.changelog_v5_0_0_bullet_15),
      ChangelogItem(ChangeType.fixed, (l) => l.changelog_v5_0_0_bullet_16),
      ChangelogItem(ChangeType.fixed, (l) => l.changelog_v5_0_0_bullet_17),
      ChangelogItem(ChangeType.added, (l) => l.changelog_v5_0_0_bullet_18),
      ChangelogItem(ChangeType.added, (l) => l.changelog_v5_0_0_bullet_19),
      ChangelogItem(ChangeType.security, (l) => l.changelog_v5_0_0_bullet_20),
    ],
  ),
];
