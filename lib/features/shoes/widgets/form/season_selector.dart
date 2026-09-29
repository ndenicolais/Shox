import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/core/utils/shoes_text_translations.dart';
import 'package:shox/features/shoes/widgets/form/form_field_card.dart';
import 'package:shox/theme/app_spacing.dart';

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
    final textTheme = Theme.of(context).textTheme;
    return FormFieldCard(
      icon: MingCuteIcons.mgc_cloud_line,
      label: AppLocalizations.of(context)!.shoes_adder_screen_field_season,
      child: SizedBox(
        height: 72,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: translatedSeasonOptions.length,
          separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.s),
          itemBuilder: (context, index) {
            final seasonKey = translatedSeasonOptions.keys.elementAt(index);
            final seasonLabel = translatedSeasonOptions[seasonKey]!;
            return Column(
              children: [
                OptionCircle(
                  icon: ShoesTextTranslations.seasonIcons[seasonKey],
                  semanticsLabel: seasonLabel,
                  selected: seasonKey == selectedSeason,
                  onTap: () => onSeasonSelected(seasonKey),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(seasonLabel, style: textTheme.bodySmall),
              ],
            );
          },
        ),
      ),
    );
  }
}
