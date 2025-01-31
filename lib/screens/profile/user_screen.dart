import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shox/models/user_model.dart';
import 'package:shox/screens/profile/user_updater_screen.dart';
import 'package:shox/screens/profile/delete_account_screen.dart';
import 'package:shox/generated/l10n.dart';
import 'package:shox/screens/authentication/login/login_controller.dart';
import 'package:shox/screens/profile/user_controller.dart';
import 'package:shox/screens/profile/database_screen.dart';
import 'package:shox/screens/profile/history_screen.dart';
import 'package:shox/screens/welcome_screen.dart';
import 'package:shox/services/user_service.dart';
import 'package:shox/widgets/custom_section_button.dart';

class UserScreen extends StatefulWidget {
  final String userId;
  const UserScreen({
    super.key,
    required this.userId,
  });

  @override
  UserScreenState createState() => UserScreenState();
}

class UserScreenState extends State<UserScreen> {
  final UserController userController = Get.put(UserController());
  final LoginController loginController = Get.put(LoginController());
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final UserService _userService = UserService();
  String _userEmail = '';
  String? _profileImageUrl;
  String? _userProfileImage;

  @override
  Widget build(BuildContext context) {
    bool isEmailPasswordUser = currentUser != null &&
        currentUser!.providerData.isNotEmpty &&
        currentUser!.providerData[0].providerId == 'password';
    return Scaffold(
      appBar: _buildAppBar(context, isEmailPasswordUser),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(30.r),
          child: Center(
            child: Column(
              children: [
                _buildProfileImage(),
                SizedBox(height: 20.h),
                _buildProfileInfo(context),
                SizedBox(height: 40.h),
                _buildDatabaseButton(context),
                SizedBox(height: 20.h),
                _buildHistoryButton(context),
                SizedBox(height: 20.h),
                _buildLogoutButton(context),
                SizedBox(height: 20.h),
                _buildDeleteAccount(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    userController.loadUserName();
    _loadUserEmail();
    _loadUserProfileImage();
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
        photoUrl = photoUrl.replaceAll('s96', 's1024');
        setState(() {
          _userProfileImage = photoUrl;
        });
        return;
      }
    }

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get();
    if (userDoc.exists) {
      var data = userDoc.data() as Map<String, dynamic>;
      UserModel user = UserModel.fromFirestore(data);
      if (user.userImage != null) {
        final imageUrl2 = user.userImage!;
        final fileName2 = imageUrl2.split('/').last;
        _profileImageUrl =
            _userService.getUserImageUrlSupabase(widget.userId, fileName2);
        if (_profileImageUrl != null && _profileImageUrl!.isNotEmpty) {
          setState(() {
            _userProfileImage = _profileImageUrl;
          });
        }
      }
    }
  }

  Future<void> logout() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();

    if (mounted) {
      loginController.logout(context);
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('remember_me');

    Get.to(
      () => const WelcomeScreen(),
      transition: Transition.fade,
      duration: const Duration(milliseconds: 500),
    );
  }

  AppBar _buildAppBar(BuildContext context, bool isEmailPasswordUser) {
    return AppBar(
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
        S.current.profile_title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.tertiary,
          fontWeight: FontWeight.bold,
          fontFamily: 'CustomFont',
        ),
      ),
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.secondary,
      actions: isEmailPasswordUser
          ? [
              IconButton(
                icon: Icon(
                  MingCuteIcons.mgc_edit_2_fill,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: () {
                  Get.off(
                    () => UserUpdaterScreen(userId: currentUser!.uid),
                    transition: Transition.fade,
                    duration: const Duration(milliseconds: 500),
                  );
                },
              ),
            ]
          : null,
    );
  }

  Widget _buildProfileImage() {
    return CircleAvatar(
      radius: 80.r,
      backgroundImage:
          _userProfileImage != null ? NetworkImage(_userProfileImage!) : null,
      child: _userProfileImage == null
          ? Image.asset(
              'assets/images/img_profile.png',
              width: 120.w,
              height: 120.h,
            )
          : null,
    );
  }

  Widget _buildProfileInfo(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => Text(
            userController.userName.value,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 26.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'CustomFontBold',
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          _userEmail,
          style: TextStyle(
            fontSize: 18.sp,
            color: Theme.of(context).colorScheme.secondary,
            fontFamily: 'CustomFont',
          ),
        ),
      ],
    );
  }

  Widget _buildDatabaseButton(BuildContext context) {
    return CustomSectionButton(
      onPressed: () {
        Get.to(
          () => const DatabaseScreen(),
          transition: Transition.fade,
          duration: const Duration(milliseconds: 500),
        );
      },
      icon: MingCuteIcons.mgc_chart_pie_2_fill,
      text: S.current.profile_database,
    );
  }

  Widget _buildHistoryButton(BuildContext context) {
    return CustomSectionButton(
      onPressed: () {
        Get.to(
          () => const HistoryScreen(),
          transition: Transition.fade,
          duration: const Duration(milliseconds: 500),
        );
      },
      icon: MingCuteIcons.mgc_history_fill,
      text: S.current.profile_history,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return CustomSectionButton(
      onPressed: logout,
      icon: MingCuteIcons.mgc_exit_fill,
      text: S.current.profile_logout,
    );
  }

  Widget _buildDeleteAccount(BuildContext context) {
    return CustomSectionButton(
      onPressed: () {
        Get.to(
          () => const DeleteAccountScreen(),
          transition: Transition.fade,
          duration: const Duration(milliseconds: 500),
        );
      },
      icon: MingCuteIcons.mgc_delete_2_fill,
      text: S.current.profile_delete,
    );
  }
}
