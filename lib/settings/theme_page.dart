import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:provider/provider.dart';
import 'package:shox/theme/app_colors.dart';
import 'package:shox/theme/theme_notifier.dart';

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

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
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.secondary,
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Icon(
                MingCuteIcons.mgc_moon_fill,
                size: 120,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(height: 80),
              Text(
                'Select the theme of the app\nby swiping between\nthe cards below',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: 22,
                  fontFamily: 'CustomFont',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    color: AppColors.lightYellow,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                          color: AppColors.smoothBlack, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: InkWell(
                      onTap: () {
                        Provider.of<ThemeNotifier>(context, listen: false)
                            .setLightTheme();
                      },
                      splashColor: Colors.transparent,
                      child: Container(
                        width: 150,
                        height: 200,
                        padding: const EdgeInsets.all(20.0),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.wb_sunny,
                              size: 60,
                              color: AppColors.sun,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Light',
                              style: TextStyle(
                                color: AppColors.smoothBlack,
                                fontSize: 16,
                                fontFamily: 'CustomFont',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Card(
                    color: AppColors.smoothBlack,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                          color: AppColors.lightYellow, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: InkWell(
                      onTap: () {
                        Provider.of<ThemeNotifier>(context, listen: false)
                            .setDarkTheme();
                      },
                      splashColor: Colors.transparent,
                      child: Container(
                        width: 150,
                        height: 200,
                        padding: const EdgeInsets.all(20.0),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.nights_stay,
                              size: 60,
                              color: AppColors.white,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Dark',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 16,
                                fontFamily: 'CustomFont',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
