import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shox/theme/app_spacing.dart';
import 'package:shox/common/widgets/app_bar_widget.dart';
import 'package:shox/common/widgets/logo_widget.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBarWidget(title: localizations.info_screen_title),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.screen.r),
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
                _buildSection(
                  localizations.info_screen_origin_text,
                  localizations.info_screen_origin_description,
                ),
                _buildSection(
                  localizations.info_screen_description_text,
                  localizations.info_screen_description_description,
                ),
                _buildCredits(localizations),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String description) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.titleMedium?.copyWith(color: colorScheme.secondary),
        ),
        SizedBox(height: 10.h),
        Text(
          description,
          style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurface),
        ),
      ],
    );
  }

  Widget _buildCredits(AppLocalizations localizations) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final credits = [
      (
        localizations.info_screen_credits_a_text,
        localizations.info_screen_credits_a_value
      ),
      (
        localizations.info_screen_credits_b_text,
        localizations.info_screen_credits_b_value
      ),
      (
        localizations.info_screen_credits_c_text,
        localizations.info_screen_credits_c_value
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.info_screen_credits_text,
          style: textTheme.titleMedium?.copyWith(color: colorScheme.secondary),
        ),
        SizedBox(height: 10.h),
        for (final credit in credits)
          _buildCreditRow(credit.$1, credit.$2, textTheme, colorScheme),
      ],
    );
  }

  Widget _buildCreditRow(
    String label,
    String value,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.xs.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
          ),
          Text(
            value,
            style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}
