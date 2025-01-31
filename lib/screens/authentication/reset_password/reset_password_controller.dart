import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shox/generated/l10n.dart';
import 'package:shox/services/auth_service.dart';
import 'package:shox/widgets/custom_toast_bar.dart';

class ResetPasswordController extends GetxController {
  final AuthService _authService = AuthService();
  final emailController = TextEditingController();

  Future<void> resetPassword(
      BuildContext context, GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      final email = emailController.text.trim();
      if (emailController.text.isNotEmpty) {
        final emailToReset = await _authService.resetPassword(email);
        if (context.mounted) {
          showSuccessToast(
            context,
            '${S.current.reset_password_toast_success} $emailToReset',
          );
        }
      }
    } catch (e) {
      String errorMessage = e.toString();

      if (e is Exception) {
        if (errorMessage.contains("email_not_found")) {
          errorMessage = S.current.reset_password_toast_error_email_not_found;
        } else if (errorMessage.contains("reset_failed")) {
          errorMessage = S.current.reset_password_toast_error_password;
        }
      }

      if (context.mounted) {
        showErrorToast(context, errorMessage);
      }
    }
  }
}
