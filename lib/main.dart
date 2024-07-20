import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shox/firebase_options.dart';
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
    return Consumer<ThemeNotifier>(
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
        );
      },
    );
  }
}
