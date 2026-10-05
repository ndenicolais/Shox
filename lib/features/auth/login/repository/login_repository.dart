import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shox/core/utils/app_exceptions.dart';
import 'package:shox/features/auth/services/auth_service.dart';

class LoginRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final AuthService _authService;
  final GoogleSignIn _googleSignIn;
  final Logger _logger = Logger();

  /// Dependencies default to the real Firebase/Google instances; tests can
  /// pass fakes.
  LoginRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    AuthService? authService,
    GoogleSignIn? googleSignIn,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _authService = authService ?? AuthService(),
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  Future<User?> loginWithEmailPassword(
    String email,
    String password,
    bool rememberMe,
  ) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      _logger.i("User successfully logged: $email");

      if (rememberMe) {
        await _authService.saveSession(userCredential.user?.uid);
      }

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // With email enumeration protection enabled Firebase returns
      // `invalid-credential` for both an unknown email and a wrong password.
      switch (e.code) {
        case 'user-not-found':
          throw const AuthException('email_not_found');
        case 'wrong-password':
          throw const AuthException('invalid_password');
        case 'invalid-credential':
          throw const AuthException('invalid_credentials');
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> loginWithGoogle(bool rememberMe) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      final User? user = userCredential.user;
      bool isNewUser = false;

      if (user != null) {
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          isNewUser = true;
          final displayName = user.displayName ?? 'User ${user.uid}';
          final firstName = displayName.split(' ').first;
          await _firestore.collection('users').doc(user.uid).set({
            'userEmail': user.email,
            'userName': firstName,
            'userImage': user.photoURL,
            'userDate': DateTime.now(),
          });
          _logger.i(
            "User created on Firestore with Google: ${user.email}, name: $firstName",
          );
        }
      }

      if (rememberMe) {
        await _authService.saveSession(userCredential.user?.uid);
      }

      return {'user': user, 'isNewUser': isNewUser};
    } on PlatformException catch (e) {
      _logger.e("Google sign-in failed: ${e.code} ${e.message}");
      if (e.code == GoogleSignIn.kNetworkError) {
        throw const AuthException('network_error');
      }
      throw AuthException('google_sign_in_failed', e.code);
    }
  }
}
