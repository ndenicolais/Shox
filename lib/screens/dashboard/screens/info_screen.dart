import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shox/common/widgets/app_bar_widget.dart';
import 'package:shox/common/widgets/logo_widget.dart';
import 'package:shox/theme/app_font_sizes.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBarWidget(title: AppLocalizations.of(context)!.info_screen_title),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.r),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 20.h,
              children: [
                Center(
                  child: LogoWidget(
                    width: 150.w,
                    height: 150.h,
                    semanticLabel: 'Info Logo',
                  ),
                ),
                _buildAppName(),
                _buildDescription(),
                _buildCredits(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.info_screen_origin_text,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: AppFontSizes.regular,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          AppLocalizations.of(context)!.info_screen_origin_description,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: AppFontSizes.small,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.info_screen_description_text,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: AppFontSizes.regular,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          AppLocalizations.of(context)!.info_screen_description_description,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: AppFontSizes.small,
          ),
        ),
      ],
    );
  }

  Widget _buildCredits() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.info_screen_credits_text,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: AppFontSizes.regular,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          AppLocalizations.of(context)!.info_screen_credits_a_text,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: AppFontSizes.normal,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          AppLocalizations.of(context)!.info_screen_credits_a_value,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: AppFontSizes.small,
          ),
        ),
        Text(
          AppLocalizations.of(context)!.info_screen_credits_b_text,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: AppFontSizes.normal,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          AppLocalizations.of(context)!.info_screen_credits_b_value,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: AppFontSizes.small,
          ),
        ),
        Text(
          AppLocalizations.of(context)!.info_screen_credits_c_text,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: AppFontSizes.normal,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          AppLocalizations.of(context)!.info_screen_credits_c_value,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: AppFontSizes.small,
          ),
        ),
      ],
    );
  }
}
