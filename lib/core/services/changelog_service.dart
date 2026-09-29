import 'package:shared_preferences/shared_preferences.dart';
import 'package:shox/core/constants/changelog.dart';
import 'package:shox/core/utils/constants.dart';

/// Decides which "what's new" entries to show after an update.
class ChangelogService {
  /// Returns the entries newer than the version the user last saw and
  /// records [currentVersion] as seen.
  ///
  /// On a fresh install nothing is shown: the current version is only
  /// recorded, so the dialog appears from the next update on.
  static Future<List<ChangelogEntry>> pendingEntries(
    String currentVersion, {
    List<ChangelogEntry>? entries,
  }) async {
    final all = entries ?? changelogEntries;
    final prefs = await SharedPreferences.getInstance();
    final lastSeen =
        prefs.getString(AppConstants.prefsLastSeenChangelogVersion);

    if (lastSeen == currentVersion) return const [];
    await prefs.setString(
      AppConstants.prefsLastSeenChangelogVersion,
      currentVersion,
    );
    if (lastSeen == null) return const [];

    final lastSeenIndex = all.indexWhere((e) => e.version == lastSeen);
    return lastSeenIndex == -1 ? all : all.sublist(0, lastSeenIndex);
  }
}
