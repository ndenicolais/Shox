import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/features/users/controller/user_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shox/screens/dashboard/screens/dashboard_screen.dart';
import 'package:shox/screens/users/screens/user_screen.dart';
import 'package:shox/theme/app_font_sizes.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TopBarWidget extends StatelessWidget {
  final UserController userController;

  const TopBarWidget({super.key, required this.userController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentUser = FirebaseAuth.instance.currentUser;

      return Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withAlpha(30),
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                Get.to(
                  () => UserScreen(userId: currentUser!.uid),
                  transition: Transition.fade,
                  duration: const Duration(milliseconds: 500),
                );
              },
              child: _buildUserImage(
                  context, userController.userProfileImage.value),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${AppLocalizations.of(context)!.home_screen_welcome_text}, ${userController.userName.value}',
                    style: GoogleFonts.montserrat(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontSize: AppFontSizes.medium,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    currentUser?.email ?? '',
                    style: GoogleFonts.montserrat(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontSize: AppFontSizes.small,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                Get.to(
                  () => DashboardScreen(userId: currentUser!.uid),
                  transition: Transition.rightToLeft,
                  duration: const Duration(milliseconds: 500),
                );
              },
              child: Icon(
                MingCuteIcons.mgc_settings_5_fill,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildImage(String imageUrl) {
    return Builder(
      builder: (context) {
        if (imageUrl.startsWith('http')) {
          return CachedNetworkImage(
            imageUrl: imageUrl,
            width: 50.w,
            height: 50.h,
            fit: BoxFit.cover,
            placeholder: (context, url) => CircularProgressIndicator(
              strokeWidth: 2,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            errorWidget: (context, url, error) => Icon(
              MingCuteIcons.mgc_user_3_fill,
              color: Theme.of(context).colorScheme.tertiary,
              size: 28.sp,
            ),
          );
        } else {
          return Image.file(
            File(imageUrl),
            width: 50.w,
            height: 50.h,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                MingCuteIcons.mgc_user_3_fill,
                color: Theme.of(context).colorScheme.tertiary,
                size: 28.sp,
              );
            },
          );
        }
      },
    );
  }

  Widget _buildUserImage(BuildContext context, dynamic userImage) {
    if (userImage != null && userImage.toString().isNotEmpty) {
      final imagePath =
          userImage is File ? userImage.path : userImage.toString();
      return ClipOval(child: _buildImage(imagePath));
    } else {
      return CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.tertiary.withAlpha(30),
        radius: 25.r,
        child: Icon(
          MingCuteIcons.mgc_user_3_fill,
          size: 28.sp,
          color: Theme.of(context).colorScheme.tertiary,
        ),
      );
    }
  }
}
