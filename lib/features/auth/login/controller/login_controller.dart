import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:shox/common/widgets/toast_widget.dart';
import 'package:shox/features/auth/login/repository/login_repository.dart';
import 'package:shox/features/users/controller/user_controller.dart';
import 'package:shox/screens/auth/gender_selection/screens/gender_selection_screen.dart';
import 'package:shox/screens/home/screens/home_screen.dart';

class LoginController extends GetxController {
  final LoginRepository _loginRepository = LoginRepository();
  final UserController _userController = UserController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordVisible = false.obs;
  var rememberMe = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login(BuildContext context, GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    try {
      User? user = await _loginRepository.loginWithEmailPassword(
        emailController.text,
        passwordController.text,
        rememberMe.value,
      );
      if (user != null) {
        final userModel = await _userController.getUserDetails(user.uid);
        if (userModel != null) {
          if (context.mounted) {
            showSuccessToast(
              context,
              AppLocalizations.of(context)!.login_toast_success,
            );
            Get.to(() => const HomeScreen(),
                transition: Transition.fade,
                duration: const Duration(milliseconds: 500));
          }
        }
      }
    } catch (e) {
      String errorMessage = e.toString();
      if (context.mounted) {
        if (e is Exception && errorMessage.contains("email_not_found")) {
          errorMessage =
              AppLocalizations.of(context)!.login_toast_error_email_not_found;
        }
      }
      if (context.mounted) {
        if (e is Exception && errorMessage.contains("invalid_password")) {
          errorMessage =
              AppLocalizations.of(context)!.login_toast_error_invalid_password;
        }
      }
      if (context.mounted) {
        showErrorToast(context, errorMessage);
      }
    }
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    final result = await _loginRepository.loginWithGoogle(rememberMe.value);
    if (result != null) {
      final user = result['user'] as User;
      final isNewUser = result['isNewUser'] as bool;

      if (context.mounted) {
        showSuccessToast(
          context,
          AppLocalizations.of(context)!.login_toast_success,
        );

        // If it's a new user, show gender selection screen
        if (isNewUser) {
          Get.off(
            () => GenderSelectionScreen(
              userId: user.uid,
              userEmail: user.email ?? '',
              userName: user.displayName?.split(' ').first ?? 'User',
              userImage: user.photoURL,
            ),
            transition: Transition.fade,
            duration: const Duration(milliseconds: 500),
          );
        } else {
          // Existing user, go to home
          Get.to(
            () => const HomeScreen(),
            transition: Transition.fade,
            duration: const Duration(milliseconds: 500),
          );
        }
      }
    }
  }
}
