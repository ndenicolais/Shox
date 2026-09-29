import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:shox/theme/app_spacing.dart';
import 'package:get/get.dart';
import 'package:shox/common/widgets/app_bar_widget.dart';
import 'package:shox/common/widgets/responsive_center_widget.dart';
import 'package:shox/features/auth/widgets/auth_switch_prompt.dart';
import 'package:shox/features/auth/widgets/google_sign_in_section.dart';
import 'package:shox/common/widgets/logo_widget.dart';
import 'package:shox/core/routes/app_routes.dart';
import 'package:shox/features/auth/login/controller/login_controller.dart';
import 'package:shox/features/auth/signup/controller/signup_controller.dart';
import 'package:shox/features/auth/signup/widgets/signup_form.dart';
import 'package:shox/common/widgets/button_widget.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  final SignupController _signupController = Get.find<SignupController>();
  final LoginController _loginController = Get.find<LoginController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBarWidget(title: l10n.signup_screen_title),
      body: SafeArea(
        child: ResponsiveCenterWidget(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: LogoWidget(
                    width: 96,
                    height: 96,
                    semanticLabel: 'Signup Logo',
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                SignupForm(
                  context: context,
                  formKey: _formKey,
                  nameController: _signupController.nameController,
                  emailController: _signupController.emailController,
                  passwordController: _signupController.passwordController,
                  passwordVisible: _signupController.passwordVisible,
                  togglePasswordVisibility: () {
                    _signupController.passwordVisible.value =
                        !_signupController.passwordVisible.value;
                  },
                ),
                const SizedBox(height: AppSpacing.l),
                Obx(
                  () => ButtonWidget(
                    isLoading: _signupController.isLoading.value,
                    text: l10n.signup_screen_text,
                    onPressed: () =>
                        _signupController.register(context, _formKey),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Obx(
                  () => GoogleSignInSection(
                    onPressed: _loginController.isLoading.value
                        ? null
                        : () => _loginController.loginWithGoogle(context),
                  ),
                ),
                const SizedBox(height: AppSpacing.l),
                AuthSwitchPrompt(
                  question: l10n.signup_screen_account,
                  action: l10n.signup_screen_login,
                  onPressed: () => Get.toNamed(AppRoutes.login),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
