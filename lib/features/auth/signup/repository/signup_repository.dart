import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'package:shox/features/users/models/user_model.dart';

class SignupRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  Future<User?> signUpWithEmailPassword(
      UserModel user, String name, String email, String password) async {
    UserModel newUser = UserModel(
      userEmail: email,
      userName: name,
    );

    final emailCheck = await _firestore
        .collection('users')
        .where('userEmail', isEqualTo: newUser.userEmail)
        .get();

    if (emailCheck.docs.isNotEmpty) {
      throw Exception("email_already_register");
    }

    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: newUser.userEmail,
      password: password,
    );

    _logger.i("User successfully registered: ${newUser.userEmail}");

    await _firestore
        .collection('users')
        .doc(userCredential.user?.uid)
        .set(newUser.toFirestore());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remember_me', true);
    await prefs.setString('user_id', userCredential.user?.uid ?? '');

    return userCredential.user;
  }
}
