import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  // Check if the user has selected "Remember Me" and navigate accordingly
  Future<void> _checkRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Text(
              'Shox',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 100,
                fontWeight: FontWeight.bold,
                fontFamily: 'CustomFont',
              ),
            ),
            const SizedBox(height: 50),
            Image.asset(
              'assets/images/app_logo.png',
              width: 250,
              height: 250,
            ),
            const SizedBox(height: 50),
            Text(
              'Your\nshoes\neverywhere',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 34,
                fontFamily: 'CustomFont',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
