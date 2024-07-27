import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/pages/settings/languages_page.dart';
import 'package:shox/pages/settings/support_page.dart';
import 'package:shox/pages/settings/info_page.dart';
import 'package:shox/pages/settings/notifications_page.dart';
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
      appBar: AppBar(
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
          'Settings',
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontWeight: FontWeight.bold,
            fontFamily: 'CustomFont',
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.secondary,
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Icon(
                MingCuteIcons.mgc_settings_5_fill,
                size: 120,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: 280,
                height: 60,
                child: MaterialButton(
                  onPressed: () {
                    Get.to(
                      () => const ThemePage(),
                      transition: Transition.fade,
                      duration: const Duration(milliseconds: 500),
                    );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  color: Theme.of(context).colorScheme.primary,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(MingCuteIcons.mgc_palette_fill,
                          color: Theme.of(context).colorScheme.secondary),
                      Text(
                        'Theme',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: 20,
                          fontFamily: 'CustomFont',
                        ),
                      ),
                      Icon(MingCuteIcons.mgc_right_fill,
                          color: Theme.of(context).colorScheme.tertiary),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 280,
                height: 60,
                child: MaterialButton(
                  onPressed: () {
                    Get.to(
                      () => const LanguagesPage(),
                      transition: Transition.fade,
                      duration: const Duration(milliseconds: 500),
                    );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  color: Theme.of(context).colorScheme.primary,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(MingCuteIcons.mgc_translate_2_fill,
                          color: Theme.of(context).colorScheme.secondary),
                      Text(
                        'Languages',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: 20,
                          fontFamily: 'CustomFont',
                        ),
                      ),
                      Icon(MingCuteIcons.mgc_right_fill,
                          color: Theme.of(context).colorScheme.tertiary),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 280,
                height: 60,
                child: MaterialButton(
                  onPressed: () {
                    Get.to(
                      () => const NotificationsPage(),
                      transition: Transition.fade,
                      duration: const Duration(milliseconds: 500),
                    );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  color: Theme.of(context).colorScheme.primary,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(MingCuteIcons.mgc_bell_ringing_fill,
                          color: Theme.of(context).colorScheme.secondary),
                      Text(
                        'Notifications',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: 20,
                          fontFamily: 'CustomFont',
                        ),
                      ),
                      Icon(MingCuteIcons.mgc_right_fill,
                          color: Theme.of(context).colorScheme.tertiary),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 280,
                height: 60,
                child: MaterialButton(
                  onPressed: () {
                    Get.to(
                      () => const InfoPage(),
                      transition: Transition.fade,
                      duration: const Duration(milliseconds: 500),
                    );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  color: Theme.of(context).colorScheme.primary,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(MingCuteIcons.mgc_information_fill,
                          color: Theme.of(context).colorScheme.secondary),
                      Text(
                        'Info',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: 20,
                          fontFamily: 'CustomFont',
                        ),
                      ),
                      Icon(MingCuteIcons.mgc_right_fill,
                          color: Theme.of(context).colorScheme.tertiary),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 280,
                height: 60,
                child: MaterialButton(
                  onPressed: () {
                    Get.to(
                      () => const ContactsPage(),
                      transition: Transition.fade,
                      duration: const Duration(milliseconds: 500),
                    );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  color: Theme.of(context).colorScheme.primary,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(MingCuteIcons.mgc_send_fill,
                          color: Theme.of(context).colorScheme.secondary),
                      Text(
                        'Support',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: 20,
                          fontFamily: 'CustomFont',
                        ),
                      ),
                      Icon(MingCuteIcons.mgc_right_fill,
                          color: Theme.of(context).colorScheme.tertiary),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
