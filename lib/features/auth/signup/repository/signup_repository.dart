import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:shox/core/utils/app_exceptions.dart';
import 'package:shox/features/auth/services/auth_service.dart';
import 'package:shox/features/users/models/user_model.dart';

class SignupRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
  final Logger _logger = Logger();

  Future<User?> signUpWithEmailPassword(
    UserModel user,
    String name,
    String email,
    String password,
  ) async {
    UserModel newUser = UserModel(
      userEmail: email,
      userName: name,
    );

    final UserCredential userCredential;
    try {
      userCredential = await _auth.createUserWithEmailAndPassword(
        email: newUser.userEmail,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw const AuthException('email_already_register');
      }
      rethrow;
    }

    _logger.i("User successfully registered: ${newUser.userEmail}");

    await _firestore
        .collection('users')
        .doc(userCredential.user?.uid)
        .set(newUser.toFirestore());

    await _authService.saveSession(userCredential.user?.uid);

    return userCredential.user;
  }
}
