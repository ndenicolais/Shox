import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shox/onboarding/onboarding_page.dart';
import 'package:shox/pages/welcome_page.dart';
import 'package:shox/pages/shoes/shoes_home.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  IntroPageState createState() => IntroPageState();
}

class IntroPageState extends State<IntroPage> {
  @override
  void initState() {
    super.initState();
    _startSplashScreen();
  }

  Future<void> _startSplashScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    _checkRememberMe();
  }

  Future<void> _checkRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

    if (!onboardingCompleted) {
      Get.to(
        () => const OnboardingPage(),
        transition: Transition.fade,
        duration: const Duration(milliseconds: 500),
      );
    } else {
      bool rememberMe = prefs.getBool('remember_me') ?? false;

      if (rememberMe) {
        Get.to(
          () => const ShoesHome(),
          transition: Transition.fade,
          duration: const Duration(milliseconds: 500),
        );
      } else {
        Get.to(
          () => const WelcomePage(),
          transition: Transition.fade,
          duration: const Duration(milliseconds: 500),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/app_logo.png',
              width: 180.r,
              height: 180.r,
            ),
            Text(
              'Shox',
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontSize: 80.r,
                fontWeight: FontWeight.bold,
                fontFamily: 'CustomFont',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
