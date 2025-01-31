import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/generated/l10n.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(30.r),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLogo(),
                  SizedBox(height: 20.h),
                  _buildAppName(context),
                  SizedBox(height: 20.h),
                  _buildDescription(context),
                  SizedBox(height: 20.h),
                  _buildCredits(context),
                  SizedBox(height: 20.h),
                  _buildVersion(context),
                ],
              ),
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
        S.current.info_screen_title,
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

  Widget _buildLogo() {
    return Center(
      child: Image.asset(
        'assets/images/app_logo.png',
        width: 180.w,
        height: 180.h,
      ),
    );
  }

  Widget _buildAppName(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.current.info_screen_origin_text,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'CustomFont',
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          S.current.info_screen_origin_description,
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 16.sp,
            fontFamily: 'CustomFont',
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.current.info_screen_description_text,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'CustomFont',
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          S.current.info_screen_description_description,
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 16.sp,
            fontFamily: 'CustomFont',
          ),
        ),
      ],
    );
  }

  Widget _buildCredits(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.current.info_screen_credits_text,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'CustomFont',
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          S.current.info_screen_credits_a_text,
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'CustomFont',
          ),
        ),
        Text(
          S.current.info_screen_credits_a_value,
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 16.sp,
            fontFamily: 'CustomFont',
          ),
        ),
        Text(
          S.current.info_screen_credits_b_text,
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'CustomFont',
          ),
        ),
        Text(
          S.current.info_screen_credits_b_value,
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 16.sp,
            fontFamily: 'CustomFont',
          ),
        ),
        Text(
          S.current.info_screen_credits_c_text,
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'CustomFont',
          ),
        ),
        Text(
          S.current.info_screen_credits_c_value,
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 16.sp,
            fontFamily: 'CustomFont',
          ),
        ),
      ],
    );
  }

  Widget _buildVersion(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.current.info_screen_version_text,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'CustomFont',
          ),
        ),
        Text(
          S.current.info_screen_version_value,
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 14.sp,
            fontFamily: 'CustomFont',
          ),
        ),
      ],
    );
  }
}
