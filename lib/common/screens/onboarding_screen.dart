import 'package:flutter/material.dart';
import 'package:shox/theme/app_spacing.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shox/core/routes/app_routes.dart';
import 'package:shox/common/widgets/responsive_center_widget.dart';
import 'package:shox/core/utils/constants.dart';
import 'package:shox/theme/app_radius.dart';

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
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
      _finish();
    }
  }

  Future<void> _checkRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool rememberMe = prefs.getBool(AppConstants.prefsRememberMe) ?? false;

    if (rememberMe) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.welcome);
    }
  }

  /// Marks the onboarding as seen and leaves it (finish or skip).
  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    await _checkRememberMe();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final bool isLast = _currentIndex == _pages.length - 1;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: ResponsiveCenterWidget(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.xs,
                AppSpacing.xl,
                AppSpacing.xl,
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: AnimatedOpacity(
                      opacity: isLast ? 0 : 1,
                      duration: const Duration(milliseconds: 200),
                      child: TextButton(
                        onPressed: isLast ? null : _finish,
                        child: Text(l10n.onboarding_skip),
                      ),
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _pages.length,
                      onPageChanged: (i) => setState(() => _currentIndex = i),
                      itemBuilder: (context, index) {
                        final item = _pages[index];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Container(
                                  padding: const EdgeInsets.all(AppSpacing.xl),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.tertiaryFixed,
                                    borderRadius:
                                        BorderRadius.circular(AppRadius.hero),
                                  ),
                                  child: item.image,
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            Text(
                              item.title,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.headlineMedium,
                            ),
                            const SizedBox(height: AppSpacing.s),
                            Text(
                              item.description,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: List.generate(
                            _pages.length,
                            (i) => AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(
                                right: AppSpacing.xs,
                              ),
                              width: _currentIndex == i ? 24 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _currentIndex == i
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.outline,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.pill),
                              ),
                            ),
                          ),
                        ),
                      ),
                      FilledButton(
                        onPressed: isLast ? _finish : _nextPage,
                        child: Text(
                          isLast
                              ? l10n.onboarding_finish
                              : l10n.onboarding_next,
                        ),
                      ),
                    ],
                  ),
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
        description: AppLocalizations.of(
          context,
        )!
            .onboarding_second_description,
        image: Image.asset('assets/images/onboarding_filter.png'),
      ),
      OnboardingInfo(
        title: AppLocalizations.of(context)!.onboarding_third_title,
        description: AppLocalizations.of(context)!.onboarding_third_description,
        image: Image.asset('assets/images/onboarding_view.png'),
      ),
      OnboardingInfo(
        title: AppLocalizations.of(context)!.onboarding_fourth_title,
        description: AppLocalizations.of(
          context,
        )!
            .onboarding_fourth_description,
        image: Image.asset('assets/images/onboarding_graphs.png'),
      ),
    ];
  }
}
