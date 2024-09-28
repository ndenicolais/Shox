import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shox/utils/firebase_options.dart';
import 'package:shox/generated/l10n.dart';
import 'package:shox/pages/intro_page.dart';
import 'package:shox/theme/theme_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? savedLocale = prefs.getString('language_code');
  ThemeNotifier themeNotifier = await ThemeNotifier.loadThemeFromPreferences();

  runApp(
    ChangeNotifierProvider(
      create: (_) => themeNotifier,
      child: MyApp(savedLocale: savedLocale),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String? savedLocale;

  const MyApp({super.key, this.savedLocale});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      splitScreenMode: true,
      minTextAdapt: true,
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          Locale? initialLocale;

          if (savedLocale != null && savedLocale!.isNotEmpty) {
            initialLocale = Locale(savedLocale!);
          } else {
            initialLocale = Get.deviceLocale;
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
            locale: initialLocale,
          );
        },
      ),
    );
  }
}
