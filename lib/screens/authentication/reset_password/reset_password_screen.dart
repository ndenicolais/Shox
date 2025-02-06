import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/generated/l10n.dart';
import 'package:shox/screens/authentication/reset_password/reset_password_controller.dart';
import 'package:shox/screens/authentication/reset_password/reset_password_form.dart';
import 'package:shox/widgets/custom_button.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ResetPasswordScreenState createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final ResetPasswordController controller = Get.put(ResetPasswordController());
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
                  SizedBox(height: 50.h),
                  _buildTextDescription(context),
                  SizedBox(height: 50.h),
                  ResetPasswordForm(
                      context: context,
                      formKey: _formKey,
                      emailController: controller.emailController),
                  SizedBox(height: 20.h),
                  _buildResetButton(context, controller),
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
        S.current.reset_password_screen_title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontWeight: FontWeight.bold,
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

  Widget _buildTextDescription(BuildContext context) {
    return SizedBox(
      width: 320.w,
      child: Text(
        S.current.reset_password_screen_description,
        style: TextStyle(
          color: Theme.of(context).colorScheme.tertiary,
          fontSize: 24.sp,
          fontFamily: 'CustomFont',
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildResetButton(
      BuildContext context, ResetPasswordController controller) {
    return CustomButton(
      title: S.current.reset_password_screen_text,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      textColor: Theme.of(context).colorScheme.primary,
      onPressed: () => controller.resetPassword(context, _formKey),
    );
  }
}
