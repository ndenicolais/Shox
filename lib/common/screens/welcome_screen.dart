import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shox/theme/app_spacing.dart';
import 'package:get/get.dart';
import 'package:shox/common/widgets/logo_widget.dart';
import 'package:shox/core/routes/app_routes.dart';
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
            padding: EdgeInsets.all(AppSpacing.screen.r),
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
        style: TextStyle(
          fontFamily: 'CustomFontBold',
          color: Theme.of(context).colorScheme.secondary,
          fontSize: AppFontSizes.titanic,
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return ButtonWidget(
      width: 280.w,
      height: 60.h,
      text: AppLocalizations.of(context)!.welcome_login,
      fontSize: AppFontSizes.large,
      isOutline: false,
      onPressed: () {
        Get.toNamed(AppRoutes.login);
      },
    );
  }

  Widget _buildSignupButton() {
    return ButtonWidget(
      width: 280.w,
      height: 60.h,
      text: AppLocalizations.of(context)!.welcome_signup,
      fontSize: AppFontSizes.large,
      isOutline: true,
      onPressed: () {
        Get.toNamed(AppRoutes.signup);
      },
    );
  }
}
