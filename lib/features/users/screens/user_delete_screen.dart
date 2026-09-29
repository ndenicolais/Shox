import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shox/theme/app_spacing.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/common/widgets/app_bar_widget.dart';
import 'package:shox/common/widgets/button_widget.dart';
import 'package:shox/common/widgets/loader_widget.dart';
import 'package:shox/core/routes/app_routes.dart';
import 'package:shox/core/utils/permission_helper.dart';
import 'package:shox/features/database/controller/database_controller.dart';
import 'package:shox/features/users/controller/user_controller.dart';
import 'package:shox/theme/app_colors.dart';
import 'package:shox/common/widgets/delete_dialog_widget.dart';
import 'package:shox/common/widgets/toast_widget.dart';
import 'package:shox/theme/app_font_sizes.dart';

class UserDeleteScreen extends StatefulWidget {
  const UserDeleteScreen({super.key});

  @override
  UserDeleteScreenState createState() => UserDeleteScreenState();
}

class UserDeleteScreenState extends State<UserDeleteScreen> {
  final UserController userController = Get.find<UserController>();
  final DatabaseController _databaseController = Get.find<DatabaseController>();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: AppLocalizations.of(context)!.delete_account_screen_title,
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildHeroSection(context),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: AppSpacing.xxl.r),
                        child: Column(
                          spacing: 16.h,
                          children: [
                            _buildWhatHappensCard(context),
                            _buildWarningBanner(context),
                            SizedBox(height: 8.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _buildDeleteButton(context),
            ],
          ),
          if (_isLoading) _buildDeleteLoading(),
        ],
      ),
    );
  }

  Future<void> _deleteAccount() async {
    try {
      if (currentUser != null) {
        // First, show backup dialog
        bool? backupChoice = await _showBackupDialog(context);

        if (backupChoice == null) {
          // User cancelled
          return;
        }

        if (backupChoice) {
          // User wants to backup
          await _exportDatabase();
        }

        // Now show final confirmation dialog
        if (!mounted) return;
        bool confirmDelete = await _showDeleteDialog(context);

        if (confirmDelete) {
          setState(() {
            _isLoading = true;
          });

          if (!mounted) return;

          await userController.deleteAccount();

          setState(() {
            _isLoading = false;
          });

          if (mounted) {
            showSuccessToast(
              context,
              AppLocalizations.of(context)!.delete_account_screen_toast_success,
            );
            Get.offAllNamed(AppRoutes.welcome);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        showErrorToast(
          context,
          '${AppLocalizations.of(context)!.delete_account_screen_toast_error} $e',
        );
      }
    }
  }

  Future<bool?> _showBackupDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            AppLocalizations.of(context)!.delete_account_screen_backup_title,
            style: TextStyle(
              fontFamily: 'CustomFontBold',
              color: Theme.of(context).colorScheme.secondary,
              fontSize: AppFontSizes.mediumLarge,
            ),
          ),
          content: Text(
            AppLocalizations.of(context)!.delete_account_screen_backup_text,
            style: TextStyle(
              fontFamily: 'CustomFont',
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: AppFontSizes.normal,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: Text(
                AppLocalizations.of(context)!.delete_account_screen_skip_backup,
                style: TextStyle(
                  fontFamily: 'CustomFont',
                  color: Theme.of(context).colorScheme.tertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: Text(
                AppLocalizations.of(context)!
                    .delete_account_screen_backup_button,
                style: const TextStyle(
                  fontFamily: 'CustomFontBold',
                  color: AppColors.errorColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _exportDatabase() async {
    try {
      setState(() {
        _isLoading = true;
      });

      String permissionStatus =
          await requestManageExternalStoragePermission(context);
      if (permissionStatus != 'Permission granted') {
        throw Exception('Permission not granted');
      }

      final result = await _databaseController.exportDatabase();

      if (mounted) {
        if (result.success) {
          showSuccessToast(
            context,
            AppLocalizations.of(context)!.delete_account_screen_backup_success,
          );
        } else {
          showErrorToast(
            context,
            '${AppLocalizations.of(context)!.delete_account_screen_backup_error} ${result.message}',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showErrorToast(
          context,
          '${AppLocalizations.of(context)!.delete_account_screen_backup_error} $e',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<bool> _showDeleteDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return DeleteDialogWidget(
              title: AppLocalizations.of(context)!
                  .delete_account_screen_delete_dialog_title,
              content: AppLocalizations.of(context)!
                  .delete_account_screen_delete_dialog_text,
              onCancelPressed: () {
                Get.back(result: false);
              },
              onConfirmPressed: () {
                Get.back(result: true);
              },
            );
          },
        ) ??
        false;
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 40.r),
      child: Column(
        spacing: 16.h,
        children: [
          Container(
            width: 88.r,
            height: 88.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.errorColor.withValues(alpha: 0.12),
              border: Border.all(
                color: AppColors.errorColor.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Center(
              child: Icon(
                MingCuteIcons.mgc_delete_2_line,
                size: 44.sp,
                color: AppColors.errorColor,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl.r),
            child: Text(
              AppLocalizations.of(context)!.delete_account_screen_text_a,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'CustomFontBold',
                color: Theme.of(context).colorScheme.secondary,
                fontSize: AppFontSizes.mediumLarge,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl.r),
            child: Text(
              AppLocalizations.of(context)!.delete_account_screen_text_b,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'CustomFont',
                color: Theme.of(context)
                    .colorScheme
                    .tertiary
                    .withValues(alpha: 0.8),
                fontSize: AppFontSizes.small,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhatHappensCard(BuildContext context) {
    final items = [
      (
        MingCuteIcons.mgc_user_3_line,
        AppLocalizations.of(context)!.delete_account_screen_item_a
      ),
      (
        MingCuteIcons.mgc_box_2_line,
        AppLocalizations.of(context)!.delete_account_screen_item_b
      ),
      (
        MingCuteIcons.mgc_photo_album_line,
        AppLocalizations.of(context)!.delete_account_screen_item_c
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color:
              Theme.of(context).colorScheme.secondary.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.l.r,
              AppSpacing.l.r,
              AppSpacing.l.r,
              AppSpacing.s.r,
            ),
            child: Row(
              spacing: 10.w,
              children: [
                Icon(
                  MingCuteIcons.mgc_information_line,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 20.sp,
                ),
                Text(
                  AppLocalizations.of(context)!
                      .delete_account_screen_what_happens,
                  style: TextStyle(
                    fontFamily: 'CustomFontBold',
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: AppFontSizes.normal,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color:
                Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
          ),
          Padding(
            padding: EdgeInsets.all(AppSpacing.l.r),
            child: Column(
              spacing: 14.h,
              children: items
                  .map((item) => _buildCheckItem(context, item.$1, item.$2))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(BuildContext context, IconData icon, String label) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 14.w,
      children: [
        Container(
          width: 36.r,
          height: 36.r,
          decoration: BoxDecoration(
            color: AppColors.errorColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Center(
            child: Icon(
              icon,
              size: 18.sp,
              color: AppColors.errorColor,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: AppSpacing.xs.r),
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'CustomFont',
                color: Theme.of(context).colorScheme.tertiary,
                fontSize: AppFontSizes.small,
                height: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWarningBanner(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.m.r),
      decoration: BoxDecoration(
        color: AppColors.errorColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.errorColor.withValues(alpha: 0.35),
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.w,
        children: [
          Icon(
            MingCuteIcons.mgc_alert_line,
            color: AppColors.errorColor,
            size: 22.sp,
          ),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.delete_account_screen_text_c,
              style: TextStyle(
                fontFamily: 'CustomFont',
                color: AppColors.errorColor,
                fontSize: AppFontSizes.small,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: Border(
          top: BorderSide(
            color:
                Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
          ),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl.r,
        AppSpacing.m.r,
        AppSpacing.xl.r,
        AppSpacing.xxl.r,
      ),
      child: SizedBox(
        width: double.infinity,
        child: ButtonWidget(
          backgroundColor: AppColors.errorColor,
          text:
              AppLocalizations.of(context)!.delete_account_screen_delete_button,
          textColor: Theme.of(context).colorScheme.primary,
          height: 56.h,
          fontSize: AppFontSizes.regular,
          icon: MingCuteIcons.mgc_delete_2_line,
          iconSize: 20.sp,
          onPressed: _deleteAccount,
        ),
      ),
    );
  }

  Widget _buildDeleteLoading() {
    return Container(
      color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.5),
      child: LoaderWidget(
        width: 50.w,
        height: 50.h,
        icon: MingCuteIcons.mgc_eraser_line,
      ),
    );
  }
}
