import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/core/utils/validator.dart';
import 'package:shox/common/widgets/textfield_widget.dart';

class SignupForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final BuildContext context;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final RxBool passwordVisible;
  final VoidCallback togglePasswordVisibility;

  const SignupForm({
    super.key,
    required this.context,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.passwordVisible,
    required this.togglePasswordVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        spacing: 20.h,
        children: [
          TextFieldWidget(
            controller: nameController,
            labelText: AppLocalizations.of(context)!.validator_name,
            hintText: AppLocalizations.of(context)!.validator_name_hint,
            prefixIcon: MingCuteIcons.mgc_user_2_line,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
            validator: (val) => val?.nameValidationError(context),
          ),
          TextFieldWidget(
            controller: emailController,
            labelText: AppLocalizations.of(context)!.validator_email,
            hintText: AppLocalizations.of(context)!.validator_email_hint,
            prefixIcon: MingCuteIcons.mgc_mail_line,
            keyboardType: TextInputType.emailAddress,
            textCapitalization: TextCapitalization.none,
            textInputAction: TextInputAction.next,
            validator: (val) => val?.emailValidationError(context),
          ),
          Obx(() => TextFieldWidget(
                controller: passwordController,
                labelText: AppLocalizations.of(context)!.validator_password,
                hintText: AppLocalizations.of(context)!.validator_password_hint,
                prefixIcon: MingCuteIcons.mgc_lock_line,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.none,
                textInputAction: TextInputAction.done,
                validator: (val) => val?.passwordValidationError(context),
                obscureText: !passwordVisible.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    passwordVisible.value
                        ? MingCuteIcons.mgc_eye_2_line
                        : MingCuteIcons.mgc_eye_close_line,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  onPressed: togglePasswordVisibility,
                ),
              )),
        ],
      ),
    );
  }
}
