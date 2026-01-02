import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shox/common/widgets/logo_widget.dart';
import 'package:shox/screens/auth/login/screens/login_screen.dart';
import 'package:shox/screens/auth/signup/screens/signup_screen.dart';
import 'package:shox/theme/app_font_sizes.dart';
import 'package:shox/common/widgets/button_widget.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(30.r),
            child: Center(
              child: Column(
                children: [
                  const Spacer(flex: 1),
                  _buildTitle(),
                  const Spacer(flex: 2),
                  LogoWidget(
                    width: 200.w,
                    height: 200.h,
                    semanticLabel: 'Welcome Logo',
                  ),
                  const Spacer(flex: 2),
                  _buildLoginButton(),
                  SizedBox(height: 20.h),
                  _buildSignupButton(),
                  const Spacer(flex: 1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Center(
      child: Text(
        AppLocalizations.of(context)!.welcome_text,
        style: GoogleFonts.montserrat(
          color: Theme.of(context).colorScheme.secondary,
          fontSize: AppFontSizes.titanic,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return ButtonWidget(
      width: 280.w,
      height: 60.h,
      text: AppLocalizations.of(context)!.welcome_login,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      textColor: Theme.of(context).colorScheme.primary,
      fontSize: AppFontSizes.large,
      isOutline: false,
      onPressed: () {
        Get.to(
          () => const LoginScreen(),
          transition: Transition.fade,
          duration: const Duration(milliseconds: 500),
        );
      },
    );
  }

  Widget _buildSignupButton() {
    return ButtonWidget(
      width: 280.w,
      height: 60.h,
      text: AppLocalizations.of(context)!.welcome_signup,
      backgroundColor: Theme.of(context).colorScheme.primary,
      textColor: Theme.of(context).colorScheme.secondary,
      fontSize: AppFontSizes.large,
      isOutline: true,
      onPressed: () {
        Get.to(
          () => const SignupScreen(),
          transition: Transition.fade,
          duration: const Duration(milliseconds: 500),
        );
      },
    );
  }
}
