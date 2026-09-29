import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shox/common/widgets/app_bar_widget.dart';
import 'package:shox/common/widgets/button_widget.dart';
import 'package:shox/common/widgets/logo_widget.dart';
import 'package:shox/common/widgets/responsive_center_widget.dart';
import 'package:shox/core/routes/app_routes.dart';
import 'package:shox/features/auth/login/controller/login_controller.dart';
import 'package:shox/features/auth/login/widgets/login_form.dart';
import 'package:shox/features/auth/widgets/auth_switch_prompt.dart';
import 'package:shox/features/auth/widgets/google_sign_in_section.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:shox/theme/app_spacing.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBarWidget(title: l10n.login_screen_title),
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
                    semanticLabel: 'Login Logo',
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                LoginForm(
                  context: context,
                  formKey: controller.formKey,
                  emailController: controller.emailController,
                  passwordController: controller.passwordController,
                  passwordVisible: controller.passwordVisible,
                  rememberMe: controller.rememberMe.value,
                  togglePasswordVisibility: () {
                    controller.passwordVisible.value =
                        !controller.passwordVisible.value;
                  },
                  onLogin: () => controller.login(context),
                  onLoginWithGoogle: () => controller.loginWithGoogle(context),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => CheckboxListTile(
                          value: controller.rememberMe.value,
                          onChanged: (value) =>
                              controller.rememberMe.value = value!,
                          title: Text(
                            l10n.login_screen_remember,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.resetPassword),
                      child: Text(l10n.login_screen_password),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.m),
                Obx(
                  () => ButtonWidget(
                    isLoading: controller.isLoading.value,
                    text: l10n.login_screen_text,
                    onPressed: () => controller.login(context),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Obx(
                  () => GoogleSignInSection(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.loginWithGoogle(context),
                  ),
                ),
                const SizedBox(height: AppSpacing.l),
                AuthSwitchPrompt(
                  question: l10n.login_screen_account,
                  action: l10n.login_screen_signup,
                  // Replaces this screen, so login and signup never stack
                  // (their controllers own the form keys).
                  onPressed: () => Get.offNamed(AppRoutes.signup),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
