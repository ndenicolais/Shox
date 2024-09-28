import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/generated/l10n.dart';
import 'package:shox/pages/settings/languages_page.dart';
import 'package:shox/pages/settings/support_page.dart';
import 'package:shox/pages/settings/info_page.dart';
import 'package:shox/pages/settings/policy_page.dart';
import 'package:shox/pages/settings/theme_page.dart';

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
          padding: EdgeInsets.symmetric(vertical: 30.r, horizontal: 30.r),
          child: Center(
            child: Column(
              children: [
                _buildTopImage(),
                80.verticalSpace,
                _buildThemeButton(context),
                20.verticalSpace,
                _buildLanguageButton(context),
                20.verticalSpace,
                _buildInfoButton(context),
                20.verticalSpace,
                _buildPolicyButton(context),
                20.verticalSpace,
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

  Widget _buildTopImage() {
    return Image.asset(
      'assets/images/img_settings.png',
      width: 120.r,
      height: 120.r,
    );
  }

  Widget _buildThemeButton(BuildContext context) {
    return SizedBox(
      width: 300.r,
      height: 60.r,
      child: MaterialButton(
        onPressed: () {
          Get.to(
            () => const ThemePage(),
            transition: Transition.fade,
            duration: const Duration(milliseconds: 500),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.r),
          side: BorderSide(color: Theme.of(context).colorScheme.secondary),
        ),
        color: Theme.of(context).colorScheme.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(MingCuteIcons.mgc_palette_fill,
                color: Theme.of(context).colorScheme.secondary),
            Text(
              S.current.settings_theme,
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontSize: 20.r,
                fontFamily: 'CustomFont',
              ),
            ),
            Icon(MingCuteIcons.mgc_right_fill,
                color: Theme.of(context).colorScheme.tertiary),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageButton(BuildContext context) {
    return SizedBox(
      width: 300.r,
      height: 60.r,
      child: MaterialButton(
        onPressed: () {
          Get.to(
            () => const LanguagesPage(),
            transition: Transition.fade,
            duration: const Duration(milliseconds: 500),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.r),
          side: BorderSide(color: Theme.of(context).colorScheme.secondary),
        ),
        color: Theme.of(context).colorScheme.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(MingCuteIcons.mgc_translate_2_fill,
                color: Theme.of(context).colorScheme.secondary),
            Text(
              S.current.settings_languages,
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontSize: 20.r,
                fontFamily: 'CustomFont',
              ),
            ),
            Icon(MingCuteIcons.mgc_right_fill,
                color: Theme.of(context).colorScheme.tertiary),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoButton(BuildContext context) {
    return SizedBox(
      width: 300.r,
      height: 60.r,
      child: MaterialButton(
        onPressed: () {
          Get.to(
            () => const InfoPage(),
            transition: Transition.fade,
            duration: const Duration(milliseconds: 500),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.r),
          side: BorderSide(color: Theme.of(context).colorScheme.secondary),
        ),
        color: Theme.of(context).colorScheme.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(MingCuteIcons.mgc_information_fill,
                color: Theme.of(context).colorScheme.secondary),
            Text(
              S.current.settings_info,
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontSize: 20.r,
                fontFamily: 'CustomFont',
              ),
            ),
            Icon(MingCuteIcons.mgc_right_fill,
                color: Theme.of(context).colorScheme.tertiary),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicyButton(BuildContext context) {
    return SizedBox(
      width: 300.r,
      height: 60.r,
      child: MaterialButton(
        onPressed: () {
          Get.to(
            () => PrivacyPolicyPage(),
            transition: Transition.fade,
            duration: const Duration(milliseconds: 500),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.r),
          side: BorderSide(color: Theme.of(context).colorScheme.secondary),
        ),
        color: Theme.of(context).colorScheme.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(MingCuteIcons.mgc_safe_lock_fill,
                color: Theme.of(context).colorScheme.secondary),
            Text(
              S.current.settings_policy,
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontSize: 20.r,
                fontFamily: 'CustomFont',
              ),
            ),
            Icon(MingCuteIcons.mgc_right_fill,
                color: Theme.of(context).colorScheme.tertiary),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportButton(BuildContext context) {
    return SizedBox(
      width: 300.r,
      height: 60.r,
      child: MaterialButton(
        onPressed: () {
          Get.to(
            () => const ContactsPage(),
            transition: Transition.fade,
            duration: const Duration(milliseconds: 500),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.r),
          side: BorderSide(color: Theme.of(context).colorScheme.secondary),
        ),
        color: Theme.of(context).colorScheme.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(MingCuteIcons.mgc_send_fill,
                color: Theme.of(context).colorScheme.secondary),
            Text(
              S.current.settings_support,
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontSize: 20.r,
                fontFamily: 'CustomFont',
              ),
            ),
            Icon(MingCuteIcons.mgc_right_fill,
                color: Theme.of(context).colorScheme.tertiary),
          ],
        ),
      ),
    );
  }
}
