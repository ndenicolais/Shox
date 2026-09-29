import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:shox/theme/app_spacing.dart';
import 'package:shox/common/widgets/app_bar_widget.dart';
import 'package:shox/common/widgets/responsive_center_widget.dart';
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
      body: SafeArea(
        child: ResponsiveCenterWidget(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.l),
            children: [
              const Center(
                child: LogoWidget(
                  width: 96,
                  height: 96,
                  semanticLabel: 'Info Logo',
                ),
              ),
              const SizedBox(height: AppSpacing.l),
              _buildSection(
                localizations.info_screen_origin_text,
                localizations.info_screen_origin_description,
              ),
              const SizedBox(height: AppSpacing.s),
              _buildSection(
                localizations.info_screen_description_text,
                localizations.info_screen_description_description,
              ),
              const SizedBox(height: AppSpacing.s),
              _buildCredits(localizations),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String description) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCredits(AppLocalizations localizations) {
    final textTheme = Theme.of(context).textTheme;
    final credits = [
      (
        localizations.info_screen_credits_a_text,
        localizations.info_screen_credits_a_value,
      ),
      (
        localizations.info_screen_credits_b_text,
        localizations.info_screen_credits_b_value,
      ),
      (
        localizations.info_screen_credits_c_text,
        localizations.info_screen_credits_c_value,
      ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.info_screen_credits_text,
              style: textTheme.titleMedium,
            ),
            for (final credit in credits) ...[
              const SizedBox(height: AppSpacing.s),
              Text(credit.$1.toUpperCase(), style: textTheme.labelSmall),
              const SizedBox(height: AppSpacing.xxs),
              Text(credit.$2, style: textTheme.bodyMedium),
            ],
          ],
        ),
      ),
    );
  }
}
