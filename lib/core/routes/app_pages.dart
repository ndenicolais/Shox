import 'package:get/get.dart';
import 'package:shox/common/screens/intro_screen.dart';
import 'package:shox/common/screens/onboarding_screen.dart';
import 'package:shox/common/screens/welcome_screen.dart';
import 'package:shox/core/routes/app_routes.dart';
import 'package:shox/core/routes/auth_middleware.dart';
import 'package:shox/features/auth/gender_selection/bindings/gender_selection_binding.dart';
import 'package:shox/features/auth/gender_selection/screens/gender_selection_screen.dart';
import 'package:shox/features/auth/login/bindings/login_binding.dart';
import 'package:shox/features/auth/login/screens/login_screen.dart';
import 'package:shox/features/auth/reset_password/bindings/reset_password_binding.dart';
import 'package:shox/features/auth/reset_password/screens/reset_password_screen.dart';
import 'package:shox/features/auth/signup/bindings/signup_binding.dart';
import 'package:shox/features/auth/signup/screens/signup_screen.dart';
import 'package:shox/features/dashboard/bindings/dashboard_binding.dart';
import 'package:shox/features/dashboard/screens/dashboard_screen.dart';
import 'package:shox/features/dashboard/screens/info_screen.dart';
import 'package:shox/features/dashboard/screens/privacy_policy_screen.dart';
import 'package:shox/features/dashboard/screens/support_screen.dart';
import 'package:shox/features/database/bindings/database_binding.dart';
import 'package:shox/features/database/screens/database_screen.dart';
import 'package:shox/features/home/bindings/home_binding.dart';
import 'package:shox/features/home/screens/home_screen.dart';
import 'package:shox/features/shoes/bindings/shoes_binding.dart';
import 'package:shox/features/shoes/screens/shoes_adder_screen.dart';
import 'package:shox/features/shoes/screens/shoes_details_screen.dart';
import 'package:shox/features/shoes/screens/shoes_updater_screen.dart';
import 'package:shox/features/users/bindings/user_binding.dart';
import 'package:shox/features/users/screens/user_delete_screen.dart';
import 'package:shox/features/users/screens/user_screen.dart';
import 'package:shox/features/users/screens/user_update_screen.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.intro,
      page: () => const IntroScreen(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
    ),
    GetPage(
      name: AppRoutes.welcome,
      page: () => const WelcomeScreen(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupScreen(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: AppRoutes.resetPassword,
      page: () => const ResetPasswordScreen(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: AppRoutes.genderSelection,
      page: () => const GenderSelectionScreen(),
      binding: GenderSelectionBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.shoesAdder,
      page: () => const ShoesAdderScreen(),
      binding: ShoesBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.shoesDetails,
      page: () => const ShoesDetailsScreen(),
      binding: ShoesBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.shoesUpdater,
      page: () => const ShoesUpdaterScreen(),
      binding: ShoesBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.database,
      page: () => const DatabaseScreen(),
      binding: DatabaseBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.info,
      page: () => const InfoScreen(),
    ),
    GetPage(
      name: AppRoutes.privacyPolicy,
      page: () => const PrivacyPolicyScreen(),
    ),
    GetPage(
      name: AppRoutes.support,
      page: () => const SupportScreen(),
    ),
    GetPage(
      name: AppRoutes.user,
      page: () => const UserScreen(),
      binding: UserBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.userUpdate,
      page: () => const UserUpdateScreen(),
      binding: UserBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.userDelete,
      page: () => const UserDeleteScreen(),
      binding: UserBinding(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
