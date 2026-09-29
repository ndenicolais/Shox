import 'package:flutter/material.dart';
import 'package:shox/common/widgets/error_state_widget.dart';
import 'package:shox/l10n/app_localizations.dart';

/// Shown in place of the app when a required service (Firebase) fails to
/// initialize at startup.
class StartupErrorScreen extends StatelessWidget {
  final VoidCallback? onRetry;

  const StartupErrorScreen({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: ErrorStateWidget(
          message: AppLocalizations.of(context)!.startup_error_message,
          onRetry: onRetry,
        ),
      ),
    );
  }
}
