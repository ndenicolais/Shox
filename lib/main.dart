import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shox/firebase_options.dart';
import 'package:shox/generated/l10n.dart';
import 'package:shox/pages/intro_page.dart';
import 'package:shox/theme/app_theme.dart';
import 'package:shox/theme/theme_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(AppTheme.lightTheme(), false),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      splitScreenMode: true,
      minTextAdapt: true,
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          final brightness = MediaQuery.of(context).platformBrightness;

          if (!themeNotifier.isManualTheme) {
            if (brightness == Brightness.dark && !themeNotifier.isDarkMode) {
              themeNotifier.setDarkTheme();
            } else if (brightness == Brightness.light &&
                themeNotifier.isDarkMode) {
              themeNotifier.setLightTheme();
            }
            themeNotifier.resetManualTheme();
          }

          return GetMaterialApp(
            theme: themeNotifier.currentTheme,
            home: const IntroPage(),
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            locale: Get.deviceLocale,
          );
        },
      ),
    );
  }
}
