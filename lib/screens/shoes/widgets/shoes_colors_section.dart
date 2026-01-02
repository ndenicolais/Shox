import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';
import 'package:shox/screens/shoes/widgets/color_chip_widget.dart';
import 'package:shox/theme/app_font_sizes.dart';

class ShoesColorsSection extends StatelessWidget {
  final ShoesModel shoes;
  final VoidCallback? onColorTap;

  const ShoesColorsSection({
    super.key,
    required this.shoes,
    this.onColorTap,
  });

  List<Color> get allColors {
    final colors = <Color>[shoes.colorPrimary];
    if (shoes.colorExtra != null && shoes.colorExtra!.isNotEmpty) {
      colors.addAll(shoes.colorExtra!.map((colorInt) => Color(colorInt)));
    }
    return colors;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.shoes_details_screen_field_color,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: AppFontSizes.normal,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10.h),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 15.w,
          runSpacing: 15.h,
          children: allColors.asMap().entries.map((entry) {
            final index = entry.key;
            final color = entry.value;
            final isPrimary = index == 0;

            return ColorChipWidget(
              color: color,
              isPrimary: isPrimary,
              label: isPrimary
                  ? AppLocalizations.of(context)!
                      .shoes_details_screen_field_color_primary
                  : 'Extra $index',
              onTap: onColorTap,
            );
          }).toList(),
        ),
      ],
    );
  }
}
