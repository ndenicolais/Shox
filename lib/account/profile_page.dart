import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shox/account/delete_account_page.dart';
import 'package:shox/pages/database_page.dart';
import 'package:shox/pages/stores_page.dart';
import 'package:shox/pages/welcome_page.dart';
import 'package:shox/theme/app_colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  String _userName = '';
  String _userEmail = '';
  String? _userProfileImage;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadUserEmail();
    _loadUserProfileImage();
  }

  Future<void> _loadUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (user.providerData.isNotEmpty &&
          user.providerData[0].providerId == 'google.com') {
        // If the user is logged in via Google, get the name from the Google account
        String? googleUserName = user.displayName;
        if (googleUserName != null) {
          List<String> nameParts = googleUserName.split(" ");
          setState(
            () {
              // Take only the first name
              _userName = nameParts[0];
            },
          );
        }
      } else {
        // Access Firestore to retrieve user data
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userSnapshot.exists) {
          // Handle nullable Map<String, dynamic>
          Map<String, dynamic>? userData =
              userSnapshot.data() as Map<String, dynamic>?;

          if (userData != null) {
            setState(
              () {
                _userName = userData['name'] ?? 'User';
              },
            );
          } else {
            setState(
              () {
                _userName = 'User';
              },
            );
          }
        } else {
          setState(
            () {
              _userName = 'User';
            },
          );
        }
      }
    }
  }

  void _loadUserEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(
        () {
          _userEmail = user.email ?? 'Email';
        },
      );
    }
  }

  Future<void> _loadUserProfileImage() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null &&
        user.providerData.isNotEmpty &&
        user.providerData[0].providerId == 'google.com') {
      String? photoUrl = user.photoURL;
      if (photoUrl != null) {
        // Edit the URL to request a higher quality version of the image
        photoUrl = photoUrl.replaceAll('s96', 's1024');
        setState(
          () {
            _userProfileImage = photoUrl;
          },
        );
      }
    }
  }

  Future<void> logout() async {
    // Log out from Google (if the user has been authenticated with Google)
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();

    // Log out from Firebase
    await FirebaseAuth.instance.signOut();

    // Remove "Remember Me" preference
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('remember_me');

    _showConfirmToastBar();

    Get.to(
      () => const WelcomePage(),
      transition: Transition.fade,
      duration: const Duration(milliseconds: 500),
    );
  }

  void _showConfirmToastBar() {
    // Show error toastbar
    DelightToastBar(
      position: DelightSnackbarPosition.bottom,
      snackbarDuration: const Duration(milliseconds: 1500),
      builder: (context) => const ToastCard(
        color: AppColors.confirmColor,
        leading: Icon(
          MingCuteIcons.mgc_hand_fill,
          color: AppColors.white,
          size: 28,
        ),
        title: Text(
          'See later!',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 16,
          ),
        ),
      ),
      autoDismiss: true,
    ).show(context);
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
        child: Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 80,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                backgroundImage: _userProfileImage != null
                    ? NetworkImage(_userProfileImage!)
                    : null,
                child: _userProfileImage == null
                    ? Icon(
                        Icons.face,
                        size: 120,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
              ),
              const SizedBox(height: 10),
              Text(
                _userName,
                style: TextStyle(
                  fontSize: 26,
                  color: Theme.of(context).colorScheme.secondary,
                  fontFamily: 'CustomFontBold',
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _userEmail,
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.secondary,
                  fontFamily: 'CustomFont',
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 280,
                height: 60,
                child: MaterialButton(
                  onPressed: () {
                    Get.to(
                      () => const DatabasePage(),
                      transition: Transition.fade,
                      duration: const Duration(milliseconds: 500),
                    );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  color: Theme.of(context).colorScheme.primary,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(MingCuteIcons.mgc_chart_pie_2_fill,
                          color: Theme.of(context).colorScheme.secondary),
                      Text(
                        'Database',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: 20,
                          fontFamily: 'CustomFont',
                        ),
                      ),
                      Icon(MingCuteIcons.mgc_right_fill,
                          color: Theme.of(context).colorScheme.tertiary),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 280,
                height: 60,
                child: MaterialButton(
                  onPressed: () {
                    Get.to(
                      () => const StoresPage(),
                      transition: Transition.fade,
                      duration: const Duration(milliseconds: 500),
                    );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  color: Theme.of(context).colorScheme.primary,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(MingCuteIcons.mgc_shop_fill,
                          color: Theme.of(context).colorScheme.secondary),
                      Text(
                        'Stores',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: 20,
                          fontFamily: 'CustomFont',
                        ),
                      ),
                      Icon(MingCuteIcons.mgc_right_fill,
                          color: Theme.of(context).colorScheme.tertiary),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 280,
                height: 60,
                child: MaterialButton(
                  onPressed: logout,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  color: Theme.of(context).colorScheme.primary,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(MingCuteIcons.mgc_exit_fill,
                          color: Theme.of(context).colorScheme.secondary),
                      Text(
                        'Log Out',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: 20,
                          fontFamily: 'CustomFont',
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios,
                          color: Theme.of(context).colorScheme.tertiary),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 280,
                height: 60,
                child: MaterialButton(
                  onPressed: () {
                    Get.to(
                      () => const DeleteAccountPage(),
                      transition: Transition.fade,
                      duration: const Duration(milliseconds: 500),
                    );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  color: Theme.of(context).colorScheme.primary,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(MingCuteIcons.mgc_delete_2_fill,
                          color: Theme.of(context).colorScheme.secondary),
                      Text(
                        'Delete Account',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: 20,
                          fontFamily: 'CustomFont',
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios,
                          color: Theme.of(context).colorScheme.tertiary),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
