import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shox/core/utils/app_exceptions.dart';

class ResetPasswordRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> resetPassword(String email) async {
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .where('userEmail', isEqualTo: email)
        .get();

    if (snapshot.docs.isEmpty) {
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
