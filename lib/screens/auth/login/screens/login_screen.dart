import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shox/common/widgets/app_bar_widget.dart';
import 'package:shox/common/widgets/logo_widget.dart';
import 'package:shox/features/auth/login/controller/login_controller.dart';
import 'package:shox/screens/auth/login/widgets/login_form.dart';
import 'package:shox/screens/auth/reset_password/screens/reset_password_screen.dart';
import 'package:shox/screens/auth/signup/screens/signup_screen.dart';
import 'package:shox/screens/home/screens/home_screen.dart';
import 'package:shox/common/widgets/button_widget.dart';
import 'package:shox/theme/app_font_sizes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final LoginController _controller = Get.put(LoginController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _checkRememberMe();
  }

  Future<void> _checkRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('remember_me') ?? false) {
      Get.to(() => const HomeScreen(),
          transition: Transition.fade,
          duration: const Duration(milliseconds: 500));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: AppLocalizations.of(context)!.login_screen_title,
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(30.r),
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
            checkColor: Theme.of(context).colorScheme.primary,
            activeColor: Theme.of(context).colorScheme.secondary,
            shape: const CircleBorder(),
            side: BorderSide(color: Theme.of(context).colorScheme.tertiary),
          ),
        ),
        Text(
          AppLocalizations.of(context)!.login_screen_remember,
          style: GoogleFonts.montserrat(
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
        style: GoogleFonts.montserrat(
          color: Theme.of(context).colorScheme.tertiary,
          fontSize: AppFontSizes.extraSmall,
          fontWeight: FontWeight.w600,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () => Get.to(
                () => const ResetPasswordScreen(),
                transition: Transition.fade,
                duration: const Duration(milliseconds: 500),
              ),
      ),
    );
  }

  Widget _buildLoginButton(LoginController controller) {
    return ButtonWidget(
      width: 280.w,
      height: 60.h,
      text: AppLocalizations.of(context)!.login_screen_text,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      textColor: Theme.of(context).colorScheme.primary,
      fontSize: AppFontSizes.large,
      onPressed: () => controller.login(context, _formKey),
    );
  }

  Widget _buildGoogleButton(LoginController controller) {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.auth_or_continue_with,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: AppFontSizes.normal,
          ),
        ),
        SizedBox(height: 10.h),
        GestureDetector(
          onTap: () => controller.loginWithGoogle(context),
          child: Image.asset(
            'assets/images/img_google.png',
            width: 40.w,
          ),
        ),
      ],
    );
  }

  Widget _buildSignupTextButton() {
    return RichText(
      text: TextSpan(
        text: AppLocalizations.of(context)!.login_screen_account,
        style: GoogleFonts.montserrat(
          color: Theme.of(context).colorScheme.secondary,
          fontSize: AppFontSizes.small,
        ),
        children: [
          TextSpan(
            text: AppLocalizations.of(context)!.login_screen_signup,
            style: GoogleFonts.montserrat(
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: AppFontSizes.small,
              fontWeight: FontWeight.w600,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => Get.to(
                    () => const SignupScreen(),
                    transition: Transition.fade,
                    duration: const Duration(milliseconds: 500),
                  ),
          ),
        ],
      ),
    );
  }
}
