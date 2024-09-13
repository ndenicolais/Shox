import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shox/account/signup_page.dart';
import 'package:shox/generated/l10n.dart';
import 'package:shox/pages/shoes/shoes_home.dart';
import 'package:shox/theme/app_colors.dart';
import 'package:shox/widgets/account_textfield.dart';
import 'package:shox/widgets/custom_toast_bar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  var logger = Logger();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _checkRememberMe();
  }

  Future<void> _checkRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool rememberMe = prefs.getBool('remember_me') ?? false;

    if (rememberMe) {
      Get.to(
        () => const ShoesHome(),
        transition: Transition.fade,
        duration: const Duration(milliseconds: 500),
      );
    }
  }

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;

      if (user != null) {
        // Retrieve email username from Firestore
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        String displayName = userDoc.get('name');
        // Save the state of "Remember Me"
        if (rememberMe) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('remember_me', true);
        }

        _showConfirmToastBar(displayName);

        // Navigate to HomePage
        Get.to(
          () => const ShoesHome(),
          transition: Transition.fade,
          duration: const Duration(milliseconds: 500),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = S.current.toast_login_user;
          break;
        case 'wrong-password':
          errorMessage = S.current.toast_login_wrong_password;
          break;
        case 'invalid-email':
          errorMessage = S.current.toast_login_invalid_email;
          break;
        case 'invalid-credential':
          errorMessage = S.current.toast_login_invalid_credential;
          break;
        default:
          errorMessage = S.current.toast_login_generic_error;
          logger.e(
              "FirebaseAuthException with unknown code: ${e.code}, message: ${e.message}");
      }
      _showErrorSnackBar(errorMessage);
    } catch (e) {
      _showErrorSnackBar(S.current.toast_login_generic_error);
      logger.e("Error: $e");
    }
  }

  Future<void> _loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        String? googleUserName = user.displayName;
        if (googleUserName != null) {
          List<String> nameParts = googleUserName.split(" ");
          setState(
            () {
              // Take only the first name
              googleUserName = nameParts[0];
            },
          );
        }
        // Save the state of "Remember Me"
        if (rememberMe) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('remember_me', true);
        }

        _showConfirmToastBar(googleUserName!);

        // Navigate to HomePage
        Get.to(
          () => const ShoesHome(),
          transition: Transition.fade,
          duration: const Duration(milliseconds: 500),
        );
      }
    } catch (e) {
      // Show error message
      logger.e("Error signing in with Google: $e");
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
      title: '${S.current.toast_login_welcome}$userName!',
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
                  'assets/images/img_user_login.png',
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
                            return null;
                          },
                        ),
                      ),
                      20.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Transform.scale(
                            scale: 1.4.r,
                            child: Checkbox(
                              value: rememberMe,
                              onChanged: (bool? value) {
                                setState(
                                  () {
                                    rememberMe = value!;
                                  },
                                );
                              },
                              checkColor: Theme.of(context).colorScheme.primary,
                              activeColor:
                                  Theme.of(context).colorScheme.secondary,
                              shape: const CircleBorder(),
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                          ),
                          Text(
                            S.current.login_remember,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontSize: 18.r,
                              fontFamily: 'CustomFont',
                            ),
                          )
                        ],
                      ),
                      20.verticalSpace,
                      SizedBox(
                        width: 320.r,
                        height: 60.r,
                        child: MaterialButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              _login();
                            }
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          color: Theme.of(context).colorScheme.secondary,
                          child: Text(
                            S.current.login_text,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 24.r,
                              fontFamily: 'CustomFont',
                            ),
                          ),
                        ),
                      ),
                      20.verticalSpace,
                      Divider(
                        thickness: 1,
                        indent: 80,
                        endIndent: 80,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      20.verticalSpace,
                      GestureDetector(
                        onTap: _loginWithGoogle,
                        child: Image.asset(
                          'assets/images/img_google.png',
                          width: 40.r,
                        ),
                      ),
                      20.verticalSpace,
                      RichText(
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
                                ..onTap = () {
                                  Get.to(
                                    () => const SignupPage(),
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
