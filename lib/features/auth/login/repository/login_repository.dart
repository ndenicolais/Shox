import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shox/core/utils/app_exceptions.dart';
import 'package:shox/core/utils/constants.dart';

class LoginRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> loginWithEmailPassword(
    String email,
    String password,
    bool rememberMe,
  ) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('userEmail', isEqualTo: email)
          .get();

      if (snapshot.docs.isEmpty) {
        throw const AuthException('email_not_found');
      }

      var userDoc = snapshot.docs.first;
      String primaryEmail = userDoc['userEmail'];
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: primaryEmail.trim(),
        password: password.trim(),
      );

      _logger.i("User successfully logged: $email");

      if (rememberMe) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool(AppConstants.prefsRememberMe, true);
        await prefs.setString(
            AppConstants.prefsUserId, userCredential.user?.uid ?? '');
      }

      return userCredential.user;
    } catch (e) {
      if (e.toString().contains("wrong-password")) {
        throw const AuthException('invalid_password');
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
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool(AppConstants.prefsRememberMe, true);
        await prefs.setString(
            AppConstants.prefsUserId, userCredential.user?.uid ?? '');
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

  Future<void> logout() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.prefsRememberMe);
      await prefs.remove(AppConstants.prefsUserId);
      _logger.i("User logged out successfully");
    } catch (e) {
      throw Exception('Error during logout: $e');
    }
  }
}
