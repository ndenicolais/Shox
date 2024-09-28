import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shox/pages/account/signup_page.dart';
import 'package:shox/generated/l10n.dart';
import 'package:shox/pages/shoes/shoes_home.dart';
import 'package:shox/services/auth_service.dart';
import 'package:shox/widgets/account_textfield.dart';
import 'package:shox/widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool rememberMe = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkRememberMe();
  }

  Future<void> _checkRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('remember_me') ?? false) {
      Get.to(() => const ShoesHome(),
          transition: Transition.fade,
          duration: const Duration(milliseconds: 500));
    }
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    User? user = await _authService.loginWithEmailPassword(
      _emailController.text,
      _passwordController.text,
      context,
      rememberMe,
    );

    if (user != null) {
      Get.to(() => const ShoesHome(),
          transition: Transition.fade,
          duration: const Duration(milliseconds: 500));
    }
  }

  Future<void> _loginWithGoogle() async {
    User? user = await _authService.loginWithGoogle(
      context,
      rememberMe,
    );

    if (user != null) {
      Get.to(() => const ShoesHome(),
          transition: Transition.fade,
          duration: const Duration(milliseconds: 500));
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
                20.verticalSpace,
                _buildRememberMeCheckbox(),
                20.verticalSpace,
                _buildButtons(),
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
        S.current.login_title,
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
      'assets/images/img_user_login.png',
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
  ) {
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
                    color: Theme.of(context).colorScheme.tertiary),
                onPressed: () =>
                    setState(() => _passwordVisible = !_passwordVisible),
              )
            : null,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        obscureText: isPassword && !_passwordVisible,
        validator: (val) {
          if (val == null || val.isEmpty) {
            return isPassword
                ? S.current.validator_password_required
                : S.current.validator_email_required;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextField(
            _emailController,
            S.current.validator_email,
            S.current.validator_email_hint,
            MingCuteIcons.mgc_mail_fill,
            false,
            TextInputType.emailAddress,
            TextInputAction.next,
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
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        CustomButton(
          title: S.current.login_text,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          textColor: Theme.of(context).colorScheme.primary,
          onPressed: _login,
        ),
        SizedBox(height: 20.r),
        Divider(
            thickness: 1,
            indent: 80,
            endIndent: 80,
            color: Theme.of(context).colorScheme.secondary),
        GestureDetector(
          onTap: _loginWithGoogle,
          child: Image.asset(
            'assets/images/img_google.png',
            width: 40.r,
          ),
        ),
      ],
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.scale(
          scale: 1.4.r,
          child: Checkbox(
            value: rememberMe,
            onChanged: (value) => setState(() => rememberMe = value!),
            checkColor: Theme.of(context).colorScheme.primary,
            activeColor: Theme.of(context).colorScheme.secondary,
            shape: const CircleBorder(),
            side: BorderSide(color: Theme.of(context).colorScheme.tertiary),
          ),
        ),
        Text(
          S.current.login_remember,
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 18.r,
            fontFamily: 'CustomFont',
          ),
        ),
      ],
    );
  }

  Widget _buildSignupText() {
    return RichText(
      text: TextSpan(
        text: S.current.login_account,
        style: TextStyle(
          color: Theme.of(context).colorScheme.tertiary,
          fontSize: 14.r,
          fontFamily: 'CustomFont',
        ),
        children: [
          TextSpan(
            text: S.current.login_signup,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 14.r,
              fontWeight: FontWeight.bold,
              fontFamily: 'CustomFont',
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => Get.to(() => const SignupPage(),
                  transition: Transition.fade,
                  duration: const Duration(milliseconds: 500)),
          ),
        ],
      ),
    );
  }
}
