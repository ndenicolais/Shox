import 'package:shared_preferences/shared_preferences.dart';
import 'package:shox/core/utils/constants.dart';

/// Shared auth helpers used by the login, signup and user repositories:
/// persistence of the local session.
///
/// Email existence is never checked by querying Firestore: the `users`
/// collection is readable only by its owner (see `firestore.rules`), so the
/// repositories rely on the Firebase Auth error codes instead.
class AuthService {
  /// Keeps the user signed in across app restarts.
  Future<void> saveSession(String? userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefsRememberMe, true);
    await prefs.setString(AppConstants.prefsUserId, userId ?? '');
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.prefsRememberMe);
    await prefs.remove(AppConstants.prefsUserId);
  }
}
