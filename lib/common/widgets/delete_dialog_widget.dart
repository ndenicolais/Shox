import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/theme/app_font_sizes.dart';

class DeleteDialogWidget extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onCancelPressed;
  final VoidCallback onConfirmPressed;

  const DeleteDialogWidget({
    super.key,
    required this.title,
    required this.content,
    required this.onCancelPressed,
    required this.onConfirmPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
        side: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
          width: 2,
        ),
      ),
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 24.h),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(22.r),
                topRight: Radius.circular(22.r),
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
                  style: GoogleFonts.montserrat(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: AppFontSizes.mediumLarge,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(24.r),
            child: Text(
              content,
              style: GoogleFonts.montserrat(
                color: Theme.of(context).colorScheme.tertiary,
                fontSize: AppFontSizes.normal,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 24.r, right: 24.r, bottom: 24.r),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: onCancelPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor:
                            Theme.of(context).colorScheme.secondary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!
                            .custom_delete_dialog_cancel,
                        style: GoogleFonts.montserrat(
                          fontSize: AppFontSizes.normal,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: SizedBox(
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: onConfirmPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!
                            .custom_delete_dialog_confirm,
                        style: GoogleFonts.montserrat(
                          fontSize: AppFontSizes.normal,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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
