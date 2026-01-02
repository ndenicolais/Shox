import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:shox/common/widgets/toast_widget.dart';
import 'package:shox/features/users/models/user_model.dart';
import 'package:shox/screens/auth/gender_selection/screens/gender_selection_screen.dart';
import '../repository/signup_repository.dart';

class SignupController extends GetxController {
  final SignupRepository _signupRepository = SignupRepository();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordVisible = false.obs;

  Future<void> register(
      BuildContext context, GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

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
          Get.off(
            () => GenderSelectionScreen(
              userId: registeredUser.uid,
              userEmail: emailController.text,
              userName: nameController.text,
            ),
            transition: Transition.fade,
            duration: const Duration(milliseconds: 500),
          );
        }
      }
    } catch (e) {
      String errorMessage = e.toString();
      if (context.mounted) {
        if (e is Exception && errorMessage.contains("email_already_register")) {
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
    }
  }
}
