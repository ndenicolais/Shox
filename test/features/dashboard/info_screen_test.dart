import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shox/core/utils/constants.dart';
import 'package:shox/features/dashboard/screens/info_screen.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:shox/theme/app_theme.dart';

Future<void> _pump(
  WidgetTester tester, {
  Size size = const Size(400, 1600),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, __) => MaterialApp(
        theme: AppTheme.lightTheme(),
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const InfoScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    PackageInfo.setMockInitialValues(
      appName: 'Shox',
      packageName: 'com.ndn21.shox',
      version: '9.9.9',
      buildNumber: '1',
      buildSignature: '',
    );
  });

  testWidgets('shows identity, version, links and credits', (tester) async {
    await _pump(tester);

    expect(find.text('Version 9.9.9'), findsOneWidget);
    expect(find.text('Source code'), findsOneWidget);
    expect(find.text('Open source licenses'), findsOneWidget);
    expect(
      find.text('Designed and developed by ${AppConstants.developerName}'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('lays out without overflow on a narrow phone', (tester) async {
    await _pump(tester, size: const Size(320, 2000));
    expect(tester.takeException(), isNull);
  });

  testWidgets('opens the open source licenses page', (tester) async {
    await _pump(tester);
    await tester.tap(find.text('Open source licenses'));
    await tester.pumpAndSettle();
    expect(find.byType(LicensePage), findsOneWidget);
  });
}
