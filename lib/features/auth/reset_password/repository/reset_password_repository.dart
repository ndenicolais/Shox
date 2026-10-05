import 'package:firebase_auth/firebase_auth.dart';
import 'package:shox/core/utils/app_exceptions.dart';

class ResetPasswordRepository {
  final FirebaseAuth _auth;

  ResetPasswordRepository({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance;

  /// With email enumeration protection enabled Firebase never reports
  /// unknown emails, so `user-not-found` only surfaces when it is disabled.
  Future<String> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw const AuthException('email_not_found');
      }
      throw AuthException('reset_failed', e.toString());
    } catch (e) {
      throw AuthException('reset_failed', e.toString());
    }

    return email;
  }
}
