import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/account/login_page.dart';
import 'package:shox/generated/l10n.dart';
import 'package:shox/pages/shoes/shoes_home.dart';
import 'package:shox/theme/app_colors.dart';
import 'package:shox/utils/validator.dart';
import 'package:shox/widgets/account_textfield.dart';
import 'package:shox/widgets/custom_toast_bar.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  var logger = Logger();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _register() async {
    if (_formKey.currentState?.validate() == true) {
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        User? user = userCredential.user;
        if (user != null) {
          // Save additional data (name) to Firestore
          await _firestore.collection('users').doc(user.uid).set(
            {
              'name': _nameController.text.trim(),
              'email': user.email,
            },
          );

          _showConfirmToastBar(_nameController.text.trim());

          // Navigate to MainPage
          Get.to(
            () => const ShoesHome(),
            transition: Transition.fade,
            duration: const Duration(milliseconds: 500),
          );
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = S.current.toast_signup_exist_email;
            break;
          case 'invalid-email':
            errorMessage = S.current.toast_signup_invalid_email;
            break;
          case 'operation-not-allowed':
            errorMessage = S.current.toast_signup_operation;
            break;
          case 'weak-password':
            errorMessage = S.current.toast_signup_password;
            break;
          default:
            errorMessage = S.current.toast_signup_generic_error;
            logger.e(
                "FirebaseAuthException with unknown code: ${e.code}, message: ${e.message}");
        }
        _showErrorSnackBar(errorMessage);
      } catch (e) {
        _showErrorSnackBar(S.current.toast_signup_generic_error);
        logger.e("Error: $e");
      }
    }
  }

  void _showConfirmToastBar(String userName) {
    // Show confirm toastbar
    showCustomToastBar(
      context,
      position: DelightSnackbarPosition.bottom,
      color: AppColors.confirmColor,
      icon: const Icon(
        MingCuteIcons.mgc_hands_clapping_fill,
      ),
      title: '${S.current.toast_signup_welcome}$userName!',
    );
  }

  void _showErrorSnackBar(String? message) {
    if (message != null) {
      // Show error toastbar
      showCustomToastBar(
        context,
        position: DelightSnackbarPosition.top,
        color: AppColors.errorColor,
        icon: const Icon(
          MingCuteIcons.mgc_warning_fill,
        ),
        title: message,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30.r, horizontal: 30.r),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/img_user_signup.png',
                  width: 120.r,
                  height: 120.r,
                ),
                80.verticalSpace,
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 320.r,
                        child: AccountTextField(
                          controller: _nameController,
                          labelText: S.current.validator_name,
                          hintText: S.current.validator_name_hint,
                          prefixIcon: MingCuteIcons.mgc_user_2_fill,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return S.current.validator_name_required;
                            }

                            String? nameError = val.nameValidationError;

                            if (nameError != null) {
                              return '${S.current.validator_name_error} $nameError';
                            }

                            return null;
                          },
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ),
                      20.verticalSpace,
                      SizedBox(
                        width: 320.r,
                        child: AccountTextField(
                          controller: _emailController,
                          labelText: S.current.validator_email,
                          hintText: S.current.validator_email_hint,
                          prefixIcon: MingCuteIcons.mgc_mail_fill,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return S.current.validator_email_required;
                            }

                            String? emailError = val.emailValidationError;

                            if (emailError != null) {
                              return '${S.current.validator_email_error} $emailError';
                            }

                            return null;
                          },
                        ),
                      ),
                      20.verticalSpace,
                      SizedBox(
                        width: 320.r,
                        child: AccountTextField(
                          controller: _passwordController,
                          labelText: S.current.validator_password,
                          hintText: S.current.validator_password_hint,
                          prefixIcon: MingCuteIcons.mgc_lock_fill,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                            onPressed: () {
                              setState(
                                () {
                                  _passwordVisible = !_passwordVisible;
                                },
                              );
                            },
                          ),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          obscureText: !_passwordVisible,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return S.current.validator_password_required;
                            }

                            String? passwordError = val.passwordValidationError;

                            if (passwordError != null) {
                              return '${S.current.validator_password_error} $passwordError';
                            }

                            return null;
                          },
                        ),
                      ),
                      40.verticalSpace,
                      SizedBox(
                        width: 320.r,
                        height: 60.r,
                        child: MaterialButton(
                          onPressed: () {
                            _register();
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          color: Theme.of(context).colorScheme.secondary,
                          child: Text(
                            S.current.signup_text,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 24.r,
                              fontFamily: 'CustomFont',
                            ),
                          ),
                        ),
                      ),
                      20.verticalSpace,
                      RichText(
                        text: TextSpan(
                          text: S.current.signup_account,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontFamily: 'CustomFont',
                          ),
                          children: [
                            TextSpan(
                              text: S.current.signup_login,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 16.r,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'CustomFont',
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to(
                                    () => const LoginPage(),
                                    transition: Transition.fade,
                                    duration: const Duration(milliseconds: 500),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
