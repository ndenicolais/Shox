import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/pages/account/login_page.dart';
import 'package:shox/generated/l10n.dart';
import 'package:shox/pages/shoes/shoes_home.dart';
import 'package:shox/services/auth_service.dart';
import 'package:shox/utils/validator.dart';
import 'package:shox/widgets/account_textfield.dart';
import 'package:shox/widgets/custom_button.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _register() async {
    if (_formKey.currentState?.validate() == true) {
      User? user = await _authService.signUpWithEmailPassword(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
        context,
      );

      if (user != null) {
        Get.to(() => const ShoesHome(),
            transition: Transition.fade,
            duration: const Duration(milliseconds: 500));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30.r, horizontal: 30.r),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTopImage(),
                80.verticalSpace,
                _buildForm(context),
                40.verticalSpace,
                _buildButton(),
                20.verticalSpace,
                _buildSignupText(),
              ],
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
        S.current.signup_title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.tertiary,
          fontWeight: FontWeight.bold,
          fontFamily: 'CustomFont',
        ),
      ),
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.secondary,
    );
  }

  Widget _buildTopImage() {
    return Image.asset(
      'assets/images/img_user_signup.png',
      width: 120.r,
      height: 120.r,
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      String hint,
      IconData prefixIcon,
      bool isPassword,
      TextInputType? keyboardType,
      TextInputAction? textInputAction,
      String? Function(String?) validator) {
    return SizedBox(
      width: 320.r,
      child: AccountTextField(
        controller: controller,
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                onPressed: () =>
                    setState(() => _passwordVisible = !_passwordVisible),
              )
            : null,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        obscureText: isPassword && !_passwordVisible,
        validator: validator,
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

  Widget _buildButton() {
    return CustomButton(
      title: S.current.signup_text,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      textColor: Theme.of(context).colorScheme.primary,
      onPressed: _register,
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextField(
            _nameController,
            S.current.validator_name,
            S.current.validator_name_hint,
            MingCuteIcons.mgc_user_2_fill,
            false,
            TextInputType.text,
            TextInputAction.next,
            (val) => _validateName(val),
          ),
          SizedBox(height: 20.r),
          _buildTextField(
            _emailController,
            S.current.validator_email,
            S.current.validator_email_hint,
            MingCuteIcons.mgc_mail_fill,
            false,
            TextInputType.emailAddress,
            TextInputAction.next,
            (val) => _validateEmail(val),
          ),
          SizedBox(height: 20.r),
          _buildTextField(
            _passwordController,
            S.current.validator_password,
            S.current.validator_password_hint,
            MingCuteIcons.mgc_lock_fill,
            true,
            TextInputType.text,
            TextInputAction.done,
            (val) => _validatePassword(val),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupText() {
    return RichText(
      text: TextSpan(
        text: S.current.signup_account,
        style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontFamily: 'CustomFont'),
        children: [
          TextSpan(
            text: S.current.signup_login,
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 16.r,
                fontWeight: FontWeight.bold,
                fontFamily: 'CustomFont'),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.to(() => const LoginPage(),
                    transition: Transition.fade,
                    duration: const Duration(milliseconds: 500));
              },
          ),
        ],
      ),
    );
  }
}
