import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shox/l10n/l10n.dart';
import 'package:shox/common/screens/startup_error_screen.dart';
import 'package:shox/core/routes/app_pages.dart';
import 'package:shox/core/routes/app_routes.dart';
import 'package:shox/core/utils/firebase_options.dart';
import 'package:shox/features/auth/services/auth_guard_service.dart';
import 'package:shox/theme/app_font_sizes.dart';
import 'package:shox/theme/app_theme.dart';
import 'package:shox/theme/theme_controller.dart';

final Logger _logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ThemeController());
  await _bootstrap();
}

bool _isBootstrapping = false;

/// Initializes the services the app depends on and mounts the matching root:
/// the regular app when Firebase is ready, a retryable error screen otherwise.
Future<void> _bootstrap() async {
  if (_isBootstrapping) return;
  _isBootstrapping = true;

  final String? savedLocale = await _loadSavedLocale();
  final bool firebaseReady = await _initFirebase();
  if (firebaseReady && !Get.isRegistered<AuthGuardService>()) {
    Get.put(AuthGuardService(), permanent: true);
  }

  _isBootstrapping = false;
  runApp(MyApp(
    // A different key forces a fresh navigator when switching from the error
    // screen to the regular routes after a successful retry.
    key: ValueKey(firebaseReady),
    savedLocale: savedLocale,
    firebaseReady: firebaseReady,
    onRetry: _bootstrap,
  ));
}

/// The saved language is optional: on failure the device locale is used.
Future<String?> _loadSavedLocale() async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('language_code');
  } catch (e, stackTrace) {
    _logger.e('Unable to read saved locale', error: e, stackTrace: stackTrace);
    return null;
  }
}

Future<bool> _initFirebase() async {
  if (Firebase.apps.isNotEmpty) return true;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    return true;
  } catch (e, stackTrace) {
    _logger.e('Firebase initialization failed',
        error: e, stackTrace: stackTrace);
    return false;
  }
}

class MyApp extends StatelessWidget {
  final String? savedLocale;
  final bool firebaseReady;
  final VoidCallback? onRetry;

  MyApp({
    super.key,
    this.savedLocale,
    this.firebaseReady = true,
    this.onRetry,
  });

  /// Resolved once per app instance: it used to be recomputed on every
  /// rebuild of the theme builder below.
  late final Locale? _initialLocale = _determineLocale();

  Locale? _determineLocale() {
    final saved = L10n.parseLocale(savedLocale);
    if (saved != null) return saved;

    if (savedLocale != null && savedLocale!.trim().isNotEmpty) {
      _logger.w('Unsupported or invalid saved locale: $savedLocale');
    }
    return Get.deviceLocale;
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil scales .w/.h/.r/.sp relative to `designSize`, which is tuned
    // for phones. On tablets (shortest side >= 600dp) this made widgets
    // (e.g. buttons on the login/signup screens) appear oversized because the
    // scale factor grows linearly with screen width. Using the actual screen
    // size as the design size on tablets keeps the original phone-tuned
    // dimensions instead of scaling them up.
    final Size screenSize = MediaQuery.sizeOf(context);
    final bool isTablet = screenSize.shortestSide >= 600;
    final Size designSize = isTablet ? screenSize : const Size(390, 844);

    return ScreenUtilInit(
      designSize: designSize,
      splitScreenMode: true,
      minTextAdapt: true,
      builder: (context, child) => GetX<ThemeController>(
        builder: (controller) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: AppTheme.overlayStyle(isDark: controller.isDark),
            child: GetMaterialApp(
              debugShowCheckedModeBanner: false,
              theme: controller.theme,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              locale: _initialLocale,
              supportedLocales: L10n.all,
              home: firebaseReady ? null : StartupErrorScreen(onRetry: onRetry),
              initialRoute: firebaseReady ? AppRoutes.intro : null,
              getPages: firebaseReady ? AppPages.pages : null,
              // One consistent page transition for every route.
              builder: (context, child) => MediaQuery.withClampedTextScaling(
                maxScaleFactor: AppFontSizes.maxTextScaleFactor,
                child: child!,
              ),
              defaultTransition: Transition.rightToLeftWithFade,
              transitionDuration: const Duration(milliseconds: 300),
            ),
          );
        },
      ),
    );
  }
}
