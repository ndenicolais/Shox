import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResetPasswordRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> resetPassword(String email) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('userEmail', isEqualTo: email)
          .get();

      if (snapshot.docs.isEmpty) {
        throw Exception("email_not_found");
      }

      await _auth.sendPasswordResetEmail(email: email);

      return email;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
