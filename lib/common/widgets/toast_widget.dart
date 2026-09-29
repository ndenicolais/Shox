import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shox/theme/app_spacing.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/theme/app_colors.dart';
import 'package:shox/theme/app_font_sizes.dart';
import 'package:shox/theme/app_radius.dart';

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
          padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.s.w, vertical: AppSpacing.s.h),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(color: borderColor, width: 1.w),
            boxShadow: [
              BoxShadow(
                color: const Color(0x33000000),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
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
                  style: TextStyle(
                    fontFamily: 'CustomFont',
                    color: titleColor,
                    fontSize: AppFontSizes.extraSmall,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              IconButton(
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
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

OverlayEntry? _activeToastEntry;

void showToast({
  required BuildContext context,
  required String title,
  required Color titleColor,
  required IconData icon,
  required Color iconColor,
  required Color backgroundColor,
  required Color borderColor,
  Duration autoCloseDuration = const Duration(milliseconds: 1500),
  OverlayState? overlay,
}) {
  _activeToastEntry?.remove();

  // An explicit overlay is needed when the only available context is not
  // below an Overlay (e.g. the navigator's own context from a service).
  overlay ??= Overlay.of(context);
  late final OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) => ToastWidget(
      title: title,
      titleColor: titleColor,
      icon: icon,
      iconColor: iconColor,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      onClose: () {
        overlayEntry.remove();
        if (_activeToastEntry == overlayEntry) _activeToastEntry = null;
      },
    ),
  );
  _activeToastEntry = overlayEntry;
  overlay.insert(overlayEntry);

  Future.delayed(autoCloseDuration, () {
    if (overlayEntry.mounted) overlayEntry.remove();
    if (_activeToastEntry == overlayEntry) _activeToastEntry = null;
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

void showErrorToast(
  BuildContext context,
  String title, {
  OverlayState? overlay,
}) {
  showToast(
    context: context,
    overlay: overlay,
    title: title,
    titleColor: AppColors.toastDarkRed,
    icon: MingCuteIcons.mgc_warning_line,
    iconColor: AppColors.toastDarkRed,
    backgroundColor: AppColors.toastLightRed,
    borderColor: AppColors.toastDarkRed,
  );
}
