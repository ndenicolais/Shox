import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shox/account/login_page.dart';
import 'package:shox/account/signup_page.dart';
import 'package:shox/generated/l10n.dart';

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
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 30.r, horizontal: 30.r),
            child: Center(
              child: Column(
                children: [
                  const Spacer(flex: 1),
                  Center(
                    child: Text(
                      S.current.welcome_text,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 68.r,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'CustomFont',
                      ),
                    ),
                  ),
                  const Spacer(flex: 2),
                  Image.asset(
                    'assets/images/app_logo.png',
                    width: 180.r,
                    height: 180.r,
                  ),
                  const Spacer(flex: 2),
                  SizedBox(
                    width: 280.r,
                    height: 60.r,
                    child: MaterialButton(
                      onPressed: () {
                        Get.to(
                          () => const LoginPage(),
                          transition: Transition.fade,
                          duration: const Duration(milliseconds: 500),
                        );
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                      child: Center(
                        child: Text(
                          S.current.welcome_login,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 24.r,
                            fontFamily: 'CustomFont',
                          ),
                        ),
                      ),
                    ),
                  ),
                  20.verticalSpace,
                  SizedBox(
                    width: 280.r,
                    height: 60.r,
                    child: MaterialButton(
                      onPressed: () {
                        Get.to(
                          () => const SignupPage(),
                          transition: Transition.fade,
                          duration: const Duration(milliseconds: 500),
                        );
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.r),
                        side: BorderSide(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      color: Theme.of(context).colorScheme.primary,
                      child: Center(
                        child: Text(
                          S.current.welcome_signup,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 24.r,
                            fontFamily: 'CustomFont',
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(flex: 1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
