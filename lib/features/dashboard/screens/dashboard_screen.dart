import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shox/common/widgets/app_bar_widget.dart';
import 'package:shox/common/widgets/changelog_dialog.dart';
import 'package:shox/core/constants/changelog.dart';
import 'package:shox/core/routes/app_routes.dart';
import 'package:shox/core/utils/constants.dart';
import 'package:shox/features/users/controller/user_controller.dart';
import 'package:shox/features/dashboard/widgets/language_dropdown.dart';
import 'package:shox/features/dashboard/widgets/menu_item_widget.dart';
import 'package:shox/features/dashboard/widgets/theme_mode_selector.dart';
import 'package:shox/theme/app_font_sizes.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final Logger _logger = Logger();
  final UserController userController = Get.find<UserController>();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    userController.loadUserProfile(currentUser!.uid);
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() => _appVersion = packageInfo.version);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
          title: AppLocalizations.of(context)!.dashboard_screen_title),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.r),
        child: ListView(
          children: [
            _buildSectionTitle(
                context, AppLocalizations.of(context)!.dashboard_preferences),
            MenuItemWidget(
              icon: MingCuteIcons.mgc_moon_line,
              text: AppLocalizations.of(context)!.dashboard_theme,
              trailing: const SizedBox.shrink(),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.r, right: 8.r, bottom: 8.r),
              child: const ThemeModeSelector(),
            ),
            MenuItemWidget(
              icon: MingCuteIcons.mgc_world_2_line,
              text: AppLocalizations.of(context)!.settings_screen_language,
              trailing: const SizedBox.shrink(),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.r, right: 8.r, bottom: 8.r),
              child: const LanguageDropdown(),
            ),
            _buildSectionTitle(
                context, AppLocalizations.of(context)!.dashboard_account),
            MenuItemWidget(
              icon: MingCuteIcons.mgc_user_3_line,
              text: AppLocalizations.of(context)!.dashboard_profile,
              onTap: () async {
                final result = await Get.toNamed(AppRoutes.user);
                if (result == true) {
                  _logger.i('Reloading user profile after update...');
                  await userController.loadUserProfile(currentUser!.uid);
                  _logger.i(
                      'User profile reloaded. Name: ${userController.userName.value}');
                }
              },
            ),
            MenuItemWidget(
              icon: MingCuteIcons.mgc_chart_pie_2_line,
              text: AppLocalizations.of(context)!.user_screen_button_database,
              onTap: () {
                Get.toNamed(AppRoutes.database);
              },
            ),
            MenuItemWidget(
              icon: MingCuteIcons.mgc_exit_line,
              text: AppLocalizations.of(context)!.dashboard_logout,
              onTap: () {
                userController.logout(context);
              },
            ),
            _buildSectionTitle(
                context, AppLocalizations.of(context)!.dashboard_information),
            MenuItemWidget(
              icon: MingCuteIcons.mgc_information_line,
              text: AppLocalizations.of(context)!.settings_screen_info,
              onTap: () {
                Get.toNamed(AppRoutes.info);
              },
            ),
            MenuItemWidget(
              icon: MingCuteIcons.mgc_safe_lock_line,
              text: AppLocalizations.of(context)!.settings_screen_policy,
              onTap: () {
                Get.toNamed(AppRoutes.privacyPolicy);
              },
            ),
            MenuItemWidget(
              icon: MingCuteIcons.mgc_send_line,
              text: AppLocalizations.of(context)!.settings_screen_support,
              onTap: () {
                Get.toNamed(AppRoutes.support);
              },
            ),
            MenuItemWidget(
              icon: MingCuteIcons.mgc_notification_line,
              text: AppLocalizations.of(context)!.dashboard_changelog,
              onTap: () {
                showDialog<void>(
                  context: context,
                  builder: (context) =>
                      ChangelogDialog(entries: changelogEntries),
                );
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
            MenuItemWidget(
              icon: MingCuteIcons.mgc_information_line,
              text: AppLocalizations.of(context)!.dashboard_version,
              trailing: Text(
                'v $_appVersion',
                style: TextStyle(
                  fontFamily: 'CustomFont',
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: AppFontSizes.small,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'CustomFontBold',
          color: Theme.of(context).colorScheme.tertiary,
          fontSize: AppFontSizes.small,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
