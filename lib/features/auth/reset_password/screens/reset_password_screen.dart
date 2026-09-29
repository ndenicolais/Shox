import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:shox/theme/app_spacing.dart';
import 'package:get/get.dart';
import 'package:shox/common/widgets/app_bar_widget.dart';
import 'package:shox/common/widgets/responsive_center_widget.dart';
import 'package:shox/common/widgets/logo_widget.dart';
import 'package:shox/features/auth/reset_password/controller/reset_password_controller.dart';
import 'package:shox/features/auth/reset_password/widgets/reset_password_form.dart';
import 'package:shox/common/widgets/button_widget.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ResetPasswordScreenState createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final ResetPasswordController controller =
      Get.find<ResetPasswordController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBarWidget(title: l10n.reset_password_screen_title),
      body: SafeArea(
        child: ResponsiveCenterWidget(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: LogoWidget(
                    width: 96,
                    height: 96,
                    semanticLabel: 'Reset Password Logo',
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  l10n.reset_password_screen_description,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                ResetPasswordForm(
                  context: context,
                  formKey: _formKey,
                  emailController: controller.emailController,
                ),
                const SizedBox(height: AppSpacing.l),
                Obx(
                  () => ButtonWidget(
                    isLoading: controller.isLoading.value,
                    text: l10n.reset_password_screen_text,
                    onPressed: () =>
                        controller.resetPassword(context, _formKey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
