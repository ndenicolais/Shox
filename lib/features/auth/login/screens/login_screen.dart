import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shox/theme/app_spacing.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shox/common/widgets/app_bar_widget.dart';
import 'package:shox/common/widgets/logo_widget.dart';
import 'package:shox/core/routes/app_routes.dart';
import 'package:shox/features/auth/login/controller/login_controller.dart';
import 'package:shox/features/auth/login/widgets/login_form.dart';
import 'package:shox/common/widgets/button_widget.dart';
import 'package:shox/core/utils/constants.dart';
import 'package:shox/theme/app_font_sizes.dart';

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
    return Scaffold(
      appBar: AppBarWidget(
        title: AppLocalizations.of(context)!.login_screen_title,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.screen.r),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 20.h,
                children: [
                  LogoWidget(
                    width: 150.w,
                    height: 150.h,
                    semanticLabel: 'Login Logo',
                  ),
                  SizedBox(height: 20.h),
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
                    onLoginWithGoogle: () =>
                        _controller.loginWithGoogle(context),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildRememberMeCheckbox(_controller),
                      _buildForgotPasswordText(),
                    ],
                  ),
                  _buildLoginButton(_controller),
                  _buildGoogleButton(_controller),
                  SizedBox(height: 10.h),
                  _buildSignupTextButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRememberMeCheckbox(LoginController controller) {
    return Row(
      children: [
        Obx(
          () => Checkbox(
            value: controller.rememberMe.value,
            onChanged: (value) => controller.rememberMe.value = value!,
            checkColor: Theme.of(context).colorScheme.surface,
            activeColor: Theme.of(context).colorScheme.secondary,
            shape: const CircleBorder(),
            side: BorderSide(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
        Text(
          AppLocalizations.of(context)!.login_screen_remember,
          style: TextStyle(
            fontFamily: 'CustomFont',
            color: Theme.of(context).colorScheme.secondary,
            fontSize: AppFontSizes.small,
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordText() {
    return RichText(
      text: TextSpan(
        text: AppLocalizations.of(context)!.login_screen_password,
        style: TextStyle(
          fontFamily: 'CustomFontBold',
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: AppFontSizes.extraSmall,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () => Get.toNamed(AppRoutes.resetPassword),
      ),
    );
  }

  Widget _buildLoginButton(LoginController controller) {
    return Obx(
      () => ButtonWidget(
        isLoading: controller.isLoading.value,
        width: 280.w,
        height: 60.h,
        text: AppLocalizations.of(context)!.login_screen_text,
        fontSize: AppFontSizes.large,
        onPressed: () => controller.login(context, _formKey),
      ),
    );
  }

  Widget _buildGoogleButton(LoginController controller) {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.auth_or_continue_with,
          style: TextStyle(
            fontFamily: 'CustomFont',
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: AppFontSizes.normal,
          ),
        ),
        SizedBox(height: 10.h),
        Obx(
          () => Semantics(
            label: AppLocalizations.of(context)!.auth_sign_in_with_google,
            button: true,
            child: GestureDetector(
              onTap: controller.isLoading.value
                  ? null
                  : () => controller.loginWithGoogle(context),
              child: Image.asset(
                'assets/images/img_google.png',
                width: 40.w,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignupTextButton() {
    return RichText(
      text: TextSpan(
        text: AppLocalizations.of(context)!.login_screen_account,
        style: TextStyle(
          fontFamily: 'CustomFont',
          color: Theme.of(context).colorScheme.secondary,
          fontSize: AppFontSizes.small,
        ),
        children: [
          TextSpan(
            text: AppLocalizations.of(context)!.login_screen_signup,
            style: TextStyle(
              fontFamily: 'CustomFontBold',
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: AppFontSizes.small,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => Get.toNamed(AppRoutes.signup),
          ),
        ],
      ),
    );
  }
}
