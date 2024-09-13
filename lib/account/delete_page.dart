import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shox/generated/l10n.dart';
import 'package:shox/pages/welcome_page.dart';
import 'package:shox/theme/app_colors.dart';
import 'package:shox/widgets/custom_toast_bar.dart';

class DeletePage extends StatefulWidget {
  const DeletePage({super.key});

  @override
  DeletePageState createState() => DeletePageState();
}

class DeletePageState extends State<DeletePage> {
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
        _showErrorSnackBar(S.current.toast_delete_google);
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
      throw Exception('${S.current.toast_delete_user_data} $e');
    }
  }

  Future<void> _deleteUserStorage(String userId) async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('shoes_images/$userId');

      // Lists all files and subfolders within 'shoes_images/$userId'
      ListResult listResult = await storageRef.listAll();
      logger.i(
          'Found ${listResult.items.length} files and ${listResult.prefixes.length} folders to delete.');

      // Delete all files in the user’s folder
      for (Reference item in listResult.items) {
        logger.i('Deleting file: ${item.fullPath}');
        await item.delete();
      }

      // Delete all subfolders within the user’s folder
      for (Reference prefix in listResult.prefixes) {
        logger.i('Deleting folder: ${prefix.fullPath}');
        await prefix.delete();
      }
    } catch (e) {
      logger.e('Error deleting user storage: $e');
      throw Exception('${S.current.toast_delete_user_storage} $e');
    }
  }

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
      logger.e('Error deleting user history: $e');
      throw Exception('${S.current.toast_delete_user_history} $e');
    }
  }

  Future<void> _deleteAccount() async {
    final localizations = S.current;
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Show a dialog to confirm account cancellation
        bool confirmDelete = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: Text(
              localizations.delete_d_title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontSize: 20.r,
                fontWeight: FontWeight.bold,
                fontFamily: 'CustomFontBold',
              ),
            ),
            content: Text(
              localizations.delete_d_description,
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontSize: 18.r,
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
                child: Text(
                  localizations.delete_d_cancel,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16.r,
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
                child: Text(
                  localizations.delete_d_confirm,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16.r,
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

            // Delete user history from Firestore
            await _deleteUserHistory(user.uid);

            // Delete the user
            await user.delete();

            // Show confirm toastbar
            _showConfirmToastBar();
          } catch (e) {
            logger.e('Error deleting user: $e');
          }

          // Navigate to WelcomePage
          Get.to(
            () => const WelcomePage(),
            transition: Transition.fade,
            duration: const Duration(milliseconds: 500),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      _showErrorSnackBar('${S.current.toast_delete_generic_error} $e');
    }
  }

  void _showConfirmToastBar() {
    // Show confirm toastbar
    showCustomToastBar(
      context,
      position: DelightSnackbarPosition.bottom,
      color: AppColors.confirmColor,
      icon: const Icon(
        MingCuteIcons.mgc_check_fill,
      ),
      title: S.current.toast_delete_success,
    );
  }

  void _showErrorSnackBar(String? message) {
    if (message != null) {
      // Show error toastbar
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
        title: Text(
          S.current.delete_title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontWeight: FontWeight.bold,
            fontFamily: 'CustomFont',
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.secondary,
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30.r, horizontal: 30.r),
          child: Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/img_user_delete.png',
                  width: 120.r,
                  height: 120.r,
                ),
                40.verticalSpace,
                Text(
                  S.current.delete_description,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 20.r,
                    fontFamily: 'CustomFont',
                  ),
                  textAlign: TextAlign.center,
                ),
                40.verticalSpace,
                SizedBox(
                  width: 70.r,
                  height: 70.r,
                  child: FloatingActionButton(
                    onPressed: _deleteAccount,
                    backgroundColor: AppColors.errorColor,
                    shape: const CircleBorder(),
                    child: Icon(
                      MingCuteIcons.mgc_delete_2_fill,
                      size: 32.r,
                      color: Theme.of(context).colorScheme.primary,
                    ),
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
