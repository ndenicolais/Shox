import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:shox/common/widgets/toast_widget.dart';
import 'package:shox/core/routes/app_routes.dart';
import 'package:shox/core/utils/app_exceptions.dart';
import 'package:shox/features/auth/login/repository/login_repository.dart';
import 'package:shox/features/users/controller/user_controller.dart';

class LoginController extends GetxController {
  /// Owned here so the screen can be a stateless [GetView].
  final formKey = GlobalKey<FormState>();
  final LoginRepository _loginRepository = LoginRepository();
  final UserController _userController = Get.find<UserController>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordVisible = false.obs;
  var rememberMe = false.obs;
  var isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    isLoading.value = true;
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
            Get.toNamed(AppRoutes.home);
          }
        }
      }
    } catch (e) {
      String errorMessage = e.toString();
      if (e is AuthException && context.mounted) {
        if (e.code == 'email_not_found') {
          errorMessage = AppLocalizations.of(
            context,
          )!
              .login_toast_error_email_not_found;
        } else if (e.code == 'invalid_password') {
          errorMessage = AppLocalizations.of(
            context,
          )!
              .login_toast_error_invalid_password;
        } else if (e.code == 'invalid_credentials') {
          errorMessage = AppLocalizations.of(
            context,
          )!
              .login_toast_error_invalid_credentials;
        }
      }
      if (context.mounted) {
        showErrorToast(context, errorMessage);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    isLoading.value = true;
    Map<String, dynamic>? result;
    try {
      // Google login always keeps the user signed in, regardless of the
      // "remember me" checkbox state.
      result = await _loginRepository.loginWithGoogle(true);
    } catch (e) {
      if (context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        final errorMessage = e is AuthException && e.code == 'network_error'
            ? l10n.login_toast_error_network
            : '${l10n.login_toast_error_generic} $e';
        showErrorToast(context, errorMessage);
      }
    } finally {
      isLoading.value = false;
    }
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
          Get.offNamed(
            AppRoutes.genderSelection,
            arguments: {
              'userId': user.uid,
              'userEmail': user.email ?? '',
              'userName': user.displayName?.split(' ').first ?? 'User',
              'userImage': user.photoURL,
            },
          );
        } else {
          // Existing user, go to home
          Get.toNamed(AppRoutes.home);
        }
      }
    }
  }
}
