import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shox/common/widgets/app_bar_widget.dart';
import 'package:shox/core/utils/constants.dart';
import 'package:shox/features/users/controller/user_controller.dart';
import 'package:shox/screens/dashboard/screens/support_screen.dart';
import 'package:shox/screens/dashboard/screens/info_screen.dart';
import 'package:shox/screens/dashboard/screens/privacy_policy_screen.dart';
import 'package:shox/screens/dashboard/widgets/language_dropdown.dart';
import 'package:shox/screens/dashboard/widgets/menu_item_widget.dart';
import 'package:shox/screens/database/screens/database_screen.dart';
import 'package:shox/screens/users/screens/user_delete_screen.dart';
import 'package:shox/screens/users/screens/user_screen.dart';
import 'package:shox/theme/app_font_sizes.dart';
import 'package:shox/theme/theme_controller.dart';

class DashboardScreen extends StatefulWidget {
  final String userId;

  const DashboardScreen({super.key, required this.userId});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final Logger _logger = Logger();
  final UserController userController = Get.put(UserController());
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    userController.loadUserProfile(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
          title: AppLocalizations.of(context)!.dashboard_screen_title),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.r),
              child: ListView(
                children: [
                  _buildSectionTitle(context,
                      AppLocalizations.of(context)!.dashboard_preferences),
                  MenuItemWidget(
                    icon: MingCuteIcons.mgc_moon_line,
                    text: AppLocalizations.of(context)!.dashboard_dark_mode,
                    switchValue: Get.find<ThemeController>().isDark,
                    onChanged: (val) {
                      Get.find<ThemeController>().switchTheme();
                    },
                  ),
                  MenuItemWidget(
                    icon: MingCuteIcons.mgc_world_2_line,
                    text:
                        AppLocalizations.of(context)!.settings_screen_language,
                    trailing: const LanguageDropdown(),
                  ),
                  _buildSectionTitle(
                      context, AppLocalizations.of(context)!.dashboard_account),
                  MenuItemWidget(
                    icon: MingCuteIcons.mgc_user_3_line,
                    text: AppLocalizations.of(context)!.dashboard_profile,
                    onTap: () async {
                      final result = await Get.to(
                        () => UserScreen(userId: currentUser!.uid),
                        transition: Transition.fade,
                        duration: const Duration(milliseconds: 500),
                      );
                      if (result == true) {
                        _logger.i('Reloading user profile after update...');
                        await userController.loadUserProfile(widget.userId);
                        _logger.i(
                            'User profile reloaded. Name: ${userController.userName.value}');
                      }
                    },
                  ),
                  MenuItemWidget(
                    icon: MingCuteIcons.mgc_chart_pie_2_line,
                    text: AppLocalizations.of(context)!
                        .user_screen_button_database,
                    onTap: () {
                      Get.to(() => const DatabaseScreen(),
                          transition: Transition.fade,
                          duration: const Duration(milliseconds: 500));
                    },
                  ),
                  MenuItemWidget(
                    icon: MingCuteIcons.mgc_delete_2_line,
                    text:
                        AppLocalizations.of(context)!.user_screen_button_delete,
                    onTap: () {
                      Get.to(() => const UserDeleteScreen(),
                          transition: Transition.fade,
                          duration: const Duration(milliseconds: 500));
                    },
                  ),
                  MenuItemWidget(
                    icon: MingCuteIcons.mgc_exit_line,
                    text: AppLocalizations.of(context)!.dashboard_logout,
                    onTap: () {
                      userController.logout(context);
                    },
                  ),
                  _buildSectionTitle(context,
                      AppLocalizations.of(context)!.dashboard_information),
                  MenuItemWidget(
                    icon: MingCuteIcons.mgc_information_line,
                    text: AppLocalizations.of(context)!.settings_screen_info,
                    onTap: () {
                      Get.to(() => const InfoScreen(),
                          transition: Transition.fade,
                          duration: const Duration(milliseconds: 500));
                    },
                  ),
                  MenuItemWidget(
                    icon: MingCuteIcons.mgc_safe_lock_line,
                    text: AppLocalizations.of(context)!.settings_screen_policy,
                    onTap: () {
                      Get.to(() => const PrivacyPolicyScreen(),
                          transition: Transition.fade,
                          duration: const Duration(milliseconds: 500));
                    },
                  ),
                  MenuItemWidget(
                    icon: MingCuteIcons.mgc_send_line,
                    text: AppLocalizations.of(context)!.settings_screen_support,
                    onTap: () {
                      Get.to(() => const SupportScreen(),
                          transition: Transition.fade,
                          duration: const Duration(milliseconds: 500));
                    },
                  ),
                  MenuItemWidget(
                    icon: MingCuteIcons.mgc_share_2_line,
                    text: AppLocalizations.of(context)!.dashboard_share_app,
                    onTap: () {
                      Share.share(AppConstants.uriGithubLink.toString());
                    },
                    trailing: const SizedBox.shrink(),
                  ),
                  FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      final version = snapshot.data?.version ?? '';
                      return MenuItemWidget(
                        icon: MingCuteIcons.mgc_information_line,
                        text: AppLocalizations.of(context)!.dashboard_version,
                        trailing: Text(
                          'v $version',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: AppFontSizes.small,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.h),
      child: Text(
        title,
        style: GoogleFonts.montserrat(
          color: Theme.of(context).colorScheme.tertiary,
          fontSize: AppFontSizes.small,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
