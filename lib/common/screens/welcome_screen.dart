import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shox/common/widgets/button_widget.dart';
import 'package:shox/common/widgets/logo_widget.dart';
import 'package:shox/common/widgets/responsive_center_widget.dart';
import 'package:shox/core/routes/app_routes.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:shox/theme/app_spacing.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: ResponsiveCenterWidget(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  const Center(
                    child: LogoWidget(
                      width: 180,
                      height: 180,
                      semanticLabel: 'Welcome Logo',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    l10n.welcome_text,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.displaySmall,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l10n.welcome_subtitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  ButtonWidget(
                    text: l10n.welcome_login,
                    onPressed: () => Get.toNamed(AppRoutes.login),
                  ),
                  const SizedBox(height: AppSpacing.s),
                  ButtonWidget(
                    text: l10n.welcome_signup,
                    isOutline: true,
                    onPressed: () => Get.toNamed(AppRoutes.signup),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
