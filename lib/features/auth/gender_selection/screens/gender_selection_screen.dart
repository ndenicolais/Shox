import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/common/widgets/app_bar_widget.dart';
import 'package:shox/common/widgets/button_widget.dart';
import 'package:shox/common/widgets/responsive_center_widget.dart';
import 'package:shox/features/auth/gender_selection/controller/gender_selection_controller.dart';
import 'package:shox/features/users/models/user_model.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:shox/theme/app_radius.dart';
import 'package:shox/theme/app_spacing.dart';

class GenderSelectionScreen extends GetView<GenderSelectionController> {
  final String? userId;
  final String? userEmail;
  final String? userName;
  final String? userImage;

  const GenderSelectionScreen({
    super.key,
    this.userId,
    this.userEmail,
    this.userName,
    this.userImage,
  });

  Map<String, dynamic>? get _arguments =>
      Get.arguments as Map<String, dynamic>?;

  String get _resolvedUserId => userId ?? _arguments!['userId'] as String;
  String get _resolvedUserEmail =>
      userEmail ?? _arguments!['userEmail'] as String;
  String get _resolvedUserName => userName ?? _arguments!['userName'] as String;
  String? get _resolvedUserImage =>
      userImage ?? _arguments?['userImage'] as String?;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBarWidget(title: l10n.gender_selection_screen_title),
      body: SafeArea(
        child: ResponsiveCenterWidget(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.gender_selection_screen_description,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _GenderOption(
                    label: l10n.gender_male,
                    icon: MingCuteIcons.mgc_male_line,
                    selected:
                        controller.selectedGender.value == UserModel.genderMale,
                    onTap: () =>
                        controller.selectedGender.value = UserModel.genderMale,
                  ),
                  const SizedBox(height: AppSpacing.s),
                  _GenderOption(
                    label: l10n.gender_female,
                    icon: MingCuteIcons.mgc_female_line,
                    selected: controller.selectedGender.value ==
                        UserModel.genderFemale,
                    onTap: () => controller.selectedGender.value =
                        UserModel.genderFemale,
                  ),
                  const Spacer(),
                  ButtonWidget(
                    text: l10n.gender_selection_button,
                    onPressed: controller.selectedGender.value != null
                        ? () => controller.saveGenderAndProceed(
                              context: context,
                              userId: _resolvedUserId,
                              userEmail: _resolvedUserEmail,
                              userName: _resolvedUserName,
                              userImage: _resolvedUserImage,
                              gender: controller.selectedGender.value!,
                            )
                        : null,
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

/// Selectable card for one gender option.
class _GenderOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _GenderOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.extraLarge),
        side: BorderSide(
          color: selected ? colors.primary : Colors.transparent,
          width: 2,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Semantics(
        selected: selected,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: colors.surface,
                  child: Icon(icon, color: colors.onSurface, size: 26),
                ),
                const SizedBox(width: AppSpacing.m),
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                AnimatedOpacity(
                  opacity: selected ? 1 : 0,
                  duration: const Duration(milliseconds: 150),
                  child: Icon(
                    MingCuteIcons.mgc_check_circle_fill,
                    color: colors.primary,
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
