import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/theme/app_colors.dart';
import 'package:shox/theme/app_font_sizes.dart';

class ToastWidget extends StatelessWidget {
  final String title;
  final Color titleColor;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final Color borderColor;
  final VoidCallback onClose;

  const ToastWidget({
    super.key,
    required this.title,
    required this.titleColor,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 50.h,
      left: 24.w,
      right: 24.w,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(100.r),
            border: Border.all(color: borderColor, width: 1.5.w),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(width: 12.w),
              Icon(icon, color: iconColor, size: 22.w),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.montserrat(
                    color: titleColor,
                    fontSize: AppFontSizes.extraSmall,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              IconButton(
                icon: Icon(
                  MingCuteIcons.mgc_close_line,
                  color: AppColors.darkGray,
                  size: 22.w,
                ),
                onPressed: onClose,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showToast({
  required BuildContext context,
  required String title,
  required Color titleColor,
  required IconData icon,
  required Color iconColor,
  required Color backgroundColor,
  required Color borderColor,
  Duration autoCloseDuration = const Duration(milliseconds: 1500),
}) {
  final overlay = Overlay.of(context);
  late final OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) => ToastWidget(
      title: title,
      titleColor: titleColor,
      icon: icon,
      iconColor: iconColor,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      onClose: () => overlayEntry.remove(),
    ),
  );
  overlay.insert(overlayEntry);

  Future.delayed(autoCloseDuration, () {
    if (overlayEntry.mounted) overlayEntry.remove();
  });
}

void showSuccessToast(BuildContext context, String title) {
  showToast(
    context: context,
    title: title,
    titleColor: AppColors.toastDarkGreen,
    icon: MingCuteIcons.mgc_check_line,
    iconColor: AppColors.toastDarkGreen,
    backgroundColor: AppColors.toastLightGreen,
    borderColor: AppColors.toastDarkGreen,
  );
}

void showErrorToast(BuildContext context, String title) {
  showToast(
    context: context,
    title: title,
    titleColor: AppColors.toastDarkRed,
    icon: MingCuteIcons.mgc_warning_line,
    iconColor: AppColors.toastDarkRed,
    backgroundColor: AppColors.toastLightRed,
    borderColor: AppColors.toastDarkRed,
  );
}
