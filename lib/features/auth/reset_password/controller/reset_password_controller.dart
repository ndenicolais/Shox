import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:shox/core/utils/app_exceptions.dart';
import '../repository/reset_password_repository.dart';
import 'package:shox/common/widgets/toast_widget.dart';

class ResetPasswordController extends GetxController {
  final ResetPasswordRepository _resetPasswordRepository =
      ResetPasswordRepository();
  final emailController = TextEditingController();
  var isLoading = false.obs;

  /// Owned here so the screen can be a stateless [GetView].
  final formKey = GlobalKey<FormState>();

  Future<void> resetPassword(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;
    try {
      final email = emailController.text.trim();
      if (emailController.text.isNotEmpty) {
        final emailToReset =
            await _resetPasswordRepository.resetPassword(email);
        if (context.mounted) {
          showSuccessToast(
            context,
            '${AppLocalizations.of(context)!.reset_password_toast_success} $emailToReset',
          );
        }
      }
    } catch (e) {
      String errorMessage = e.toString();
      if (e is AuthException && context.mounted) {
        if (e.code == 'email_not_found') {
          errorMessage = AppLocalizations.of(context)!
              .reset_password_toast_error_email_not_found;
        } else if (e.code == 'reset_failed') {
          errorMessage =
              AppLocalizations.of(context)!.reset_password_toast_error_password;
        }
      }
      if (context.mounted) {
        showErrorToast(context, errorMessage);
      }
    } finally {
      isLoading.value = false;
    }
  }
}
