import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shox/common/widgets/logo_widget.dart';
import 'package:shox/common/widgets/toast_widget.dart';
import 'package:shox/core/routes/app_routes.dart';
import 'package:shox/core/services/onboarding_store.dart';
import 'package:shox/core/utils/constants.dart';
import 'package:shox/features/auth/services/auth_service.dart';
import 'package:shox/theme/app_spacing.dart';

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
      if (mounted) {
        showErrorToast(
          context,
          AppLocalizations.of(context)!.intro_screen_load_data_error,
        );
      }
      rethrow;
    }
  }

  /// Startup rule: signed-in user → Home; otherwise the introduction on the
  /// first launch, the welcome screen afterwards. Checking the session first
  /// keeps users who update the app from seeing the introduction.
  Future<void> _checkRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool(AppConstants.prefsRememberMe) ?? false;
    final userId = prefs.getString(AppConstants.prefsUserId);
    _logger.i('remember_me: $rememberMe, user_id: $userId');

    if (rememberMe) {
      // Firebase restores the signed-in user asynchronously: wait for the
      // first auth event instead of reading `currentUser` right away.
      final firebaseUser = await FirebaseAuth.instance.authStateChanges().first;
      if (firebaseUser == null) {
        _logger.w('Firebase session expired');
        await AuthService().clearSession();
      } else if (userId != null) {
        try {
          await _loadUserData(userId);
          Get.offNamed(AppRoutes.home);
        } catch (e) {
          _logger.e('Unable to load the user, going to the welcome screen');
          Get.offNamed(AppRoutes.welcome);
        }
        return;
      }
    }
    Get.offNamed(
      Get.find<OnboardingStore>().seen
          ? AppRoutes.welcome
          : AppRoutes.onboarding,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const LogoWidget(
              width: 160,
              height: 160,
              semanticLabel: 'Intro Logo',
            ),
            const SizedBox(height: AppSpacing.l),
            Text(l10n.intro_title, style: textTheme.displaySmall),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              l10n.intro_tagline,
              style: textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
