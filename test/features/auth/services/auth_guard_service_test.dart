import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shox/core/routes/app_routes.dart';
import 'package:shox/features/auth/services/auth_guard_service.dart';
import 'package:shox/features/auth/services/auth_service.dart';
import 'package:shox/l10n/app_localizations.dart';

class MockAuth extends Mock implements FirebaseAuth {}

class MockAuthService extends Mock implements AuthService {}

class MockUser extends Mock implements User {}

void main() {
  late StreamController<User?> authEvents;
  late MockAuthService authService;
  late AuthGuardService guard;

  setUp(() {
    authEvents = StreamController<User?>.broadcast();
    final auth = MockAuth();
    when(() => auth.authStateChanges()).thenAnswer((_) => authEvents.stream);
    authService = MockAuthService();
    when(() => authService.clearSession()).thenAnswer((_) async {});
    guard = Get.put(AuthGuardService(auth: auth, authService: authService));
  });

  tearDown(() async {
    await authEvents.close();
    Get.reset();
  });

  /// App with a protected home and a public welcome page, started on
  /// [initialRoute] with a signed-in user.
  Future<void> pumpApp(WidgetTester tester, String initialRoute) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, __) => GetMaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          initialRoute: initialRoute,
          getPages: [
            GetPage(name: AppRoutes.home, page: () => const Text('home')),
            GetPage(name: AppRoutes.welcome, page: () => const Text('welcome')),
          ],
        ),
      ),
    );
    authEvents.add(MockUser());
    await tester.pumpAndSettle();
  }

  /// Emits a sign-out and lets navigation and the toast timer complete.
  Future<void> signOut(WidgetTester tester) async {
    authEvents.add(null);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 2));
  }

  testWidgets('unexpected sign-out on a protected route goes to welcome',
      (tester) async {
    await pumpApp(tester, AppRoutes.home);

    authEvents.add(null);
    await tester.pumpAndSettle();

    expect(Get.currentRoute, AppRoutes.welcome);
    expect(
      find.text('Your session has expired. Please sign in again.'),
      findsOneWidget,
    );
    verify(() => authService.clearSession()).called(1);
    await tester.pump(const Duration(seconds: 2));
  });

  testWidgets('an intentional sign-out is not treated as expired session',
      (tester) async {
    await pumpApp(tester, AppRoutes.home);

    guard.expectSignOut();
    await signOut(tester);

    expect(Get.currentRoute, AppRoutes.home);
    verifyNever(() => authService.clearSession());
  });

  testWidgets('a sign-out on a public route does not navigate', (tester) async {
    await pumpApp(tester, AppRoutes.welcome);

    await signOut(tester);

    expect(Get.currentRoute, AppRoutes.welcome);
    verifyNever(() => authService.clearSession());
  });

  testWidgets('no redirect before a user was ever signed in', (tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, __) => GetMaterialApp(
          initialRoute: AppRoutes.home,
          getPages: [
            GetPage(name: AppRoutes.home, page: () => const Text('home')),
            GetPage(name: AppRoutes.welcome, page: () => const Text('welcome')),
          ],
        ),
      ),
    );

    await signOut(tester);

    expect(Get.currentRoute, AppRoutes.home);
  });
}
