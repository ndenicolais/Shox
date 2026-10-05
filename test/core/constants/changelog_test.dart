import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shox/core/constants/changelog.dart';

void main() {
  test('sections follow the ChangeType order and skip empty types', () {
    String text(_) => '';
    final entry = ChangelogEntry(
      version: '1.0.0',
      items: [
        ChangelogItem(ChangeType.fixed, text),
        ChangelogItem(ChangeType.added, text),
        ChangelogItem(ChangeType.fixed, text),
      ],
    );

    expect(entry.sections.keys, [ChangeType.added, ChangeType.fixed]);
    expect(entry.sections[ChangeType.fixed], hasLength(2));
  });

  test('every changelog bullet in the ARB files is listed once', () {
    final arb = jsonDecode(File('lib/l10n/app_en.arb').readAsStringSync())
        as Map<String, dynamic>;
    final source = File('lib/core/constants/changelog.dart').readAsStringSync();

    final keys = arb.keys.where((k) => k.startsWith('changelog_v'));
    for (final key in keys) {
      expect(
        'l.$key)'.allMatches(source),
        hasLength(1),
        reason: '$key must appear exactly once in changelogEntries',
      );
    }
    expect(
      changelogEntries.fold<int>(0, (sum, e) => sum + e.items.length),
      keys.length,
    );
  });
}
