import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/core/utils/shoes_text_translations.dart';
import 'package:shox/theme/app_font_sizes.dart';
import 'package:shox/features/shoes/widgets/form/form_field_card.dart';

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
    return FormFieldCard(
      icon: MingCuteIcons.mgc_cloud_line,
      label: AppLocalizations.of(context)!.shoes_adder_screen_field_season,
      child: SizedBox(
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
                          : Theme.of(context).cardColor,
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
                            ? Theme.of(context).colorScheme.surface
                            : Theme.of(context).colorScheme.secondary,
                        size: 20.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    seasonLabel,
                    style: TextStyle(
                      fontFamily: 'CustomFontBold',
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: AppFontSizes.extraSmall,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
