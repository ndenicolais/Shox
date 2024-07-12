import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animations/animations.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/pages/welcome_page.dart';
import 'package:shox/theme/app_colors.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  DeleteAccountPageState createState() => DeleteAccountPageState();
}

class DeleteAccountPageState extends State<DeleteAccountPage> {
  var logger = Logger();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _checkAccount() async {
    User? user = _auth.currentUser;
    if (user == null) return;

    if (user.providerData
        .any((userInfo) => userInfo.providerId == 'google.com')) {
      // Logout from Google
      await _googleSignIn.signOut();

      // // Re-authenticate with Google
      // try {
      //   GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      //   if (googleUser == null) {
      //     // The user canceled the sign-in
      //     _showErrorSnackBar('Re-authentication with Google failed.');
      //     return;
      //   }
      //   GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      //   AuthCredential credential = GoogleAuthProvider.credential(
      //     idToken: googleAuth.idToken,
      //     accessToken: googleAuth.accessToken,
      //   );
      //   await user.reauthenticateWithCredential(credential);
      // } catch (e) {
      //   _showErrorSnackBar('Re-authentication with Google failed.');
      //   return;
      // }
    } else {
      // Email/Password
      try {
        await showDialog(
          context: context,
          builder: (context) {
            final TextEditingController passwordController =
                TextEditingController();
            return SingleChildScrollView(
              child: AlertDialog(
                title: Text(
                  'Re-enter your account password to confirm deletion',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 14,
                    fontFamily: 'CustomFont',
                  ),
                ),
                content: TextField(
                  controller: passwordController,
                  cursorColor: Theme.of(context).colorScheme.secondary,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontFamily: 'CustomFont',
                    ),
                    hintText: 'Password',
                    prefixIcon: Icon(
                      MingCuteIcons.mgc_lock_fill,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontFamily: 'CustomFont',
                  ),
                  textInputAction: TextInputAction.done,
                ),
                actions: [
                  // TextButton(
                  //   child: Text(
                  //     'Cancel',
                  //     style: TextStyle(
                  //       color: Theme.of(context).colorScheme.tertiary,
                  //       fontFamily: 'CustomFont',
                  //     ),
                  //   ),
                  //   onPressed: () {
                  //     Navigator.of(context).pop(false);
                  //   },
                  // ),
                  TextButton(
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontFamily: 'CustomFont',
                      ),
                    ),
                    onPressed: () async {
                      String password = passwordController.text.trim();
                      if (password.isNotEmpty) {
                        try {
                          AuthCredential credential =
                              EmailAuthProvider.credential(
                            email: user.email!,
                            password: password,
                          );
                          await user.reauthenticateWithCredential(credential);
                          Navigator.of(context).pop();
                        } catch (e) {
                          _showErrorSnackBar('Re-authentication failed.');
                        }
                      }
                    },
                  ),
                ],
              ),
            );
          },
          barrierDismissible: false,
        );
      } catch (e) {
        _showErrorSnackBar('Re-authentication failed.');
        return;
      }
    }
  }

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
      logger.e('Error deleting user data: $e');
      throw Exception('Failed to delete user data: $e');
    }
  }

  Future<void> _deleteAccount() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Show a dialog to confirm account cancellation
        bool confirmDelete = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'DELETE',
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontSize: 20,
                fontFamily: 'CustomFontBold',
              ),
            ),
            content: Text(
              'Are you sure you want to delete your account?',
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontSize: 18,
                fontFamily: 'CustomFont',
              ),
            ),
            actions: <Widget>[
              TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                    AppColors.errorColor,
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontFamily: 'CustomFont',
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                    AppColors.confirmColor,
                  ),
                ),
                child: const Text(
                  'Confirm',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontFamily: 'CustomFont',
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          ),
          barrierDismissible: false,
        );

        if (confirmDelete == true) {
          // Check before deleting the account
          await _checkAccount();

          // Delete user data from Firestore
          await _deleteUserDatabase(user.uid);

          // Delete the user
          await user.delete();

          // Definitive logout from Google if the user is authenticated with Google
          if (user.providerData
              .any((userInfo) => userInfo.providerId == 'google.com')) {
            await _googleSignIn.signOut();
          }

          // Show confirm toastbar
          if (mounted) {
            DelightToastBar(
              snackbarDuration: const Duration(seconds: 2),
              builder: (context) => const ToastCard(
                color: AppColors.confirmColor,
                leading: Icon(
                  MingCuteIcons.mgc_check_fill,
                  size: 28,
                ),
                title: Text(
                  "Account deleted successfully",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              autoDismiss: true,
            ).show(context);
          }

          // Navigate to WelcomePage after deletion
          if (mounted) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const WelcomePage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeThroughTransition(
                    animation: animation,
                    secondaryAnimation: secondaryAnimation,
                    child: child,
                  );
                },
              ),
            );
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'requires-recent-login':
          errorMessage =
              'This operation is sensitive and requires recent authentication. Please log in again.';
          break;
        default:
          errorMessage = 'An error occurred. Please try again.';
      }
      _showErrorSnackBar(errorMessage);
    } catch (e) {
      _showErrorSnackBar("An unexpected error occurred. Please try again.");
    }
  }

  void _showErrorSnackBar(String? message) {
    if (message != null) {
      // Show error toastbar
      DelightToastBar(
        snackbarDuration: const Duration(seconds: 2),
        builder: (context) => ToastCard(
          color: AppColors.errorColor,
          leading: const Icon(
            MingCuteIcons.mgc_color_picker_fill,
            size: 28,
          ),
          title: Text(
            message,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 16,
            ),
          ),
        ),
        autoDismiss: true,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            MingCuteIcons.mgc_large_arrow_left_fill,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.secondary,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: Column(
              children: [
                Icon(
                  MingCuteIcons.mgc_user_x_fill,
                  size: 120,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(height: 80),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontSize: 18,
                      fontFamily: 'CustomFont',
                    ),
                    children: const <TextSpan>[
                      TextSpan(
                        text:
                            'On this page you can permanently delete your Account.',
                      ),
                      TextSpan(
                        text:
                            '\n\nConfirming the cancellation will also delete all the ',
                      ),
                      TextSpan(
                        text: 'Database',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ' linked to the ',
                      ),
                      TextSpan(
                        text: 'Account',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: '.',
                      ),
                      TextSpan(
                        text: '\n\nRemember that the process is irreversible.',
                      ),
                      TextSpan(
                        text: '\n\nIf you want to proceed click on the ',
                      ),
                      TextSpan(
                        text: 'Button',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ' below:',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 70,
                  height: 70,
                  child: FloatingActionButton(
                    onPressed: _deleteAccount,
                    backgroundColor: AppColors.errorColor,
                    shape: const CircleBorder(),
                    child: Icon(MingCuteIcons.mgc_delete_2_fill,
                        size: 32, color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
