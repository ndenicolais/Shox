import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:shox/theme/app_spacing.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/common/widgets/app_bar_widget.dart';
import 'package:shox/common/widgets/responsive_center_widget.dart';
import 'package:shox/theme/app_radius.dart';
import 'package:shox/common/widgets/button_widget.dart';
import 'package:shox/features/users/models/user_model.dart';
import 'package:shox/features/auth/gender_selection/controller/gender_selection_controller.dart';

class GenderSelectionScreen extends StatefulWidget {
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

  @override
  GenderSelectionScreenState createState() => GenderSelectionScreenState();
}

class GenderSelectionScreenState extends State<GenderSelectionScreen> {
  final GenderSelectionController _controller =
      Get.find<GenderSelectionController>();
  String? _selectedGender;

  String get _resolvedUserId =>
      widget.userId ??
      (Get.arguments as Map<String, dynamic>)['userId'] as String;
  String get _resolvedUserEmail =>
      widget.userEmail ??
      (Get.arguments as Map<String, dynamic>)['userEmail'] as String;
  String get _resolvedUserName =>
      widget.userName ??
      (Get.arguments as Map<String, dynamic>)['userName'] as String;
  String? get _resolvedUserImage =>
      widget.userImage ??
      (Get.arguments as Map<String, dynamic>?)?['userImage'] as String?;

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
            child: Column(
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
                _buildGenderOption(
                  context,
                  gender: UserModel.genderMale,
                  label: l10n.gender_male,
                  icon: MingCuteIcons.mgc_male_line,
                ),
                const SizedBox(height: AppSpacing.s),
                _buildGenderOption(
                  context,
                  gender: UserModel.genderFemale,
                  label: l10n.gender_female,
                  icon: MingCuteIcons.mgc_female_line,
                ),
                const Spacer(),
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderOption(
    BuildContext context, {
    required String gender,
    required String label,
    required IconData icon,
  }) {
    final colors = Theme.of(context).colorScheme;
    final bool isSelected = _selectedGender == gender;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.extraLarge),
        side: BorderSide(
          color: isSelected ? colors.primary : Colors.transparent,
          width: 2,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Semantics(
        selected: isSelected,
        child: InkWell(
          onTap: () => setState(() => _selectedGender = gender),
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
                  opacity: isSelected ? 1 : 0,
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

  Widget _buildSaveButton() {
    return ButtonWidget(
      text: AppLocalizations.of(context)!.gender_selection_button,
      onPressed: _selectedGender != null
          ? () => _controller.saveGenderAndProceed(
                context: context,
                userId: _resolvedUserId,
                userEmail: _resolvedUserEmail,
                userName: _resolvedUserName,
                userImage: _resolvedUserImage,
                gender: _selectedGender!,
              )
          : null,
    );
  }
}
