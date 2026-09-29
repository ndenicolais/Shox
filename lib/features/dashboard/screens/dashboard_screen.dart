import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:shox/theme/app_spacing.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shox/common/widgets/app_bar_widget.dart';
import 'package:shox/common/widgets/responsive_center_widget.dart';
import 'package:shox/common/widgets/changelog_dialog_widget.dart';
import 'package:shox/core/constants/changelog.dart';
import 'package:shox/core/routes/app_routes.dart';
import 'package:shox/core/utils/constants.dart';
import 'package:shox/features/users/controller/user_controller.dart';
import 'package:shox/features/dashboard/widgets/language_dropdown.dart';
import 'package:shox/features/dashboard/widgets/dashboard_menu_item.dart';
import 'package:shox/features/dashboard/widgets/theme_mode_selector.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBarWidget(title: l10n.dashboard_screen_title),
      body: SafeArea(
        child: ResponsiveCenterWidget(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.l,
              AppSpacing.xs,
              AppSpacing.l,
              AppSpacing.xl,
            ),
            children: [
              _buildSection(context, l10n.dashboard_preferences, [
                _buildSetting(
                  context,
                  icon: MingCuteIcons.mgc_moon_line,
                  label: l10n.dashboard_theme,
                  control: const ThemeModeSelector(),
                ),
                _buildSetting(
                  context,
                  icon: MingCuteIcons.mgc_world_2_line,
                  label: l10n.settings_screen_language,
                  control: const LanguageDropdown(),
                ),
              ]),
              _buildSection(context, l10n.dashboard_account, [
                DashboardMenuItem(
                  icon: MingCuteIcons.mgc_user_3_line,
                  text: l10n.dashboard_profile,
                  onTap: () async {
                    final result = await Get.toNamed(AppRoutes.user);
                    if (result == true) {
                      _logger.i('Reloading user profile after update...');
                      await userController.loadUserProfile(currentUser!.uid);
                      _logger.i(
                        'User profile reloaded. Name: ${userController.userName.value}',
                      );
                    }
                  },
                ),
                DashboardMenuItem(
                  icon: MingCuteIcons.mgc_chart_pie_2_line,
                  text: l10n.user_screen_button_database,
                  onTap: () => Get.toNamed(AppRoutes.database),
                ),
                DashboardMenuItem(
                  icon: MingCuteIcons.mgc_exit_line,
                  text: l10n.dashboard_logout,
                  onTap: () => userController.logout(context),
                ),
              ]),
              _buildSection(context, l10n.dashboard_information, [
                DashboardMenuItem(
                  icon: MingCuteIcons.mgc_information_line,
                  text: l10n.settings_screen_info,
                  onTap: () => Get.toNamed(AppRoutes.info),
                ),
                DashboardMenuItem(
                  icon: MingCuteIcons.mgc_safe_lock_line,
                  text: l10n.settings_screen_policy,
                  onTap: () => Get.toNamed(AppRoutes.privacyPolicy),
                ),
                DashboardMenuItem(
                  icon: MingCuteIcons.mgc_send_line,
                  text: l10n.settings_screen_support,
                  onTap: () => Get.toNamed(AppRoutes.support),
                ),
                DashboardMenuItem(
                  icon: MingCuteIcons.mgc_notification_line,
                  text: l10n.dashboard_changelog,
                  onTap: () => showDialog<void>(
                    context: context,
                    builder: (context) =>
                        ChangelogDialogWidget(entries: changelogEntries),
                  ),
                ),
                DashboardMenuItem(
                  icon: MingCuteIcons.mgc_share_2_line,
                  text: l10n.dashboard_share_app,
                  onTap: () =>
                      Share.share(AppConstants.uriGithubLink.toString()),
                  trailing: const SizedBox.shrink(),
                ),
                DashboardMenuItem(
                  icon: MingCuteIcons.mgc_code_line,
                  text: l10n.dashboard_version,
                  trailing: Text('v $_appVersion', style: textTheme.bodySmall),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  /// Uppercase section label followed by a card grouping its rows.
  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.xxs,
              bottom: AppSpacing.xs,
            ),
            child: Text(
              title.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (var i = 0; i < children.length; i++) ...[
                  if (i > 0)
                    const Divider(
                      height: 1,
                      indent: AppSpacing.m + 36 + AppSpacing.m,
                    ),
                  children[i],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Preference row with its control (segmented selector) underneath.
  Widget _buildSetting(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Widget control,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DashboardMenuItem(icon: icon, text: label),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
            child: control,
          ),
        ],
      ),
    );
  }
}
