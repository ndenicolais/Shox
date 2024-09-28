import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shox/generated/l10n.dart';
import 'package:shox/pages/account/login_page.dart';
import 'package:shox/pages/account/signup_page.dart';
import 'package:shox/widgets/custom_button.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  WelcomePageState createState() => WelcomePageState();
}

class WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 30.r, horizontal: 30.r),
            child: Center(
              child: Column(
                children: [
                  const Spacer(flex: 1),
                  _buildTitle(context),
                  const Spacer(flex: 2),
                  _buildLogo(),
                  const Spacer(flex: 2),
                  _buildLoginButton(context),
                  20.verticalSpace,
                  _buildSignupButton(context),
                  const Spacer(flex: 1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      'assets/images/app_logo.png',
      width: 180.r,
      height: 180.r,
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Center(
      child: Text(
        S.current.welcome_text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontSize: 68.r,
          fontWeight: FontWeight.bold,
          fontFamily: 'CustomFont',
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return CustomButton(
      title: S.current.welcome_login,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      textColor: Theme.of(context).colorScheme.primary,
      onPressed: () {
        Get.to(
          () => const LoginPage(),
          transition: Transition.fade,
          duration: const Duration(milliseconds: 500),
        );
      },
    );
  }

  Widget _buildSignupButton(BuildContext context) {
    return CustomButton(
      title: S.current.welcome_signup,
      backgroundColor: Theme.of(context).colorScheme.primary,
      textColor: Theme.of(context).colorScheme.secondary,
      isOutline: true,
      onPressed: () {
        Get.to(
          () => const SignupPage(),
          transition: Transition.fade,
          duration: const Duration(milliseconds: 500),
        );
      },
    );
  }
}
