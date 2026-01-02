import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/common/widgets/textfield_widget.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final BuildContext context;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final RxBool passwordVisible;
  final bool rememberMe;
  final void Function() togglePasswordVisibility;
  final void Function() onLogin;
  final void Function() onLoginWithGoogle;

  const LoginForm({
    super.key,
    required this.context,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.passwordVisible,
    required this.rememberMe,
    required this.togglePasswordVisibility,
    required this.onLogin,
    required this.onLoginWithGoogle,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        spacing: 20.h,
        children: [
          TextFieldWidget(
            controller: emailController,
            labelText: AppLocalizations.of(context)!.validator_email,
            hintText: AppLocalizations.of(context)!.validator_email_hint,
            prefixIcon: MingCuteIcons.mgc_mail_line,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (val) {
              if (val == null || val.isEmpty) {
                return AppLocalizations.of(context)!.validator_email_required;
              }
              return null;
            },
          ),
          TextFieldWidget(
            controller: passwordController,
            labelText: AppLocalizations.of(context)!.validator_password,
            hintText: AppLocalizations.of(context)!.validator_password_hint,
            prefixIcon: MingCuteIcons.mgc_lock_line,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            obscureText: !passwordVisible.value,
            suffixIcon: IconButton(
              icon: Icon(
                passwordVisible.value
                    ? MingCuteIcons.mgc_eye_2_line
                    : MingCuteIcons.mgc_eye_close_line,
                color: Theme.of(context).colorScheme.tertiary,
                size: 18.sp,
              ),
              onPressed: togglePasswordVisibility,
            ),
            validator: (val) {
              if (val == null || val.isEmpty) {
                return AppLocalizations.of(context)!
                    .validator_password_required;
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
