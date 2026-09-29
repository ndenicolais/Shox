import 'package:firebase_auth/firebase_auth.dart';
import 'package:shox/core/utils/app_exceptions.dart';
import 'package:shox/features/auth/services/auth_service.dart';

class ResetPasswordRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();

  Future<String> resetPassword(String email) async {
    if (await _authService.findUserByEmail(email) == null) {
      throw const AuthException('email_not_found');
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw AuthException('reset_failed', e.toString());
    }

    return email;
  }
}
