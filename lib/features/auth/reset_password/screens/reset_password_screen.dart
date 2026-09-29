import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shox/common/widgets/app_bar_widget.dart';
import 'package:shox/common/widgets/logo_widget.dart';
import 'package:shox/features/auth/reset_password/controller/reset_password_controller.dart';
import 'package:shox/features/auth/reset_password/widgets/reset_password_form.dart';
import 'package:shox/common/widgets/button_widget.dart';
import 'package:shox/common/widgets/loader_widget.dart';
import 'package:shox/theme/app_font_sizes.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ResetPasswordScreenState createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final ResetPasswordController controller =
      Get.find<ResetPasswordController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: AppLocalizations.of(context)!.reset_password_screen_title,
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
                    semanticLabel: 'Reset Password Logo',
                  ),
                  SizedBox(height: 10.h),
                  _buildTextDescription(),
                  SizedBox(height: 10.h),
                  ResetPasswordForm(
                    context: context,
                    formKey: _formKey,
                    emailController: controller.emailController,
                  ),
                  SizedBox(height: 30.h),
                  _buildResetButton(controller),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextDescription() {
    return SizedBox(
      width: 300.w,
      child: Text(
        AppLocalizations.of(context)!.reset_password_screen_description,
        style: TextStyle(
          fontFamily: 'CustomFont',
          color: Theme.of(context).colorScheme.secondary,
          fontSize: AppFontSizes.medium,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildResetButton(ResetPasswordController controller) {
    return Obx(
      () => controller.isLoading.value
          ? LoaderWidget(width: 40.w, height: 40.h)
          : ButtonWidget(
              width: 280.w,
              height: 60.h,
              text: AppLocalizations.of(context)!.reset_password_screen_text,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              textColor: Theme.of(context).colorScheme.primary,
              fontSize: AppFontSizes.large,
              onPressed: () => controller.resetPassword(context, _formKey),
            ),
    );
  }
}
