import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shox/common/widgets/toast_widget.dart';
import 'package:shox/core/routes/app_routes.dart';
import 'package:shox/features/auth/services/auth_service.dart';
import 'package:shox/l10n/app_localizations.dart';

/// Watches the Firebase auth state for the whole app lifetime and sends the
/// user back to the welcome screen when the session is lost unexpectedly
/// (token revoked, account disabled, password changed on another device...).
class AuthGuardService extends GetxService {
  static AuthGuardService get to => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();
  final Logger _logger = Logger();
  StreamSubscription<User?>? _subscription;
  bool _signedIn = false;
  bool _signOutExpected = false;

  /// Routes reachable without an authenticated user.
  static const Set<String> publicRoutes = {
    AppRoutes.intro,
    AppRoutes.onboarding,
    AppRoutes.welcome,
    AppRoutes.login,
    AppRoutes.signup,
    AppRoutes.resetPassword,
    AppRoutes.info,
    AppRoutes.privacyPolicy,
    AppRoutes.support,
  };

  @override
  void onInit() {
    super.onInit();
    _subscription = _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  /// Call before an intentional sign-out (logout, account deletion) so that
  /// the resulting auth event is not treated as an expired session.
  void expectSignOut() => _signOutExpected = true;

  void _onAuthStateChanged(User? user) {
    if (user != null) {
      _signedIn = true;
      _signOutExpected = false;
      return;
    }
    if (!_signedIn) return;
    _signedIn = false;

    if (_signOutExpected) {
      _signOutExpected = false;
      return;
    }
    if (publicRoutes.contains(Get.currentRoute)) return;

    _logger.w('Session lost on ${Get.currentRoute}: redirecting to welcome');
    _authService.clearSession();
    Get.offAllNamed(AppRoutes.welcome);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = Get.overlayContext;
      if (context != null && context.mounted) {
        showErrorToast(
          context,
          AppLocalizations.of(context)!.session_expired_message,
        );
      }
    });
  }
}
