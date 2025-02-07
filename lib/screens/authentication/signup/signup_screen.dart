import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/screens/authentication/login/login_screen.dart';
import 'package:shox/generated/l10n.dart';
import 'package:shox/screens/authentication/signup/signup_controller.dart';
import 'package:shox/screens/authentication/signup/signup_form.dart';
import 'package:shox/widgets/custom_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  final SignupController controller = Get.put(SignupController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(30.r),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTopImage(context),
                  SizedBox(height: 60.h),
                  SignupForm(
                    context: context,
                    formKey: _formKey,
                    nameController: controller.nameController,
                    emailController: controller.emailController,
                    passwordController: controller.passwordController,
                    passwordVisible: controller.passwordVisible,
                    togglePasswordVisibility:
                        controller.togglePasswordVisibility,
                  ),
                  SizedBox(height: 40.h),
                  _buildButton(context, controller),
                  SizedBox(height: 20.h),
                  _buildSignupText(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          MingCuteIcons.mgc_large_arrow_left_fill,
          color: Theme.of(context).colorScheme.secondary,
        ),
        onPressed: () {
          Get.back();
        },
      ),
      title: Text(
        S.current.signup_screen_title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.tertiary,
          fontFamily: 'CustomFont',
        ),
      ),
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.secondary,
    );
  }

  Widget _buildTopImage(BuildContext context) {
    return Image.asset(
      'assets/images/app_logo.png',
      width: 160.w,
      height: 160.h,
    );
  }

  Widget _buildButton(BuildContext context, SignupController controller) {
    return CustomButton(
      title: S.current.signup_screen_text,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      textColor: Theme.of(context).colorScheme.primary,
      onPressed: () => controller.register(context, _formKey),
    );
  }

  Widget _buildSignupText(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: S.current.signup_screen_account,
        style: TextStyle(
          color: Theme.of(context).colorScheme.tertiary,
          fontFamily: 'CustomFont',
        ),
        children: [
          TextSpan(
            text: S.current.signup_screen_login,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'CustomFont',
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => Get.off(
                    Get.off(
                      () => const LoginScreen(),
                      transition: Transition.fade,
                      duration: const Duration(milliseconds: 500),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
