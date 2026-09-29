import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shox/l10n/l10n.dart';
import 'package:shox/core/routes/app_pages.dart';
import 'package:shox/core/routes/app_routes.dart';
import 'package:shox/core/utils/firebase_options.dart';
import 'package:shox/theme/theme_controller.dart';

final Logger _logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ThemeController());

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? savedLocale = prefs.getString('language_code');
  runApp(MyApp(savedLocale: savedLocale));
}

class MyApp extends StatelessWidget {
  final String? savedLocale;

  MyApp({super.key, this.savedLocale});

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
          return GetMaterialApp(
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
            initialRoute: AppRoutes.intro,
            getPages: AppPages.pages,
          );
        },
      ),
    );
  }
}
