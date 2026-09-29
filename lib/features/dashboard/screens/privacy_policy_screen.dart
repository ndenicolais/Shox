import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/common/widgets/app_bar_widget.dart';
import 'package:shox/common/widgets/responsive_center_widget.dart';
import 'package:shox/core/utils/constants.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:shox/theme/app_spacing.dart';
import 'package:url_launcher/url_launcher.dart';

/// Native, localized privacy policy. The same text is published in
/// PRIVACY.md (linked as the public URL): keep them in sync.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final updated =
        DateFormat.yMMMMd(locale).format(AppConstants.privacyPolicyUpdatedAt);

    final sections = [
      (
        l10n.policy_section_controller_title,
        l10n.policy_section_controller_text(
          AppConstants.developerName,
          AppConstants.developerEmail,
        ),
      ),
      (l10n.policy_section_data_title, l10n.policy_section_data_text),
      (l10n.policy_section_use_title, l10n.policy_section_use_text),
      (l10n.policy_section_storage_title, l10n.policy_section_storage_text),
      (l10n.policy_section_device_title, l10n.policy_section_device_text),
      (
        l10n.policy_section_permissions_title,
        l10n.policy_section_permissions_text,
      ),
      (
        l10n.policy_section_retention_title,
        l10n.policy_section_retention_text,
      ),
      (l10n.policy_section_rights_title, l10n.policy_section_rights_text),
      (l10n.policy_section_children_title, l10n.policy_section_children_text),
      (l10n.policy_section_changes_title, l10n.policy_section_changes_text),
    ];

    return Scaffold(
      appBar: AppBarWidget(title: l10n.policy_screen_title),
      body: SafeArea(
        child: ResponsiveCenterWidget(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.l),
            children: [
              Text(
                l10n.policy_screen_updated(updated),
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.s),
              Text(l10n.policy_screen_intro, style: theme.textTheme.bodyLarge),
              for (final (index, (title, text)) in sections.indexed) ...[
                const SizedBox(height: AppSpacing.s),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.m),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${index + 1}. $title',
                          style: theme.textTheme.titleSmall,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          text,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.m),
              TextButton.icon(
                onPressed: () => launchUrl(
                  AppConstants.uriPrivacyPolicy,
                  mode: LaunchMode.externalApplication,
                ),
                icon: const Icon(MingCuteIcons.mgc_external_link_line),
                label: Text(l10n.policy_screen_online),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
