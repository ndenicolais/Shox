import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:shox/common/screens/welcome_screen.dart';
import 'package:shox/common/widgets/toast_widget.dart';
import 'package:shox/features/users/models/user_model.dart';
import 'package:shox/features/users/repository/user_repository.dart';

class UserController extends GetxController {
  final userName = 'User'.obs;
  final userEmail = ''.obs;
  final userProfileImage = ''.obs;
  final isLoadingProfile = true.obs;
  final UserRepository _userRepository = UserRepository();

  Future<void> loadUserName() async {
    await _userRepository.loadUserName().then((name) {
      userName.value = name;
    }).catchError((_) {
      userName.value = 'User';
    });
  }

  /// Load complete user profile data (name, email, image)
  Future<void> loadUserProfile(String userId) async {
    try {
      isLoadingProfile.value = true;
      final user = await _userRepository.getUserDetails(userId);
      if (user != null) {
        userEmail.value = user.userEmail;
        // Extract only first name for consistency with loadUserName()
        userName.value = user.userName.split(' ').first;
      }

      final imageUrl = await _userRepository.getUserProfileImageUrl(userId);
      if (imageUrl != null && imageUrl.isNotEmpty) {
        userProfileImage.value = imageUrl;
      }
    } catch (e) {
      // Handle error if needed
    } finally {
      isLoadingProfile.value = false;
    }
  }

  Future<UserModel?> getUserDetails(String uid) async {
    return await _userRepository.getUserDetails(uid);
  }

  /// Check if current user is using email/password authentication
  bool isEmailPasswordUser() {
    return _userRepository.isEmailPasswordUser();
  }

  /// Get user profile image URL
  Future<String?> getUserProfileImageUrl(String userId) async {
    return await _userRepository.getUserProfileImageUrl(userId);
  }

  Future<void> logout(BuildContext context) async {
    await _userRepository.logout();
    if (context.mounted) {
      showSuccessToast(
        context,
        AppLocalizations.of(context)!.logout_toast_success,
      );
    }
    Get.offAll(
      () => const WelcomeScreen(),
      transition: Transition.fade,
      duration: const Duration(milliseconds: 500),
    );
  }

  Future<void> googleSignOut() async {
    await _userRepository.googleSignOut();
  }

  Future<void> deleteAccount() async {
    await _userRepository.deleteAccount();
  }

  Future<void> deleteEntireUserCollection(String userId) async {
    await _userRepository.deleteEntireUserCollection(userId);
  }

  // ==================== SUPABASE IMAGE OPERATIONS ====================

  /// Upload user image to Supabase Storage
  /// Returns the storage path of the uploaded image
  Future<String> addUserImageSupabase(String userId, File imageFile) async {
    return await _userRepository.addUserImageSupabase(userId, imageFile);
  }

  /// Delete user image from Supabase Storage
  Future<void> deleteUserImageSupabase(String userId, String fileName) async {
    await _userRepository.deleteUserImageSupabase(userId, fileName);
  }

  /// Get public URL for user image from Supabase Storage
  String getUserImageUrlSupabase(String userId, String fileName) {
    return _userRepository.getUserImageUrlSupabase(userId, fileName);
  }

  /// Delete all user folders in Supabase Storage
  Future<void> deleteUserFolderSupabase(String userId) async {
    await _userRepository.deleteUserFolderSupabase(userId);
  }
}
