import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shox/theme/app_colors.dart';

void showCustomToastBar(
  BuildContext context, {
  DelightSnackbarPosition position = DelightSnackbarPosition.bottom,
  required Color color,
  required Icon icon,
  required String title,
}) {
  Icon defaultIcon = Icon(
    icon.icon,
    color: AppColors.white,
    size: 28.r,
  );

  DelightToastBar(
    position: position,
    snackbarDuration: const Duration(milliseconds: 1500),
    builder: (context) => ToastCard(
      color: color,
      leading: defaultIcon,
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.white,
          fontSize: 16.r,
          fontFamily: 'CustomFont',
        ),
      ),
    ),
    autoDismiss: true,
  ).show(context);
}
