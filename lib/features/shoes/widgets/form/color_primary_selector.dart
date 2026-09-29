import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shox/theme/app_spacing.dart';
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...colorList.map((color) {
              final isColorSelected = selectedColor == color && isSelected;
              return Padding(
                padding: EdgeInsets.only(right: AppSpacing.xs.r),
                child: GestureDetector(
                  onTap: () => onColorSelected(color),
                  child: Container(
                    width: 32.w,
                    height: 32.h,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isColorSelected
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context).cardColor,
                        width: isColorSelected ? 2 : 1,
                      ),
                    ),
                    child: isColorSelected
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
