import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/core/utils/utils.dart';
import 'package:shox/features/shoes/widgets/form/form_field_card.dart';

class ExtraColorsSelector extends StatelessWidget {
  final List<Color> selectedColors;
  final Function(List<Color>) onColorsChanged;

  const ExtraColorsSelector({
    super.key,
    required this.selectedColors,
    required this.onColorsChanged,
  });

  void _toggle(Color color) {
    final updated = List<Color>.from(selectedColors);
    if (!updated.remove(color)) updated.add(color);
    onColorsChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    return FormFieldCard(
      icon: MingCuteIcons.mgc_palette_2_line,
      label: AppLocalizations.of(context)!.extra_colors,
      child: SizedBox(
        height: 44,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            for (final color in colorList)
              ColorDot(
                color: color,
                selected: selectedColors.contains(color),
                onTap: () => _toggle(color),
              ),
          ],
        ),
      ),
    );
  }
}
