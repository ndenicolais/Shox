import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shox/core/routes/app_routes.dart';
import 'package:shox/l10n/app_localizations.dart';

/// Notice shown before an account is created or linked (GDPR art. 13): the
/// minimum age and a link to the privacy policy, which is a public route.
class PrivacyNotice extends StatelessWidget {
  const PrivacyNotice({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          l10n.auth_privacy_notice,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        // A real button rather than a text span: full touch target and
        // announced as a button by screen readers.
        TextButton(
          onPressed: () => Get.toNamed(AppRoutes.privacyPolicy),
          child: Text(l10n.settings_screen_policy),
        ),
      ],
    );
  }
}
