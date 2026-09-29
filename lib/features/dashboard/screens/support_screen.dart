import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:shox/theme/app_spacing.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/common/widgets/app_bar_widget.dart';
import 'package:shox/common/widgets/responsive_center_widget.dart';
import 'package:shox/theme/app_radius.dart';
import 'package:shox/core/utils/constants.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBarWidget(title: l10n.support_screen_title),
      body: SafeArea(
        child: ResponsiveCenterWidget(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.l),
            children: [
              _buildContactSection(
                context,
                title: l10n.support_screen_contacts_text,
                description: l10n.support_screen_contacts_decription,
                contactInfo: l10n.support_screen_contacts_info,
                icon: MingCuteIcons.mgc_mail_send_line,
                onTap: _launchEmail,
              ),
              const SizedBox(height: AppSpacing.s),
              _buildContactSection(
                context,
                title: l10n.support_screen_documentation_text,
                description: l10n.support_screen_documentation_decription,
                contactInfo: l10n.support_screen_documentation_info,
                icon: MingCuteIcons.mgc_book_6_line,
                onTap: _launchDocumentation,
              ),
              const SizedBox(height: AppSpacing.l),
              _buildFaqSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactSection(
    BuildContext context, {
    required String title,
    required String description,
    required String contactInfo,
    required IconData icon,
    required Future<void> Function() onTap,
  }) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.m),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                ),
                child: Icon(icon, color: theme.colorScheme.onSurface),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(contactInfo, style: theme.textTheme.titleSmall),
                  ],
                ),
              ),
              Icon(
                MingCuteIcons.mgc_right_line,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final faqs = [
      (l10n.support_screen_faq_q1, l10n.support_screen_faq_a1),
      (l10n.support_screen_faq_q2, l10n.support_screen_faq_a2),
      (l10n.support_screen_faq_q3, l10n.support_screen_faq_a3),
      (l10n.support_screen_faq_q4, l10n.support_screen_faq_a4),
      (l10n.support_screen_faq_q8, l10n.support_screen_faq_a8),
      (l10n.support_screen_faq_q9, l10n.support_screen_faq_a9),
      (l10n.support_screen_faq_q10, l10n.support_screen_faq_a10),
      (l10n.support_screen_faq_q11, l10n.support_screen_faq_a11),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.support_screen_faq_text, style: theme.textTheme.titleLarge),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          l10n.support_screen_faq_decription,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.s),
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (var i = 0; i < faqs.length; i++) ...[
                if (i > 0) const Divider(height: 1),
                ExpansionTileWidget(title: faqs[i].$1, answer: faqs[i].$2),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _launchEmail() async {
    if (await launchUrlString(AppConstants.uriMail.toString())) {
      return;
    } else {
      throw 'Impossible to open email client';
    }
  }

  Future<void> _launchDocumentation() async {
    if (await launchUrlString(AppConstants.uriGithubDocumentation.toString())) {
      return;
    } else {
      throw 'Impossible to open documentation.';
    }
  }
}

class ExpansionTileWidget extends StatelessWidget {
  final String title;
  final String answer;

  const ExpansionTileWidget({
    super.key,
    required this.title,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ExpansionTile(
      shape: const Border(),
      collapsedShape: const Border(),
      iconColor: theme.colorScheme.onSurface,
      collapsedIconColor: theme.colorScheme.onSurfaceVariant,
      tilePadding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
      childrenPadding: const EdgeInsets.fromLTRB(
        AppSpacing.m,
        0,
        AppSpacing.m,
        AppSpacing.m,
      ),
      expandedAlignment: Alignment.centerLeft,
      title: Text(title, style: theme.textTheme.bodyLarge),
      children: [
        Text(
          answer,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
