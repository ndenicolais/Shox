import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shox/account/signup_page.dart';
import 'package:shox/shoes/shoes_home.dart';
import 'package:shox/theme/app_colors.dart';
import 'package:shox/widgets/account_textfield.dart';

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
          errorMessage = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is badly formatted.';
          break;
        case 'invalid-credential':
          errorMessage =
              'The supplied auth credential is incorrect, malformed or has expired.';
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
      logger.e("Error signing in with Google: $e");
      // Show error message
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
                  'Login',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 60,
                    fontFamily: 'CustomFont',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Transform.scale(
                                scale: 1.4,
                                child: Checkbox(
                                  value: rememberMe,
                                  onChanged: (bool? value) {
                                    setState(
                                      () {
                                        rememberMe = value!;
                                      },
                                    );
                                  },
                                  checkColor:
                                      Theme.of(context).colorScheme.primary,
                                  activeColor:
                                      Theme.of(context).colorScheme.secondary,
                                  shape: const CircleBorder(),
                                  side: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                              ),
                              Text(
                                'Remember me',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  fontSize: 18,
                                  fontFamily: 'CustomFont',
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: 320,
                            height: 60,
                            child: MaterialButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();

                                  _login();
                                }
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              color: Theme.of(context).colorScheme.secondary,
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 24,
                                  fontFamily: 'CustomFont',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Or continue with',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontSize: 18,
                              fontFamily: 'CustomFont',
                            ),
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: _loginWithGoogle,
                            child: Image.asset(
                              'assets/images/img_google.png',
                              width: 40,
                            ),
                          ),
                          const SizedBox(height: 20),
                          RichText(
                            text: TextSpan(
                              text: 'Dont have an account? ',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.tertiary,
                                fontSize: 14,
                                fontFamily: 'CustomFont',
                              ),
                              children: [
                                TextSpan(
                                  text: 'Sign Up',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'CustomFont',
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Get.to(
                                        () => const SignupPage(),
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
