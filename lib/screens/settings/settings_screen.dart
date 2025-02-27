import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/screens/settings/language_screen.dart';
import 'package:shox/screens/settings/support_screen.dart';
import 'package:shox/screens/settings/info_screen.dart';
import 'package:shox/screens/settings/policy_screen.dart';
import 'package:shox/screens/settings/theme_screen.dart';
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
              spacing: 20.h,
              children: [
                _buildTopImage(context),
                SizedBox(height: 40.h),
                _buildThemeButton(context),
                _buildLanguageButton(context),
                _buildInfoButton(context),
                _buildPolicyButton(context),
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
        AppLocalizations.of(context)!.settings_screen_title,
        style: GoogleFonts.montserrat(
          color: Theme.of(context).colorScheme.secondary,
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
          () => const ThemeScreen(),
          transition: Transition.fade,
          duration: const Duration(milliseconds: 500),
        );
      },
      icon: MingCuteIcons.mgc_palette_fill,
      text: AppLocalizations.of(context)!.settings_screen_theme,
    );
  }

  Widget _buildLanguageButton(BuildContext context) {
    return CustomSectionButton(
      onPressed: () {
        Get.to(
          () => const LanguageScreen(),
          transition: Transition.fade,
          duration: const Duration(milliseconds: 500),
        );
      },
      icon: MingCuteIcons.mgc_translate_2_fill,
      text: AppLocalizations.of(context)!.settings_screen_language,
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
      text: AppLocalizations.of(context)!.settings_screen_info,
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
      text: AppLocalizations.of(context)!.settings_screen_policy,
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
      text: AppLocalizations.of(context)!.settings_screen_support,
    );
  }
}
