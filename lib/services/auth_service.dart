import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shox/generated/l10n.dart';
import 'package:shox/theme/app_colors.dart';
import 'package:shox/widgets/custom_toast_bar.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User? get currentUser => _auth.currentUser;
  var logger = Logger();

  // LOGIN
  // Login method with email and password
  Future<User?> loginWithEmailPassword(String email, String password,
      BuildContext context, bool rememberMe) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      User? user = userCredential.user;

      if (user != null) {
        // Retrieve username from Firestore
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        String userName = userDoc.get('name');

        // Manage the "Remember Me" status
        if (rememberMe) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('remember_me', true);
        }

        // Show confirmation message with username
        if (context.mounted) {
          _showConfirmToastBar(
            context,
            '${S.current.toast_login_welcome}$userName!',
            MingCuteIcons.mgc_hands_clapping_fill,
          );
        }

        return user;
      }

      return null;
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        _handleLoginFirebaseAuthError(e, context);
      }
      return null;
    } catch (e) {
      logger.e("Error during email login: $e");
      if (context.mounted) {
        _showErrorSnackBar(context, "Generic error during login.");
      }
      return null;
    }
  }

  // Method for login with Google
  Future<User?> loginWithGoogle(BuildContext context, bool rememberMe) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Retrieve the Google user name
        String? googleUserName = user.displayName;

        if (googleUserName != null) {
          // Separate the full name and take only the first name
          List<String> nameParts = googleUserName.split(" ");
          googleUserName = nameParts[0];
        }

        // Manage the "Remember Me" status
        if (rememberMe) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('remember_me', true);
        }

        // Show confirmation message with username
        if (context.mounted) {
          _showConfirmToastBar(
            context,
            '${S.current.toast_login_welcome}$googleUserName!',
            MingCuteIcons.mgc_hands_clapping_fill,
          );
        }

        return user;
      }

      return null;
    } catch (e) {
      logger.e("Error signing in with Google: $e");
      if (context.mounted) {
        _showErrorSnackBar(context, "Error signing in with Google.");
      }
      return null;
    }
  }

  // Firebase Login error handling
  void _handleLoginFirebaseAuthError(
      FirebaseAuthException e, BuildContext context) {
    String errorMessage;
    switch (e.code) {
      case 'user-not-found':
        errorMessage = S.current.toast_login_user;
        break;
      case 'wrong-password':
        errorMessage = S.current.toast_login_wrong_password;
        break;
      case 'invalid-email':
        errorMessage = S.current.toast_login_invalid_email;
        break;
      case 'invalid-credential':
        errorMessage = S.current.toast_login_invalid_credential;
        break;
      default:
        errorMessage = S.current.toast_login_generic_error;
        logger.e(
            "FirebaseAuthException with unknown code: ${e.code}, message: ${e.message}");
    }
    _showErrorSnackBar(context, errorMessage);
  }

  // SIGNUP
  Future<User?> signUpWithEmailPassword(
      String name, String email, String password, BuildContext context) async {
    try {
      // User registration
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      User? user = userCredential.user;

      if (user != null) {
        // Save username and email to Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'name': name.trim(),
          'email': user.email,
        });

        if (context.mounted) {
          _showConfirmToastBar(
            context,
            '${S.current.toast_signup_welcome}$name!',
            MingCuteIcons.mgc_hands_clapping_fill,
          );
        }

        return user;
      }

      return null;
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        _handleSignupFirebaseAuthError(e, context);
      }
      return null;
    } catch (e) {
      logger.e("Error during signup: $e");
      if (context.mounted) {
        _showErrorSnackBar(context, "Generic error during signup.");
      }
      return null;
    }
  }

  // Firebase Signup error handling
  void _handleSignupFirebaseAuthError(
      FirebaseAuthException e, BuildContext context) {
    String errorMessage;
    switch (e.code) {
      case 'user-not-found':
        errorMessage = S.current.toast_login_user;
        break;
      case 'wrong-password':
        errorMessage = S.current.toast_login_wrong_password;
        break;
      case 'invalid-email':
        errorMessage = S.current.toast_login_invalid_email;
        break;
      case 'invalid-credential':
        errorMessage = S.current.toast_login_invalid_credential;
        break;
      default:
        errorMessage = S.current.toast_login_generic_error;
        logger.e("FirebaseAuthException: ${e.code}, message: ${e.message}");
    }
    _showErrorSnackBar(context, errorMessage);
  }

  // DELETE
  Future<void> deleteUserAccount(BuildContext context) async {
    User? user = _auth.currentUser;
    if (user != null) {
      // Check if user is signed in with Google and log out
      if (user.providerData
          .any((userInfo) => userInfo.providerId == 'google.com')) {
        await _googleSignIn.signOut();
      }

      try {
        await _deleteUserStorage(user.uid);
        await _deleteUserDatabase(user.uid);
        await _deleteUserHistory(user.uid);

        await user.delete();

        await googleSignOut();

        // Show confirmation message
        if (context.mounted) {
          _showConfirmToastBar(
            context,
            S.current.toast_delete_success,
            MingCuteIcons.mgc_check_fill,
          );
        }
      } catch (e) {
        // Show error message
        if (context.mounted) {
          _showErrorSnackBar(
              context, '${S.current.toast_delete_generic_error} $e');
        }
      }
    }
  }

  // This function deletes user data from the Firestore database
  Future<void> _deleteUserDatabase(String userId) async {
    try {
      QuerySnapshot shoesSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('shoes')
          .get();

      for (DocumentSnapshot doc in shoesSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete user's main document
      await _firestore.collection('users').doc(userId).delete();
    } catch (e) {
      throw Exception('${S.current.toast_delete_user_data} $e');
    }
  }

  // This function deletes user storage from the Firebase Storage
  Future<void> _deleteUserStorage(String userId) async {
    try {
      final shoesStorageRef =
          FirebaseStorage.instance.ref().child('shoes_images/$userId');

      final profileStorageRef =
          FirebaseStorage.instance.ref().child('profile_images/$userId');

      // Remove all shoes images
      try {
        ListResult shoesListResult = await shoesStorageRef.listAll();
        for (Reference item in shoesListResult.items) {
          await item.delete();
        }
        for (Reference prefix in shoesListResult.prefixes) {
          await prefix.delete();
        }
        // Delete the entire shoes folder
        await shoesStorageRef.delete();
      } catch (e) {
        logger.e('Error deleting shoes storage: $e');
      }

      // Delete all profile pictures
      try {
        ListResult profileListResult = await profileStorageRef.listAll();
        for (Reference item in profileListResult.items) {
          await item.delete();
        }
        for (Reference prefix in profileListResult.prefixes) {
          await prefix.delete();
        }
        // Delete the entire profile folder
        await profileStorageRef.delete();
      } catch (e) {
        logger.e('Error deleting profile storage: $e');
      }
    } catch (e) {
      throw Exception('${S.current.toast_delete_user_storage} $e');
    }
  }

  // This function deletes user history from the Firestore database
  Future<void> _deleteUserHistory(String userId) async {
    try {
      QuerySnapshot historySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('history')
          .get();

      for (DocumentSnapshot doc in historySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('${S.current.toast_delete_user_history} $e');
    }
  }

  // This function logout user from Google
  Future<void> googleSignOut() async {
    // Log out from Google (if the user has been authenticated with Google)
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();

    // Log out from Firebase
    await FirebaseAuth.instance.signOut();

    // Remove "Remember Me" preference
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('remember_me');
  }

  // Tosat for confirm messages
  void _showConfirmToastBar(BuildContext context, String title, IconData icon) {
    showCustomToastBar(
      context,
      position: DelightSnackbarPosition.bottom,
      color: AppColors.confirmColor,
      icon: Icon(icon),
      title: title,
    );
  }

  // Tosat for error messages
  void _showErrorSnackBar(BuildContext context, String? message) {
    if (message != null) {
      showCustomToastBar(
        context,
        position: DelightSnackbarPosition.top,
        color: AppColors.errorColor,
        icon: const Icon(
          MingCuteIcons.mgc_warning_fill,
        ),
        title: message,
      );
    }
  }
}
