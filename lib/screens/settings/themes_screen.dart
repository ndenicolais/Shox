import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:provider/provider.dart';
import 'package:shox/theme/app_colors.dart';
import 'package:shox/theme/theme_notifier.dart';

class ThemesScreen extends StatelessWidget {
  const ThemesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.r),
          child: Center(
            child: Column(
              spacing: 40.h,
              children: [
                _buildTopImage(context),
                _buildDescription(context),
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
          width: 1.w,
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        child: Container(
          width: 150.w,
          height: 200.h,
          padding: EdgeInsets.all(20.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                iconData,
                size: 60.sp,
                color: backgroundColor == AppColors.lightYellow
                    ? AppColors.darkGold
                    : AppColors.white,
              ),
              SizedBox(height: 10.h),
              Text(
                text,
                style: GoogleFonts.montserrat(
                  color: backgroundColor == AppColors.lightYellow
                      ? AppColors.smoothBlack
                      : AppColors.white,
                  fontSize: 16.sp,
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
        AppLocalizations.of(context)!.themes_screen_title,
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
      'assets/images/img_theme.png',
      width: 120.w,
      height: 120.h,
    );
  }

  Widget _buildDescription(BuildContext context) {
    return SizedBox(
      width: 320.w,
      child: Text(
        AppLocalizations.of(context)!.themes_screen_description,
        style: GoogleFonts.montserrat(
          color: Theme.of(context).colorScheme.tertiary,
          fontSize: 22.sp,
        ),
        textAlign: TextAlign.center,
      ),
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
          AppLocalizations.of(context)!.themes_screen_light,
          () {
            Provider.of<ThemeNotifier>(context, listen: false).setLightTheme();
          },
        ),
        10.horizontalSpace,
        _buildThemeCard(
          context,
          AppColors.smoothBlack,
          MingCuteIcons.mgc_moon_fill,
          AppLocalizations.of(context)!.themes_screen_dark,
          () {
            Provider.of<ThemeNotifier>(context, listen: false).setDarkTheme();
          },
        ),
      ],
    );
  }
}
