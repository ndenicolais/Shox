import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shox/theme/app_spacing.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/common/widgets/button_widget.dart';
import 'package:shox/theme/app_font_sizes.dart';
import 'package:shox/theme/app_radius.dart';

class DeleteDialogWidget extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onCancelPressed;
  final VoidCallback onConfirmPressed;

  /// Overrides the default "Cancel" / "Delete" button labels.
  final String? cancelLabel;
  final String? confirmLabel;

  const DeleteDialogWidget({
    super.key,
    required this.title,
    required this.content,
    required this.onCancelPressed,
    required this.onConfirmPressed,
    this.cancelLabel,
    this.confirmLabel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.primary,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.dialog),
      ),
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: AppSpacing.xl.h),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppRadius.dialog),
                topRight: Radius.circular(AppRadius.dialog),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  MingCuteIcons.mgc_alert_line,
                  size: 48.sp,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(height: 12.h),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'CustomFontBold',
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: AppFontSizes.mediumLarge,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(AppSpacing.xl.r),
            child: Text(
              content,
              style: TextStyle(
                fontFamily: 'CustomFont',
                color: Theme.of(context).colorScheme.tertiary,
                fontSize: AppFontSizes.normal,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: AppSpacing.xl.r,
                right: AppSpacing.xl.r,
                bottom: AppSpacing.xl.r),
            child: Row(
              children: [
                Expanded(
                  child: ButtonWidget(
                    height: 48.h,
                    fontSize: AppFontSizes.normal,
                    isOutline: true,
                    onPressed: onCancelPressed,
                    text: cancelLabel ??
                        AppLocalizations.of(context)!
                            .custom_delete_dialog_cancel,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ButtonWidget(
                    height: 48.h,
                    fontSize: AppFontSizes.normal,
                    onPressed: onConfirmPressed,
                    text: confirmLabel ??
                        AppLocalizations.of(context)!
                            .custom_delete_dialog_confirm,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
