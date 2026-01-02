import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/core/utils/utils.dart';
import 'package:shox/theme/app_font_sizes.dart';

class ExtraColorsSelector extends StatefulWidget {
  final List<Color> selectedColors;
  final Function(List<Color>) onColorsChanged;

  const ExtraColorsSelector({
    super.key,
    required this.selectedColors,
    required this.onColorsChanged,
  });

  @override
  State<ExtraColorsSelector> createState() => _ExtraColorsSelectorState();
}

class _ExtraColorsSelectorState extends State<ExtraColorsSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
          width: 1.w,
        ),
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                MingCuteIcons.mgc_palette_2_line,
                color: Theme.of(context).colorScheme.tertiary,
                size: 20.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                AppLocalizations.of(context)!.extra_colors.toUpperCase(),
                style: GoogleFonts.montserrat(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: AppFontSizes.small,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(width: 10.w),
                ...colorList.map((color) {
                  final isSelected = widget.selectedColors.contains(color);
                  return Padding(
                    padding: EdgeInsets.only(right: 8.r),
                    child: GestureDetector(
                      onTap: () {
                        final updatedColors =
                            List<Color>.from(widget.selectedColors);
                        if (isSelected) {
                          updatedColors.remove(color);
                        } else {
                          updatedColors.add(color);
                        }
                        widget.onColorsChanged(updatedColors);
                      },
                      child: Container(
                        width: 32.w,
                        height: 32.h,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).colorScheme.tertiary
                                : Theme.of(context).colorScheme.primary,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: isSelected
                            ? Icon(
                                MingCuteIcons.mgc_check_line,
                                size: 20.sp,
                                color: Theme.of(context).colorScheme.primary,
                              )
                            : null,
                      ),
                    ),
                  );
                }),
                SizedBox(width: 10.w),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
