import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/core/utils/shoes_text_translations.dart';
import 'package:shox/theme/app_font_sizes.dart';

class SeasonSelector extends StatelessWidget {
  final String? selectedSeason;
  final Map<String, String> translatedSeasonOptions;
  final ValueChanged<String> onSeasonSelected;

  const SeasonSelector({
    super.key,
    required this.selectedSeason,
    required this.translatedSeasonOptions,
    required this.onSeasonSelected,
  });

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
                MingCuteIcons.mgc_cloud_line,
                color: Theme.of(context).colorScheme.tertiary,
                size: 20.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                AppLocalizations.of(context)!
                    .shoes_adder_screen_field_season
                    .toUpperCase(),
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
          SizedBox(
            height: 60.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: translatedSeasonOptions.keys.length,
              separatorBuilder: (_, __) => SizedBox(width: 14.w),
              itemBuilder: (context, index) {
                final seasonKey = translatedSeasonOptions.keys.elementAt(index);
                final seasonLabel = translatedSeasonOptions[seasonKey]!;
                final isSelected = seasonKey == selectedSeason;
                final icon = ShoesTextTranslations.seasonIcons[seasonKey];

                return GestureDetector(
                  onTap: () => onSeasonSelected(seasonKey),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.secondary,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            icon,
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.secondary,
                            size: 20.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        seasonLabel,
                        style: GoogleFonts.montserrat(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: AppFontSizes.extraSmall,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
