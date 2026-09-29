import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shox/theme/app_spacing.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/core/routes/app_routes.dart';
import 'package:shox/features/users/controller/user_controller.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:shox/theme/app_font_sizes.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TopBar extends StatelessWidget {
  final UserController userController;

  const TopBar({super.key, required this.userController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentUser = FirebaseAuth.instance.currentUser;

      return Container(
        padding: EdgeInsets.all(AppSpacing.s.r),
        decoration: BoxDecoration(
          color:
              Theme.of(context).colorScheme.secondary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: Row(
          children: [
            Tooltip(
              message: AppLocalizations.of(context)!.a11y_profile,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {
                  HapticFeedback.lightImpact();
                  Get.toNamed(AppRoutes.user);
                },
                child: Semantics(
                  button: true,
                  label: AppLocalizations.of(context)!.a11y_profile,
                  child: _buildUserImage(
                      context, userController.userProfileImage.value),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${AppLocalizations.of(context)!.home_screen_welcome_text}, ${userController.userName.value}',
                    style: TextStyle(
                      fontFamily: 'CustomFontBold',
                      color: Theme.of(context).colorScheme.tertiary,
                      fontSize: AppFontSizes.medium,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    currentUser?.email ?? '',
                    style: TextStyle(
                      fontFamily: 'CustomFont',
                      color: Theme.of(context).colorScheme.tertiary,
                      fontSize: AppFontSizes.small,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: AppLocalizations.of(context)!.a11y_settings,
              onPressed: () {
                HapticFeedback.lightImpact();
                Get.toNamed(AppRoutes.dashboard);
              },
              icon: Icon(
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
