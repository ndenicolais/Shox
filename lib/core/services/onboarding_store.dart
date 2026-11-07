import 'package:shared_preferences/shared_preferences.dart';
import 'package:shox/core/utils/constants.dart';

/// Whether the first-launch introduction has been completed or skipped.
///
/// Built in `main()` from an already loaded [SharedPreferences], so [seen] is
/// read synchronously at startup.
class OnboardingStore {
  OnboardingStore(this._prefs);

  final SharedPreferences _prefs;

  bool get seen => _prefs.getBool(AppConstants.prefsOnboardingSeen) ?? false;

  Future<void> markSeen() =>
      _prefs.setBool(AppConstants.prefsOnboardingSeen, true);
}
