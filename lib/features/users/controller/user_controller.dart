import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:shox/common/widgets/toast_widget.dart';
import 'package:shox/core/routes/app_routes.dart';
import 'package:shox/features/auth/services/auth_guard_service.dart';
import 'package:shox/features/users/models/user_model.dart';
import 'package:shox/features/users/repository/user_repository.dart';

class UserController extends GetxController {
  final userName = 'User'.obs;
  final userEmail = ''.obs;
  final userProfileImage = ''.obs;
  final isLoadingProfile = true.obs;
  final UserRepository _userRepository;

  /// The repository defaults to the real one; tests can pass a fake.
  UserController({UserRepository? userRepository})
      : _userRepository = userRepository ?? UserRepository();

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
    AuthGuardService.to.expectSignOut();
    await _userRepository.logout();
    if (context.mounted) {
      showSuccessToast(
        context,
        AppLocalizations.of(context)!.logout_toast_success,
      );
    }
    Get.offAllNamed(AppRoutes.welcome);
  }

  Future<void> googleSignOut() async {
    AuthGuardService.to.expectSignOut();
    await _userRepository.googleSignOut();
  }

  Future<void> deleteAccount() async {
    AuthGuardService.to.expectSignOut();
    await _userRepository.deleteAccount();
  }

  Future<void> deleteEntireUserCollection(String userId) async {
    await _userRepository.deleteEntireUserCollection(userId);
  }

  // ==================== FIREBASE STORAGE OPERATIONS ====================

  /// Upload user image to Firebase Storage
  /// Returns the download URL of the uploaded image
  Future<String> addUserImage(String userId, File imageFile) async {
    return await _userRepository.addUserImage(userId, imageFile);
  }

  /// Delete user image from Firebase Storage via its download URL
  Future<void> deleteUserImage(String imageUrl) async {
    await _userRepository.deleteUserImage(imageUrl);
  }

  /// Delete all user folders in Firebase Storage
  Future<void> deleteUserFolder(String userId) async {
    await _userRepository.deleteUserFolder(userId);
  }
}
