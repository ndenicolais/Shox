import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:shox/common/widgets/toast_widget.dart';
import 'package:shox/core/routes/app_routes.dart';
import 'package:shox/core/utils/app_exceptions.dart';
import 'package:shox/features/users/models/user_model.dart';
import '../repository/signup_repository.dart';

class SignupController extends GetxController {
  final SignupRepository _signupRepository = SignupRepository();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordVisible = false.obs;
  var isLoading = false.obs;

  Future<void> register(
      BuildContext context, GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;
    try {
      if (nameController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty) {
        UserModel user = UserModel(
          userEmail: emailController.text,
          userName: nameController.text,
        );

        User? registeredUser = await _signupRepository.signUpWithEmailPassword(
          user,
          nameController.text,
          emailController.text,
          passwordController.text,
        );

        if (registeredUser != null) {
          if (context.mounted) {
            showSuccessToast(
              context,
              AppLocalizations.of(context)!.signup_toast_success,
            );
          }
          // Navigate to gender selection screen
          Get.offNamed(
            AppRoutes.genderSelection,
            arguments: {
              'userId': registeredUser.uid,
              'userEmail': emailController.text,
              'userName': nameController.text,
            },
          );
        }
      }
    } catch (e) {
      String errorMessage = e.toString();
      if (e is AuthException && context.mounted) {
        if (e.code == 'email_already_register') {
          errorMessage = AppLocalizations.of(context)!
              .signup_toast_error_email_already_register;
        }
      }

      if (context.mounted) {
        showErrorToast(
          context,
          errorMessage,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
}
