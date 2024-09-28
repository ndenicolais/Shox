import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:provider/provider.dart';
import 'package:shox/generated/l10n.dart';
import 'package:shox/theme/app_colors.dart';
import 'package:shox/theme/theme_notifier.dart';

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

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
                40.verticalSpace,
                _buildDescription(context),
                40.verticalSpace,
                _buildThemeLayout(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThemeCard(
    BuildContext context,
    Color backgroundColor,
    IconData iconData,
    String text,
    VoidCallback onTap,
  ) {
    return Card(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(
            color: backgroundColor == AppColors.lightYellow
                ? AppColors.smoothBlack
                : AppColors.lightYellow,
            width: 1.0),
        borderRadius: BorderRadius.circular(10.0.r),
      ),
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        child: Container(
          width: 150.r,
          height: 200.r,
          padding: EdgeInsets.all(20.0.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                iconData,
                size: 60.r,
                color: backgroundColor == AppColors.lightYellow
                    ? AppColors.darkGold
                    : AppColors.white,
              ),
              10.verticalSpace,
              Text(
                text,
                style: TextStyle(
                  color: backgroundColor == AppColors.lightYellow
                      ? AppColors.smoothBlack
                      : AppColors.white,
                  fontSize: 16.r,
                  fontFamily: 'CustomFont',
                ),
              ),
            ],
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
        S.current.theme_title,
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
      'assets/images/img_theme.png',
      width: 120.r,
      height: 120.r,
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Text(
      S.current.theme_description,
      style: TextStyle(
        color: Theme.of(context).colorScheme.tertiary,
        fontSize: 22.r,
        fontFamily: 'CustomFont',
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildThemeLayout(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildThemeCard(
          context,
          AppColors.lightYellow,
          MingCuteIcons.mgc_sun_fill,
          S.current.theme_light,
          () {
            Provider.of<ThemeNotifier>(context, listen: false).setLightTheme();
          },
        ),
        10.horizontalSpace,
        _buildThemeCard(
          context,
          AppColors.smoothBlack,
          MingCuteIcons.mgc_moon_fill,
          S.current.theme_dark,
          () {
            Provider.of<ThemeNotifier>(context, listen: false).setDarkTheme();
          },
        ),
      ],
    );
  }
}
