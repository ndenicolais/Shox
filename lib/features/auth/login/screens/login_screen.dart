import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:shox/theme/app_spacing.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shox/common/widgets/app_bar_widget.dart';
import 'package:shox/common/widgets/responsive_center_widget.dart';
import 'package:shox/features/auth/widgets/auth_switch_prompt.dart';
import 'package:shox/features/auth/widgets/google_sign_in_section.dart';
import 'package:shox/common/widgets/logo_widget.dart';
import 'package:shox/core/routes/app_routes.dart';
import 'package:shox/features/auth/login/controller/login_controller.dart';
import 'package:shox/features/auth/login/widgets/login_form.dart';
import 'package:shox/common/widgets/button_widget.dart';
import 'package:shox/core/utils/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final LoginController _controller = Get.find<LoginController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _checkRememberMe();
  }

  Future<void> _checkRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(AppConstants.prefsRememberMe) ?? false) {
      Get.toNamed(AppRoutes.home);
    }
  }

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
                  formKey: _formKey,
                  emailController: _controller.emailController,
                  passwordController: _controller.passwordController,
                  passwordVisible: _controller.passwordVisible,
                  rememberMe: _controller.rememberMe.value,
                  togglePasswordVisibility: () {
                    _controller.passwordVisible.value =
                        !_controller.passwordVisible.value;
                  },
                  onLogin: () => _controller.login(context, _formKey),
                  onLoginWithGoogle: () => _controller.loginWithGoogle(context),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Expanded(child: _buildRememberMeCheckbox(_controller)),
                    TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.resetPassword),
                      child: Text(l10n.login_screen_password),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.m),
                _buildLoginButton(_controller),
                const SizedBox(height: AppSpacing.xl),
                Obx(
                  () => GoogleSignInSection(
                    onPressed: _controller.isLoading.value
                        ? null
                        : () => _controller.loginWithGoogle(context),
                  ),
                ),
                const SizedBox(height: AppSpacing.l),
                AuthSwitchPrompt(
                  question: l10n.login_screen_account,
                  action: l10n.login_screen_signup,
                  onPressed: () => Get.toNamed(AppRoutes.signup),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRememberMeCheckbox(LoginController controller) {
    return Obx(
      () => CheckboxListTile(
        value: controller.rememberMe.value,
        onChanged: (value) => controller.rememberMe.value = value!,
        title: Text(
          AppLocalizations.of(context)!.login_screen_remember,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
        dense: true,
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  Widget _buildLoginButton(LoginController controller) {
    return Obx(
      () => ButtonWidget(
        isLoading: controller.isLoading.value,
        text: AppLocalizations.of(context)!.login_screen_text,
        onPressed: () => controller.login(context, _formKey),
      ),
    );
  }
}
