import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shox/core/routes/app_routes.dart';

/// Redirects to the welcome screen when a protected route is opened without
/// an authenticated Firebase user, instead of letting the screen crash on
/// `currentUser!`.
class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (FirebaseAuth.instance.currentUser != null) return null;
    return const RouteSettings(name: AppRoutes.welcome);
  }
}
