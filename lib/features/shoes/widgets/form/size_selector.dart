import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/core/utils/utils.dart';
import 'package:shox/features/shoes/widgets/form/form_field_card.dart';
import 'package:shox/theme/app_spacing.dart';

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
    final label = AppLocalizations.of(context)!.shoes_adder_screen_field_size;
    return FormFieldCard(
      icon: MingCuteIcons.mgc_ruler_line,
      label: label,
      child: SizedBox(
        height: 48,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: sizesList.length,
          separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.xs),
          itemBuilder: (context, index) {
            final size = sizesList[index];
            return OptionCircle(
              text: size,
              semanticsLabel: '$label $size',
              selected: size == selectedSize,
              onTap: () => onSizeSelected(size),
            );
          },
        ),
      ),
    );
  }
}
