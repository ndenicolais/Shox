import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/core/utils/utils.dart';
import 'package:shox/theme/app_font_sizes.dart';
import 'package:shox/features/shoes/widgets/form/form_field_card.dart';

class SizeSelector extends StatelessWidget {
  final String? selectedSize;
  final ValueChanged<String> onSizeSelected;

  const SizeSelector({
    super.key,
    required this.selectedSize,
    required this.onSizeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FormFieldCard(
      icon: MingCuteIcons.mgc_ruler_line,
      label: AppLocalizations.of(context)!.shoes_adder_screen_field_size,
      child: SizedBox(
        height: 40.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: sizesList.length,
          separatorBuilder: (_, __) => SizedBox(width: 10.w),
          itemBuilder: (context, index) {
            final size = sizesList[index];
            final isSelected = size == selectedSize;

            return GestureDetector(
              onTap: () => onSizeSelected(size),
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
                      child: Text(
                        size,
                        style: TextStyle(
                          fontFamily: 'CustomFontBold',
                          color: isSelected
                              ? Theme.of(context).colorScheme.surface
                              : Theme.of(context).colorScheme.secondary,
                          fontSize: AppFontSizes.small,
                        ),
                      ),
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
