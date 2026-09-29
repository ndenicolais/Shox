import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shox/theme/app_spacing.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/common/widgets/app_bar_widget.dart';
import 'package:shox/common/widgets/button_widget.dart';
import 'package:shox/features/users/models/user_model.dart';
import 'package:shox/features/auth/gender_selection/controller/gender_selection_controller.dart';
import 'package:shox/theme/app_colors.dart';
import 'package:shox/theme/app_font_sizes.dart';

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
    return Scaffold(
      appBar: AppBarWidget(
        title: AppLocalizations.of(context)!.gender_selection_screen_title,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: EdgeInsets.all(AppSpacing.l.r),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!
                        .gender_selection_screen_description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'CustomFont',
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: AppFontSizes.medium,
                    ),
                  ),
                  SizedBox(height: 48.h),
                  _buildGenderOption(
                    context,
                    gender: UserModel.genderMale,
                    label: AppLocalizations.of(context)!.gender_male,
                    icon: MingCuteIcons.mgc_male_line,
                  ),
                  SizedBox(height: 20.h),
                  _buildGenderOption(
                    context,
                    gender: UserModel.genderFemale,
                    label: AppLocalizations.of(context)!.gender_female,
                    icon: MingCuteIcons.mgc_female_line,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.l.r),
                child: _buildSaveButton(),
              ),
            ),
          ],
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
    final isSelected = _selectedGender == gender;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
        });
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppSpacing.l.r),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary,
            width: isSelected ? 3.w : 1.w,
          ),
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Row(
          children: [
            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.surface
                    : AppColors.champagne,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.secondary
                      : Colors.transparent,
                  width: 2.w,
                ),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.onSurface,
                size: 32.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'CustomFont',
                  color: isSelected
                      ? Theme.of(context).colorScheme.surface
                      : Theme.of(context).colorScheme.secondary,
                  fontSize: AppFontSizes.large,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                MingCuteIcons.mgc_check_circle_fill,
                color: Theme.of(context).colorScheme.surface,
                size: 32.sp,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return ButtonWidget(
      text: AppLocalizations.of(context)!.gender_selection_button,
      width: 180.w,
      height: 50.h,
      fontSize: AppFontSizes.large,
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
