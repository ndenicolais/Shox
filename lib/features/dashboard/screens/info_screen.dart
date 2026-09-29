import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shox/common/widgets/app_bar_widget.dart';
import 'package:shox/common/widgets/logo_widget.dart';
import 'package:shox/common/widgets/responsive_center_widget.dart';
import 'package:shox/core/routes/app_routes.dart';
import 'package:shox/core/utils/constants.dart';
import 'package:shox/features/dashboard/widgets/dashboard_menu_item.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:shox/theme/app_radius.dart';
import 'package:shox/theme/app_spacing.dart';
import 'package:url_launcher/url_launcher.dart';

/// About the app: identity, what it does, useful links and credits.
class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((info) {
      if (mounted) setState(() => _version = info.version);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBarWidget(title: l10n.info_screen_title),
      body: SafeArea(
        child: ResponsiveCenterWidget(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.l),
            children: [
              _buildHeader(context),
              const SizedBox(height: AppSpacing.xl),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.m),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.info_screen_about_title,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        l10n.info_screen_about_text,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _sectionLabel(context, l10n.info_screen_features_title),
              _buildFeatures(context),
              _sectionLabel(context, l10n.info_screen_links_title),
              _buildLinks(context),
              const SizedBox(height: AppSpacing.xl),
              Text(
                l10n.info_screen_made_by(AppConstants.developerName),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        const LogoWidget(width: 96, height: 96, semanticLabel: 'Shox'),
        const SizedBox(height: AppSpacing.s),
        Text(l10n.intro_title, style: textTheme.headlineMedium),
        const SizedBox(height: AppSpacing.xxs),
        Text(l10n.intro_tagline, style: textTheme.bodyMedium),
        if (_version.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xxs),
          Text(l10n.info_screen_version(_version), style: textTheme.bodySmall),
        ],
      ],
    );
  }

  Widget _sectionLabel(BuildContext context, String title) => Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xxs,
          AppSpacing.l,
          0,
          AppSpacing.xs,
        ),
        child: Text(
          title.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall,
        ),
      );

  /// Two-by-two grid of the main features.
  Widget _buildFeatures(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final features = [
      (
        MingCuteIcons.mgc_camera_2_line,
        l10n.info_screen_feature_collection_title,
        l10n.info_screen_feature_collection_text,
      ),
      (
        MingCuteIcons.mgc_search_2_line,
        l10n.info_screen_feature_search_title,
        l10n.info_screen_feature_search_text,
      ),
      (
        MingCuteIcons.mgc_chart_pie_2_line,
        l10n.info_screen_feature_stats_title,
        l10n.info_screen_feature_stats_text,
      ),
      (
        MingCuteIcons.mgc_safe_box_line,
        l10n.info_screen_feature_backup_title,
        l10n.info_screen_feature_backup_text,
      ),
    ];

    return Column(
      children: [
        for (var i = 0; i < features.length; i += 2) ...[
          if (i > 0) const SizedBox(height: AppSpacing.s),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _FeatureCard(feature: features[i])),
                const SizedBox(width: AppSpacing.s),
                Expanded(child: _FeatureCard(feature: features[i + 1])),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLinks(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final rows = [
      DashboardMenuItem(
        icon: MingCuteIcons.mgc_github_line,
        text: l10n.info_screen_link_source,
        onTap: () => _open(AppConstants.uriGithubLink),
      ),
      DashboardMenuItem(
        icon: MingCuteIcons.mgc_world_2_line,
        text: l10n.info_screen_link_website,
        onTap: () => _open(AppConstants.uriGithubProfile),
      ),
      DashboardMenuItem(
        icon: MingCuteIcons.mgc_mail_line,
        text: l10n.info_screen_link_contact,
        onTap: () => _open(AppConstants.uriMail),
      ),
      DashboardMenuItem(
        icon: MingCuteIcons.mgc_safe_lock_line,
        text: l10n.settings_screen_policy,
        onTap: () => Get.toNamed(AppRoutes.privacyPolicy),
      ),
      DashboardMenuItem(
        icon: MingCuteIcons.mgc_document_2_line,
        text: l10n.info_screen_link_licenses,
        onTap: () => showLicensePage(
          context: context,
          applicationName: l10n.intro_title,
          applicationVersion: _version,
          applicationIcon: const Padding(
            padding: EdgeInsets.all(AppSpacing.s),
            child: LogoWidget(width: 64, height: 64, semanticLabel: 'Shox'),
          ),
        ),
      ),
    ];

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0)
              const Divider(
                height: 1,
                indent: AppSpacing.m + 36 + AppSpacing.m,
              ),
            rows[i],
          ],
        ],
      ),
    );
  }

  Future<void> _open(Uri uri) =>
      launchUrl(uri, mode: LaunchMode.externalApplication);
}

class _FeatureCard extends StatelessWidget {
  final (IconData, String, String) feature;

  const _FeatureCard({required this.feature});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (icon, title, text) = feature;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(AppRadius.medium),
              ),
              child: Icon(icon, size: 20, color: theme.colorScheme.onSurface),
            ),
            const SizedBox(height: AppSpacing.s),
            Text(title, style: theme.textTheme.titleSmall),
            const SizedBox(height: AppSpacing.xxs),
            Text(text, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
