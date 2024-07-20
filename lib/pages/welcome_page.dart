import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shox/account/login_page.dart';
import 'package:shox/account/signup_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  WelcomePageState createState() => WelcomePageState();
}

class WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 80,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'Welcome',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 60,
                      fontFamily: 'CustomFont',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 150),
                    Image.asset(
                      'assets/images/app_logo.png',
                      width: 250,
                      height: 250,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Organize your shoes\nand always have them\nwith you',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 24,
                        fontFamily: 'CustomFont',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: 280,
                      height: 60,
                      child: MaterialButton(
                        onPressed: () {
                          Get.to(
                            () => const LoginPage(),
                            transition: Transition.fade,
                            duration: const Duration(milliseconds: 500),
                          );
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        color: Theme.of(context).colorScheme.secondary,
                        child: Center(
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
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 280,
                      height: 60,
                      child: MaterialButton(
                        onPressed: () {
                          Get.to(
                            () => const SignupPage(),
                            transition: Transition.fade,
                            duration: const Duration(milliseconds: 500),
                          );
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: BorderSide(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                        color: Theme.of(context).colorScheme.primary,
                        child: Center(
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 24,
                              fontFamily: 'CustomFont',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
