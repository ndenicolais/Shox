import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:shox/theme/theme_controller.dart';

class ThemeModeSelector extends StatelessWidget {
  const ThemeModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final localizations = AppLocalizations.of(context)!;

    return Obx(
      () => SegmentedButton<ThemeModeApp>(
        segments: [
          ButtonSegment(
            value: ThemeModeApp.system,
            icon: const Icon(MingCuteIcons.mgc_settings_3_line, size: 16),
            label: Text(localizations.theme_mode_system),
          ),
          ButtonSegment(
            value: ThemeModeApp.light,
            icon: const Icon(MingCuteIcons.mgc_sun_line, size: 16),
            label: Text(localizations.theme_mode_light),
          ),
          ButtonSegment(
            value: ThemeModeApp.dark,
            icon: const Icon(MingCuteIcons.mgc_moon_line, size: 16),
            label: Text(localizations.theme_mode_dark),
          ),
        ],
        selected: {themeController.mode},
        showSelectedIcon: false,
        onSelectionChanged: (selection) {
          switch (selection.first) {
            case ThemeModeApp.system:
              themeController.setSystemMode(
                systemBrightness: WidgetsBinding
                    .instance.platformDispatcher.platformBrightness,
              );
              break;
            case ThemeModeApp.light:
              themeController.setLightMode();
              break;
            case ThemeModeApp.dark:
              themeController.setDarkMode();
              break;
          }
        },
      ),
    );
  }
}
