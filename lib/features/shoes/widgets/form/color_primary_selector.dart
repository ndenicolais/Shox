import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/core/utils/utils.dart';
import 'package:shox/features/shoes/widgets/form/form_field_card.dart';

class ColorPrimarySelector extends StatelessWidget {
  final Color selectedColor;
  final bool isSelected;
  final Function(Color) onColorSelected;

  const ColorPrimarySelector({
    super.key,
    required this.selectedColor,
    required this.isSelected,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FormFieldCard(
      icon: MingCuteIcons.mgc_palette_line,
      label:
          AppLocalizations.of(context)!.shoes_adder_screen_field_color_primary,
      child: SizedBox(
        height: 44,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            for (final color in colorList)
              ColorDot(
                color: color,
                selected: isSelected && selectedColor == color,
                onTap: () => onColorSelected(color),
              ),
          ],
        ),
      ),
    );
  }
}
