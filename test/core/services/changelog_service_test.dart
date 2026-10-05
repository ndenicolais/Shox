import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shox/core/constants/changelog.dart';
import 'package:shox/core/services/changelog_service.dart';
import 'package:shox/core/utils/constants.dart';

ChangelogEntry entry(String version) =>
    ChangelogEntry(version: version, items: const []);

void main() {
  // Newest first, as in changelog.dart.
  final entries = [entry('5.0.0'), entry('4.1.0'), entry('4.0.0')];

  Future<String?> lastSeen() async => (await SharedPreferences.getInstance())
      .getString(AppConstants.prefsLastSeenChangelogVersion);

  test('fresh install shows nothing but records the version', () async {
    SharedPreferences.setMockInitialValues({});

    final result =
        await ChangelogService.pendingEntries('5.0.0', entries: entries);

    expect(result, isEmpty);
    expect(await lastSeen(), '5.0.0');
  });

  test('shows only the entries newer than the last seen version', () async {
    SharedPreferences.setMockInitialValues({
      AppConstants.prefsLastSeenChangelogVersion: '4.0.0',
    });

    final result =
        await ChangelogService.pendingEntries('5.0.0', entries: entries);

    expect(result.map((e) => e.version), ['5.0.0', '4.1.0']);
    expect(await lastSeen(), '5.0.0');
  });

  test('shows everything when the last seen version is unknown', () async {
    SharedPreferences.setMockInitialValues({
      AppConstants.prefsLastSeenChangelogVersion: '3.2.0',
    });

    final result =
        await ChangelogService.pendingEntries('5.0.0', entries: entries);

    expect(result, hasLength(3));
  });

  test('shows nothing when the version was already seen', () async {
    SharedPreferences.setMockInitialValues({
      AppConstants.prefsLastSeenChangelogVersion: '5.0.0',
    });

    final result =
        await ChangelogService.pendingEntries('5.0.0', entries: entries);

    expect(result, isEmpty);
  });
}
