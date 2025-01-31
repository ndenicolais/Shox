import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/theme/app_colors.dart';

// Function to show custom toast
void showCustomToastBar({
  required BuildContext context,
  required String title,
  Color? titleColor,
  Color? backgroundColor,
  required IconData icon,
  Color? iconColor,
}) {
  DelightToastBar(
    position: DelightSnackbarPosition.bottom,
    snackbarDuration: const Duration(milliseconds: 1500),
    builder: (context) => ToastCard(
      color: backgroundColor,
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(
          color: titleColor,
          fontFamily: 'CustomFont',
        ),
      ),
    ),
    autoDismiss: true,
  ).show(context);
}

// Function to show success custom toast
void showSuccessToast(BuildContext context, String title) {
  showCustomToastBar(
    context: context,
    title: title,
    titleColor: AppColors.toastLightGreen,
    icon: MingCuteIcons.mgc_check_fill,
    iconColor: AppColors.toastLightGreen,
    backgroundColor: AppColors.toastDarkGreen,
  );
}

// Function to show error custom toast
void showErrorToast(BuildContext context, String title) {
  showCustomToastBar(
    context: context,
    title: title,
    titleColor: AppColors.toastLightRed,
    icon: MingCuteIcons.mgc_warning_line,
    iconColor: AppColors.toastLightRed,
    backgroundColor: AppColors.toastDarkRed,
  );
}
