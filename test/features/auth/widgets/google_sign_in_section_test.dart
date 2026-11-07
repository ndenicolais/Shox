import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shox/core/routes/app_routes.dart';
import 'package:shox/features/auth/widgets/google_sign_in_section.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:shox/theme/app_font_sizes.dart';
import 'package:shox/theme/app_theme.dart';

Future<void> _pump(WidgetTester tester, {required Locale locale}) async {
  // Narrow phone at the largest text size the app allows.
  tester.view.physicalSize = const Size(320, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, __) => GetMaterialApp(
        theme: AppTheme.lightTheme(),
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler:
                const TextScaler.linear(AppFontSizes.maxTextScaleFactor),
          ),
          child: child!,
        ),
        getPages: [
          GetPage(
            name: AppRoutes.privacyPolicy,
            page: () => const Scaffold(body: Text('privacy page')),
          ),
        ],
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: GoogleSignInSection(onPressed: () {}),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  tearDown(Get.reset);

  testWidgets('shows the age and privacy notice without overflow',
      (tester) async {
    await _pump(tester, locale: const Locale('de'));

    final l10n = AppLocalizations.of(
      tester.element(find.byType(GoogleSignInSection)),
    )!;
    expect(find.text(l10n.auth_privacy_notice), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the privacy button opens the privacy policy', (tester) async {
    await _pump(tester, locale: const Locale('en'));

    final l10n = AppLocalizations.of(
      tester.element(find.byType(GoogleSignInSection)),
    )!;
    await tester.tap(find.text(l10n.settings_screen_policy));
    await tester.pumpAndSettle();

    expect(find.text('privacy page'), findsOneWidget);
  });
}
