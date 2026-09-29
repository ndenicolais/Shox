import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shox/theme/app_spacing.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/core/utils/utils.dart';
import 'package:shox/features/shoes/widgets/form/form_field_card.dart';

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
    return FormFieldCard(
      icon: MingCuteIcons.mgc_palette_2_line,
      label: AppLocalizations.of(context)!.extra_colors,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...colorList.map((color) {
              final isSelected = widget.selectedColors.contains(color);
              return Padding(
                padding: EdgeInsets.only(right: AppSpacing.xs.r),
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
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context).cardColor,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: isSelected
                        ? Icon(
                            MingCuteIcons.mgc_check_line,
                            size: 20.sp,
                            color: Theme.of(context).colorScheme.surface,
                          )
                        : null,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
