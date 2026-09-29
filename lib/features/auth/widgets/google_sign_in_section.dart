import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:shox/theme/app_spacing.dart';

/// "Or continue with" divider followed by a full-width Google button.
class GoogleSignInSection extends StatelessWidget {
  /// Null while another request is running: the button is disabled.
  final VoidCallback? onPressed;

  const GoogleSignInSection({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Expanded(child: Divider(height: 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
              child:
                  Text(l10n.auth_or_continue_with, style: textTheme.bodySmall),
            ),
            const Expanded(child: Divider(height: 1)),
          ],
        ),
        const SizedBox(height: AppSpacing.m),
        OutlinedButton.icon(
          onPressed: onPressed,
          icon: Image.asset(
            'assets/images/img_google.png',
            width: 20,
            height: 20,
          ),
          label: Text(l10n.auth_sign_in_with_google),
        ),
      ],
    );
  }
}
