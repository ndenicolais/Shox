import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shox/screens/home/screens/home_screen.dart';
import 'package:shox/common/screens/welcome_screen.dart';
import 'package:shox/theme/app_colors.dart';
import 'package:shox/theme/app_font_sizes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  late final List<OnboardingInfo> _pages;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pages = OnboardingItems(context).items;
  }

  void _nextPage() {
    if (_pageController.page!.toInt() < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _checkRememberMe();
    }
  }

  Future<void> _checkRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool rememberMe = prefs.getBool('remember_me') ?? false;

    if (rememberMe) {
      Get.offAll(
        () => const HomeScreen(),
        transition: Transition.fade,
        duration: const Duration(milliseconds: 500),
      );
    } else {
      Get.offAll(
        () => const WelcomeScreen(),
        transition: Transition.fade,
        duration: const Duration(milliseconds: 500),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.darkPeach,
                AppColors.whiteSmoke,
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _pages.length,
                      onPageChanged: (i) => setState(() => _currentIndex = i),
                      itemBuilder: (context, index) {
                        final item = _pages[index];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 220.w,
                              height: 220.h,
                              child: item.image,
                            ),
                            SizedBox(height: 32.h),
                            Text(
                              item.title,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                fontSize: AppFontSizes.massive,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 24.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Text(
                                item.description,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                  fontSize: AppFontSizes.normal,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: List.generate(
                          _pages.length,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            width: _currentIndex == i ? 20.w : 8.w,
                            height: 8.h,
                            decoration: BoxDecoration(
                              color: _currentIndex == i
                                  ? AppColors.darkPeach
                                  : AppColors.darkSalamon,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 160.w,
                        height: 48.h,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_currentIndex == _pages.length - 1) {
                              final pres =
                                  await SharedPreferences.getInstance();
                              pres.setBool("onboarding_completed", true);
                              _checkRememberMe();
                            } else {
                              _nextPage();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6F61),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.r),
                            ),
                            elevation: 2,
                          ),
                          child: Text(
                            _currentIndex == _pages.length - 1
                                ? AppLocalizations.of(context)!
                                    .onboarding_finish
                                : AppLocalizations.of(context)!.onboarding_next,
                            style: GoogleFonts.montserrat(
                              color: AppColors.whiteSmoke,
                              fontSize: AppFontSizes.medium,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OnboardingInfo {
  final String title;
  final String description;
  final Image image;

  OnboardingInfo({
    required this.title,
    required this.description,
    required this.image,
  });
}

class OnboardingItems {
  final BuildContext context;
  late final List<OnboardingInfo> items;

  OnboardingItems(this.context) {
    items = [
      OnboardingInfo(
        title: AppLocalizations.of(context)!.onboarding_first_title,
        description: AppLocalizations.of(context)!.onboarding_first_description,
        image: Image.asset('assets/images/onboarding_add.png'),
      ),
      OnboardingInfo(
        title: AppLocalizations.of(context)!.onboarding_second_title,
        description:
            AppLocalizations.of(context)!.onboarding_second_description,
        image: Image.asset('assets/images/onboarding_filter.png'),
      ),
      OnboardingInfo(
        title: AppLocalizations.of(context)!.onboarding_third_title,
        description: AppLocalizations.of(context)!.onboarding_third_description,
        image: Image.asset('assets/images/onboarding_view.png'),
      ),
      OnboardingInfo(
        title: AppLocalizations.of(context)!.onboarding_fourth_title,
        description:
            AppLocalizations.of(context)!.onboarding_fourth_description,
        image: Image.asset('assets/images/onboarding_graphs.png'),
      ),
    ];
  }
}
