import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shox/common/screens/onboarding_screen.dart';
import 'package:shox/common/screens/welcome_screen.dart';
import 'package:shox/common/widgets/logo_widget.dart';
import 'package:shox/screens/home/screens/home_screen.dart';
import 'package:shox/theme/app_font_sizes.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  IntroScreenState createState() => IntroScreenState();
}

class IntroScreenState extends State<IntroScreen>
    with SingleTickerProviderStateMixin {
  late final Logger _logger;
  late final FirebaseFirestore _firestore;

  @override
  void initState() {
    super.initState();
    _logger = Logger();
    _firestore = FirebaseFirestore.instance;
    _startSplashScreen();
  }

  Future<void> _startSplashScreen() async {
    await Future.delayed(const Duration(milliseconds: 800));
    _checkRememberMe();
  }

  Future<void> _loadUserData(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) throw Exception("User data not found");
      // Carica dati utente in memoria/app
    } catch (e) {
      _logger.e("Failed to load user data: $e");
      Get.snackbar('Errore', 'Impossibile caricare i dati utente',
          snackPosition: SnackPosition.BOTTOM);
      rethrow;
    }
  }

  Future<void> _checkRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;
    final rememberMe = prefs.getBool('remember_me') ?? false;
    final userId = prefs.getString('user_id');
    _logger.i('onboarding_completed: $onboardingCompleted');
    _logger.i('remember_me: $rememberMe');
    _logger.i('user_id: $userId');

    if (!onboardingCompleted) {
      _logger.i('Navigo a OnboardingScreen');
      Get.off(
        () => const OnboardingScreen(),
        transition: Transition.fade,
        duration: const Duration(milliseconds: 500),
      );
      return;
    }
    if (rememberMe) {
      if (userId != null) {
        try {
          await _loadUserData(userId);
          _logger.i('Navigo a HomeScreen (rememberMe attivo)');
          Get.off(
            () => const HomeScreen(),
            transition: Transition.fade,
            duration: const Duration(milliseconds: 500),
          );
        } catch (e) {
          _logger.e('Errore nel caricamento utente, navigo a WelcomeScreen');
          Get.off(
            () => const WelcomeScreen(),
            transition: Transition.fade,
            duration: const Duration(milliseconds: 500),
          );
        }
        return;
      } else {
        _logger.i('user_id non trovato, navigo a WelcomeScreen');
      }
    } else {
      _logger.i('rememberMe non attivo, navigo a WelcomeScreen');
    }
    Get.off(
      () => const WelcomeScreen(),
      transition: Transition.fade,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LogoWidget(
              width: 200.w,
              height: 200.h,
              semanticLabel: 'Intro Logo',
            ),
            SizedBox(height: 24.h),
            Text(
              AppLocalizations.of(context)!.intro_title,
              style: GoogleFonts.montserrat(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: AppFontSizes.titanic,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
