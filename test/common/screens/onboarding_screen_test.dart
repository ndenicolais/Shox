import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shox/common/screens/onboarding_screen.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:shox/theme/app_theme.dart';

Future<void> _pump(
  WidgetTester tester,
  Widget home, {
  bool disableAnimations = false,
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.lightTheme(),
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          disableAnimations: disableAnimations,
        ),
        child: child!,
      ),
      home: home,
    ),
  );
  await tester.pumpAndSettle();
}

AppLocalizations _l10n(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(OnboardingScreen)))!;

void main() {
  testWidgets('skip calls onFinish on the first launch', (tester) async {
    var finished = 0;
    await _pump(tester, OnboardingScreen(onFinish: () => finished++));

    await tester.tap(find.text(_l10n(tester).onboarding_skip));
    await tester.pumpAndSettle();

    expect(finished, 1);
  });

  testWidgets('next walks the pages and the last one calls onFinish',
      (tester) async {
    var finished = 0;
    await _pump(tester, OnboardingScreen(onFinish: () => finished++));
    final l10n = _l10n(tester);

    for (var i = 0; i < 3; i++) {
      await tester.tap(find.text(l10n.onboarding_next));
      await tester.pumpAndSettle();
    }
    expect(finished, 0);
    expect(find.text(l10n.onboarding_finish), findsOneWidget);

    await tester.tap(find.text(l10n.onboarding_finish));
    await tester.pumpAndSettle();
    expect(finished, 1);
  });

  testWidgets('jumps between pages when animations are disabled',
      (tester) async {
    await _pump(
      tester,
      OnboardingScreen(onFinish: () {}),
      disableAnimations: true,
    );
    final l10n = _l10n(tester);

    await tester.tap(find.text(l10n.onboarding_next));
    // A jump lands on the next page in a single frame, with no animation.
    await tester.pump();

    final pageView = tester.widget<PageView>(find.byType(PageView));
    expect(pageView.controller!.page, 1.0);
  });

  testWidgets('a replay without onFinish closes the screen', (tester) async {
    await _pump(
      tester,
      Builder(
        builder: (context) => TextButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const OnboardingScreen()),
          ),
          child: const Text('open'),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.byType(OnboardingScreen), findsOneWidget);

    await tester.tap(find.text(_l10n(tester).onboarding_skip));
    await tester.pumpAndSettle();
    expect(find.byType(OnboardingScreen), findsNothing);
  });
}
