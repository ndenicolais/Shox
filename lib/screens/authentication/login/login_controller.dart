import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shox/generated/l10n.dart';
import 'package:shox/screens/home_screen.dart';
import 'package:shox/screens/welcome_screen.dart';
import 'package:shox/services/auth_service.dart';
import 'package:shox/widgets/custom_toast_bar.dart';

class LoginController extends GetxController {
  final AuthService _authService = AuthService();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordVisible = false.obs;
  var rememberMe = false.obs;

  void togglePasswordVisibility() {
    passwordVisible.value = !passwordVisible.value;
  }

  Future<void> login(BuildContext context, GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      User? user = await _authService.loginWithEmailPassword(
        emailController.text,
        passwordController.text,
        rememberMe.value,
      );
      if (user != null) {
        final userModel = await _authService.getUserDetails(user.uid);
        if (userModel != null) {
          if (context.mounted) {
            showSuccessToast(
              context,
              '${S.current.toast_login_welcome}${userModel.userName}',
            );
          }
        }
        Get.to(() => const HomeScreen(),
            transition: Transition.fade,
            duration: const Duration(milliseconds: 500));
      }
    } catch (e) {
      String errorMessage = e.toString();
      if (e is Exception && errorMessage.contains("email_not_found")) {
        errorMessage = S.current.login_toast_error_email_not_found;
      }
      if (e is Exception && errorMessage.contains("invalid_password")) {
        errorMessage = S.current.login_toast_error_invalid_password;
      }

      if (context.mounted) {
        showErrorToast(context, errorMessage);
      }
    }
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    User? user = await _authService.loginWithGoogle(
      context,
      rememberMe.value,
    );

    if (user != null) {
      String? googleUserName = user.displayName;
      if (googleUserName != null) {
        List<String> nameParts = googleUserName.split(" ");
        googleUserName = nameParts[0];
      }
      if (googleUserName != null) {
        if (context.mounted) {
          showSuccessToast(
            context,
            '${S.current.toast_login_welcome}$googleUserName',
          );
        }
      }
      Get.to(() => const HomeScreen(),
          transition: Transition.fade,
          duration: const Duration(milliseconds: 500));
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await _authService.logout();
      emailController.clear();
      passwordController.clear();
      rememberMe.value = false;

      if (context.mounted) {
        showSuccessToast(
          context,
          S.current.logout_toast_success,
        );
      }

      Get.offAll(() => const WelcomeScreen(),
          transition: Transition.fade,
          duration: const Duration(milliseconds: 500));
    } catch (e) {
      if (context.mounted) {
        showErrorToast(
          context,
          S.current.logout_toast_success,
        );
      }
    }
  }
}
