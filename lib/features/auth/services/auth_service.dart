import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shox/core/utils/constants.dart';

/// Shared auth helpers used by the login, signup, reset password and user
/// repositories: user lookup by email and persistence of the local session.
class AuthService {
  final FirebaseFirestore _firestore;

  AuthService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Returns the Firestore user document registered with [email], or null.
  Future<QueryDocumentSnapshot<Map<String, dynamic>>?> findUserByEmail(
    String email,
  ) async {
    final snapshot = await _firestore
        .collection('users')
        .where('userEmail', isEqualTo: email)
        .limit(1)
        .get();
    return snapshot.docs.isEmpty ? null : snapshot.docs.first;
  }

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
