import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> _checkGoogleAccount() async {
    User? user = _auth.currentUser;
    if (user == null) return;

    if (user.providerData
        .any((userInfo) => userInfo.providerId == 'google.com')) {
      try {
        // Log out from Google (if the user has been authenticated with Google)
        await googleSignIn.signOut();

        // Log out from Firebase
        await _auth.signOut();

        // Remove "Remember Me" preference
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('remember_me');
      } catch (e) {
        _showErrorSnackBar('Re-authentication with Google failed.');
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

  Future<void> _deleteUserStorage(String userId) async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('shoes_images/$userId');

      // Elenca tutti i file e le sottocartelle all'interno di 'shoes_images/$userId'
      ListResult listResult = await storageRef.listAll();
      logger.i(
          'Found ${listResult.items.length} files and ${listResult.prefixes.length} folders to delete.');

      // Elimina tutti i file all'interno della cartella dell'utente
      for (Reference item in listResult.items) {
        logger.i('Deleting file: ${item.fullPath}');
        await item.delete();
      }

      // Elimina tutte le sottocartelle all'interno della cartella dell'utente
      for (Reference prefix in listResult.prefixes) {
        logger.i('Deleting folder: ${prefix.fullPath}');
        await prefix.delete();
      }
    } catch (e) {
      logger.e('Error deleting user storage: $e');
      throw Exception('Failed to delete user storage: $e');
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
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: Text(
              'Delete',
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
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
                  Get.back(result: false);
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
                  Get.back(result: true);
                },
              ),
            ],
          ),
          barrierDismissible: false,
        );

        if (confirmDelete == true) {
          try {
            // Check before deleting the account
            if (user.providerData
                .any((userInfo) => userInfo.providerId == 'google.com')) {
              await _checkGoogleAccount();
            }

            // Delete user storage from Firebase Storage
            await _deleteUserStorage(user.uid);

            // Delete user data from Firestore
            await _deleteUserDatabase(user.uid);

            // Delete the user
            await user.delete();

            // Definitive logout from Google if the user is authenticated with Google
            // if (user.providerData
            //     .any((userInfo) => userInfo.providerId == 'google.com')) {
            //   await logout();
            // }
          } catch (e) {
            // Gestisci gli errori qui
            logger.e('Error deleting user: $e');
            // Potresti voler mostrare un messaggio di errore o effettuare altre azioni di gestione degli errori.
          }

          // Show confirm toastbar
          if (mounted) {
            DelightToastBar(
              snackbarDuration: const Duration(milliseconds: 1500),
              builder: (context) => const ToastCard(
                color: AppColors.confirmColor,
                leading: Icon(
                  MingCuteIcons.mgc_check_fill,
                  color: AppColors.white,
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
          Get.to(
            () => const WelcomePage(),
            transition: Transition.fade,
            duration: const Duration(milliseconds: 500),
          );
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
        position: DelightSnackbarPosition.top,
        snackbarDuration: const Duration(milliseconds: 1500),
        builder: (context) => ToastCard(
          color: AppColors.errorColor,
          leading: const Icon(
            MingCuteIcons.mgc_color_picker_fill,
            color: AppColors.white,
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
            Get.back();
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.secondary,
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
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
