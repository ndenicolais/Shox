import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shox/generated/l10n.dart';
import 'package:shox/onboarding/onboarding_items.dart';
import 'package:shox/pages/shoes/shoes_home.dart';
import 'package:shox/pages/welcome_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  OnboardingPageState createState() => OnboardingPageState();
}

class OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  final OnboardingItems onboardingItems = OnboardingItems();
  final int _totalPages = 4;
  bool isLastPage = false;

  void _nextPage() {
    if (_pageController.page!.toInt() < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _checkRememberMe();
    }
  }

  void _skip() {
    _checkRememberMe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              onPageChanged: (index) => setState(
                  () => isLastPage = onboardingItems.items.length - 1 == index),
              controller: _pageController,
              itemCount: onboardingItems.items.length,
              itemBuilder: (context, index) {
                final item = onboardingItems.items[index];
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 180.r,
                        height: 180.r,
                        child: item.image,
                      ),
                      20.verticalSpace,
                      Text(
                        item.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: 70.r,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'CustomFont',
                        ),
                      ),
                      40.verticalSpace,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 22.r),
                        child: Text(
                          item.description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 18.r,
                            fontFamily: 'CustomFont',
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Positioned(
              bottom: 30.r,
              left: 0.r,
              right: 0.r,
              child: isLastPage
                  ? Center(
                      child: SizedBox(
                        width: 250.r,
                        height: 50.r,
                        child: MaterialButton(
                          onPressed: () async {
                            final pres = await SharedPreferences.getInstance();
                            pres.setBool("onboarding_completed", true);
                            _checkRememberMe();
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.r),
                            side: BorderSide(
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                          color: Theme.of(context).colorScheme.secondary,
                          child: Center(
                            child: Text(
                              S.current.onboarding_finish,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 20.r,
                                fontFamily: 'CustomFont',
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: _skip,
                            child: Text(
                              S.current.onboarding_skip,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.tertiary,
                                fontSize: 14.r,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'CustomFont',
                              ),
                            ),
                          ),
                          Center(
                            child: SmoothPageIndicator(
                              controller: _pageController,
                              count: _totalPages,
                              effect: WormEffect(
                                dotWidth: 10.r,
                                dotHeight: 10.r,
                                spacing: 16.r,
                                radius: 8.r,
                                activeDotColor:
                                    Theme.of(context).colorScheme.tertiary,
                                dotColor:
                                    Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: _nextPage,
                            child: Text(
                              S.current.onboarding_next,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.tertiary,
                                fontSize: 14.r,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'CustomFont',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool rememberMe = prefs.getBool('remember_me') ?? false;

    if (rememberMe) {
      Get.offAll(
        () => const ShoesHome(),
        transition: Transition.fade,
        duration: const Duration(milliseconds: 500),
      );
    } else {
      Get.offAll(
        () => const WelcomePage(),
        transition: Transition.fade,
        duration: const Duration(milliseconds: 500),
      );
    }
  }
}
