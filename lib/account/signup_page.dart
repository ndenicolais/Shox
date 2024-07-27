import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/account/login_page.dart';
import 'package:shox/pages/shoes/shoes_home.dart';
import 'package:shox/theme/app_colors.dart';
import 'package:shox/utils/validator.dart';
import 'package:shox/widgets/account_textfield.dart';

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
            errorMessage =
                'The email address is already in use by another account.';
            break;
          case 'invalid-email':
            errorMessage = 'The email address is not valid.';
            break;
          case 'operation-not-allowed':
            errorMessage = 'Email/password accounts are not enabled.';
            break;
          case 'weak-password':
            errorMessage = 'The password is too weak.';
            break;
          default:
            errorMessage = 'An error occurred. Please try again.';
            logger.e(
                "FirebaseAuthException with unknown code: ${e.code}, message: ${e.message}");
        }
        _showErrorSnackBar(errorMessage);
      } catch (e) {
        _showErrorSnackBar("An unexpected error occurred. Please try again.");
        logger.e("Error: $e");
      }
    }
  }

  void _showConfirmToastBar(String userName) {
    // Show error toastbar
    DelightToastBar(
      position: DelightSnackbarPosition.bottom,
      snackbarDuration: const Duration(milliseconds: 1500),
      builder: (context) => ToastCard(
        color: AppColors.confirmColor,
        leading: const Icon(
          MingCuteIcons.mgc_hands_clapping_fill,
          color: AppColors.white,
          size: 28,
        ),
        title: Text(
          'Welcome, $userName!',
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 16,
          ),
        ),
      ),
      autoDismiss: true,
    ).show(context);
  }

  void _showErrorSnackBar(String? message) {
    if (message != null) {
      // Show error toastbar
      DelightToastBar(
        position: DelightSnackbarPosition.top,
        snackbarDuration: const Duration(milliseconds: 1500),
        builder: (context) => ToastCard(
          color: AppColors.errorColor,
          leading: const Icon(
            MingCuteIcons.mgc_warning_fill,
            color: AppColors.white,
            size: 28,
          ),
          title: Text(
            message,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 16,
            ),
          ),
        ),
        autoDismiss: true,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 80),
              Center(
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 60,
                    fontFamily: 'CustomFont',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Center(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        children: [
                          const SizedBox(height: 80),
                          SizedBox(
                            width: 320,
                            child: AccountTextField(
                              controller: _nameController,
                              labelText: 'Name',
                              hintText: 'Enter your name',
                              prefixIcon: MingCuteIcons.mgc_user_2_fill,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Name is required';
                                }

                                String? nameError = val.nameValidationError;

                                if (nameError != null) {
                                  return 'Invalid name: $nameError';
                                }

                                return null;
                              },
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              textCapitalization: TextCapitalization.sentences,
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: 320,
                            child: AccountTextField(
                              controller: _emailController,
                              labelText: 'Email',
                              hintText: 'Enter your email',
                              prefixIcon: MingCuteIcons.mgc_mail_fill,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Email is required';
                                }

                                String? emailError = val.emailValidationError;

                                if (emailError != null) {
                                  return 'Invalid email: $emailError';
                                }

                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: 320,
                            child: AccountTextField(
                              controller: _passwordController,
                              labelText: 'Password',
                              hintText: 'Enter your password',
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
                                  return 'Password is required';
                                }

                                String? passwordError =
                                    val.passwordValidationError;

                                if (passwordError != null) {
                                  return 'Invalid password: $passwordError';
                                }

                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 40),
                          SizedBox(
                            width: 320,
                            height: 60,
                            child: MaterialButton(
                              onPressed: () {
                                _register();
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              color: Theme.of(context).colorScheme.secondary,
                              child: Text(
                                'Register',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 24,
                                  fontFamily: 'CustomFont',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          RichText(
                            text: TextSpan(
                              text: 'Have an account? ',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.tertiary,
                                fontFamily: 'CustomFont',
                              ),
                              children: [
                                TextSpan(
                                  text: 'Login',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'CustomFont',
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Get.to(
                                        () => const LoginPage(),
                                        transition: Transition.fade,
                                        duration:
                                            const Duration(milliseconds: 500),
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
