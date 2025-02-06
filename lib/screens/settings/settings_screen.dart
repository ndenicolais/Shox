import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/generated/l10n.dart';
import 'package:shox/screens/settings/languages_screen.dart';
import 'package:shox/screens/settings/support_screen.dart';
import 'package:shox/screens/settings/info_screen.dart';
import 'package:shox/screens/settings/policy_screen.dart';
import 'package:shox/screens/settings/themes_screen.dart';
import 'package:shox/widgets/custom_section_button.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(30.r),
          child: Center(
            child: Column(
              children: [
                _buildTopImage(context),
                SizedBox(height: 80.h),
                _buildThemeButton(context),
                SizedBox(height: 20.h),
                _buildLanguageButton(context),
                SizedBox(height: 20.h),
                _buildInfoButton(context),
                SizedBox(height: 20.h),
                _buildPolicyButton(context),
                SizedBox(height: 20.h),
                _buildSupportButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          MingCuteIcons.mgc_large_arrow_left_fill,
          color: Theme.of(context).colorScheme.secondary,
        ),
        onPressed: () {
          Get.back();
        },
      ),
      title: Text(
        S.current.settings_title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.tertiary,
          fontWeight: FontWeight.bold,
          fontFamily: 'CustomFont',
        ),
      ),
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.secondary,
    );
  }

  Widget _buildTopImage(BuildContext context) {
    return Image.asset(
      'assets/images/img_settings.png',
      width: 120.w,
      height: 120.h,
    );
  }

  Widget _buildThemeButton(BuildContext context) {
    return CustomSectionButton(
      onPressed: () {
        Get.to(
          () => const ThemesScreen(),
          transition: Transition.fade,
          duration: const Duration(milliseconds: 500),
        );
      },
      icon: MingCuteIcons.mgc_palette_fill,
      text: S.current.settings_theme,
    );
  }

  Widget _buildLanguageButton(BuildContext context) {
    return CustomSectionButton(
      onPressed: () {
        Get.to(
          () => const LanguagesScreen(),
          transition: Transition.fade,
          duration: const Duration(milliseconds: 500),
        );
      },
      icon: MingCuteIcons.mgc_translate_2_fill,
      text: S.current.settings_languages,
    );
  }

  Widget _buildInfoButton(BuildContext context) {
    return CustomSectionButton(
      onPressed: () {
        Get.to(
          () => const InfoScreen(),
          transition: Transition.fade,
          duration: const Duration(milliseconds: 500),
        );
      },
      icon: MingCuteIcons.mgc_information_fill,
      text: S.current.settings_info,
    );
  }

  Widget _buildPolicyButton(BuildContext context) {
    return CustomSectionButton(
      onPressed: () {
        Get.to(
          () => PolicyScreen(),
          transition: Transition.fade,
          duration: const Duration(milliseconds: 500),
        );
      },
      icon: MingCuteIcons.mgc_safe_lock_fill,
      text: S.current.settings_policy,
    );
  }

  Widget _buildSupportButton(BuildContext context) {
    return CustomSectionButton(
      onPressed: () {
        Get.to(
          () => const SupportScreen(),
          transition: Transition.fade,
          duration: const Duration(milliseconds: 500),
        );
      },
      icon: MingCuteIcons.mgc_send_fill,
      text: S.current.settings_support,
    );
  }
}
