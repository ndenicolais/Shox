import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shox/common/widgets/app_bar_widget.dart';
import 'package:shox/common/widgets/logo_widget.dart';
import 'package:shox/core/routes/app_routes.dart';
import 'package:shox/features/auth/login/controller/login_controller.dart';
import 'package:shox/features/auth/signup/controller/signup_controller.dart';
import 'package:shox/features/auth/signup/widgets/signup_form.dart';
import 'package:shox/common/widgets/button_widget.dart';
import 'package:shox/common/widgets/loader_widget.dart';
import 'package:shox/theme/app_font_sizes.dart';

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
    return Scaffold(
      appBar: AppBarWidget(
        title: AppLocalizations.of(context)!.signup_screen_title,
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
                    semanticLabel: 'Signup Logo',
                  ),
                  SizedBox(height: 20.h),
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
                  _buildButton(_signupController),
                  _buildGoogleButton(_loginController),
                  SizedBox(height: 10.h),
                  _buildLoginTextButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(SignupController controller) {
    return Obx(
      () => controller.isLoading.value
          ? LoaderWidget(width: 40.w, height: 40.h)
          : ButtonWidget(
              width: 280.w,
              height: 60.h,
              text: AppLocalizations.of(context)!.signup_screen_text,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              textColor: Theme.of(context).colorScheme.primary,
              fontSize: AppFontSizes.large,
              onPressed: () => controller.register(context, _formKey),
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
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: AppFontSizes.normal,
          ),
        ),
        SizedBox(height: 10.h),
        Obx(
          () => GestureDetector(
            onTap: controller.isLoading.value
                ? null
                : () => controller.loginWithGoogle(context),
            child: Image.asset(
              'assets/images/img_google.png',
              width: 40.w,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginTextButton() {
    return RichText(
      text: TextSpan(
        text: AppLocalizations.of(context)!.signup_screen_account,
        style: TextStyle(
          fontFamily: 'CustomFont',
          color: Theme.of(context).colorScheme.secondary,
          fontSize: AppFontSizes.small,
        ),
        children: [
          TextSpan(
            text: AppLocalizations.of(context)!.signup_screen_login,
            style: TextStyle(
              fontFamily: 'CustomFontBold',
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: AppFontSizes.small,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => Get.toNamed(AppRoutes.login),
          ),
        ],
      ),
    );
  }
}
