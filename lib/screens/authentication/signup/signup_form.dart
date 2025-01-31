import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/generated/l10n.dart';
import 'package:shox/utils/validator.dart';
import 'package:shox/widgets/account_textfield.dart';

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
        children: [
          _buildTextField(
            nameController,
            S.current.validator_name,
            S.current.validator_name_hint,
            MingCuteIcons.mgc_user_2_fill,
            TextInputType.text,
            TextCapitalization.sentences,
            TextInputAction.next,
            (val) => _validateName(val),
          ),
          SizedBox(height: 20.h),
          _buildTextField(
            emailController,
            S.current.validator_email,
            S.current.validator_email_hint,
            MingCuteIcons.mgc_mail_fill,
            TextInputType.emailAddress,
            TextCapitalization.none,
            TextInputAction.next,
            (val) => _validateEmail(val),
          ),
          SizedBox(height: 20.h),
          _buildPasswordField(
            passwordController,
            S.current.validator_password,
            S.current.validator_password_hint,
            MingCuteIcons.mgc_lock_fill,
            TextInputType.text,
            TextCapitalization.none,
            TextInputAction.done,
            (val) => _validatePassword(val),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String hint,
    IconData prefixIcon,
    TextInputType keyboardType,
    TextCapitalization textCapitalization,
    TextInputAction textInputAction,
    String? Function(String?) validator,
  ) {
    return SizedBox(
      width: 320.w,
      child: AccountTextField(
        controller: controller,
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        textCapitalization: textCapitalization,
        validator: validator,
      ),
    );
  }

  Widget _buildPasswordField(
    TextEditingController controller,
    String label,
    String hint,
    IconData prefixIcon,
    TextInputType keyboardType,
    TextCapitalization textCapitalization,
    TextInputAction textInputAction,
    String? Function(String?) validator,
  ) {
    return SizedBox(
      width: 320.w,
      child: Obx(
        () => AccountTextField(
          controller: controller,
          labelText: label,
          hintText: hint,
          prefixIcon: prefixIcon,
          suffixIcon: Obx(
            () => IconButton(
              icon: Icon(
                passwordVisible.value
                    ? MingCuteIcons.mgc_eye_2_fill
                    : MingCuteIcons.mgc_eye_close_fill,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              onPressed: togglePasswordVisibility,
            ),
          ),
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          obscureText: !passwordVisible.value,
          validator: validator,
        ),
      ),
    );
  }

  String? _validateName(String? val) {
    if (val == null || val.isEmpty) {
      return S.current.validator_name_required;
    }
    String? nameError = val.nameValidationError;
    if (nameError != null) {
      return '${S.current.validator_name_error} $nameError';
    }
    return null;
  }

  String? _validateEmail(String? val) {
    if (val == null || val.isEmpty) {
      return S.current.validator_email_required;
    }
    String? emailError = val.emailValidationError;
    if (emailError != null) {
      return '${S.current.validator_email_error} $emailError';
    }
    return null;
  }

  String? _validatePassword(String? val) {
    if (val == null || val.isEmpty) {
      return S.current.validator_password_required;
    }
    String? passwordError = val.passwordValidationError;
    if (passwordError != null) {
      return '${S.current.validator_password_error} $passwordError';
    }
    return null;
  }
}
