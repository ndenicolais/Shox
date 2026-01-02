import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/theme/app_font_sizes.dart';

class BrandTextField extends StatelessWidget {
  final TextEditingController controller;

  const BrandTextField({
    super.key,
    required this.controller,
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
                MingCuteIcons.mgc_tag_line,
                color: Theme.of(context).colorScheme.tertiary,
                size: 20.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                AppLocalizations.of(context)!
                    .shoes_adder_screen_field_brand
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
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText:
                  AppLocalizations.of(context)!.shoes_adder_screen_field_brand,
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 2,
                ),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.error,
                  width: 2,
                ),
              ),
            ),
            style: GoogleFonts.montserrat(
              color: Theme.of(context).colorScheme.secondary,
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.sentences,
            validator: (val) => val!.isEmpty
                ? AppLocalizations.of(context)!
                    .shoes_adder_screen_toast_error_brand
                : null,
          ),
        ],
      ),
    );
  }
}
