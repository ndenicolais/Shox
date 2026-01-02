import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shox/l10n/l10n.dart';
import 'package:shox/core/utils/firebase_options.dart';
import 'package:shox/common/screens/intro_screen.dart';
import 'package:shox/theme/theme_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<Map<String, dynamic>> loadConfig() async {
  final configString = await rootBundle.loadString('config.json');
  return json.decode(configString);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ThemeController());
  final config = await loadConfig();

  await Supabase.initialize(
    url: config['supabaseUrl'],
    anonKey: config['supabaseAnonKey'],
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? savedLocale = prefs.getString('language_code');
  runApp(MyApp(savedLocale: savedLocale));
}

class MyApp extends StatelessWidget {
  final String? savedLocale;

  const MyApp({super.key, this.savedLocale});

  Locale? _determineLocale() {
    if (savedLocale != null && savedLocale!.isNotEmpty) {
      try {
        return Locale(savedLocale!);
      } catch (e) {
        debugPrint('Invalid locale format: $savedLocale');
      }
    }
    return Get.deviceLocale;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            return ScreenUtilInit(
              designSize: Size(constraints.maxWidth, constraints.maxHeight),
              splitScreenMode: true,
              minTextAdapt: true,
              builder: (context, child) => GetX<ThemeController>(
                builder: (controller) {
                  Locale? initialLocale = _determineLocale();
                  return GetMaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: controller.theme,
                    localizationsDelegates: const [
                      AppLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    locale: initialLocale,
                    supportedLocales: L10n.all,
                    home: const IntroScreen(),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
