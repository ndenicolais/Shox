import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shox/firebase_options.dart';
import 'package:shox/pages/intro_page.dart';
import 'package:shox/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme(),
      home: const IntroPage(),
    );
  }
}
