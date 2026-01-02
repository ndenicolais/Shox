import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/common/screens/welcome_screen.dart';
import 'package:shox/common/widgets/app_bar_widget.dart';
import 'package:shox/common/widgets/button_widget.dart';
import 'package:shox/common/widgets/loader_widget.dart';
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
  final UserController userController = Get.put(UserController());
  final DatabaseController _databaseController = DatabaseController();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
          title: AppLocalizations.of(context)!.delete_account_screen_title),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(24.r),
              child: Column(
                spacing: 20.h,
                children: [
                  _buildWarningIcon(context),
                  _buildBodyText(context),
                  SizedBox(height: 80.h),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.all(20.r),
              child: _buildDeleteButton(),
            ),
          ),
          if (_isLoading) _buildDeleteLoading()
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
            Get.to(() => const WelcomeScreen(),
                transition: Transition.fade,
                duration: const Duration(milliseconds: 500));
          }
        }
      }
    } catch (e) {
      if (mounted) {
        showErrorToast(context,
            '${AppLocalizations.of(context)!.delete_account_screen_toast_error} $e');
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
            style: GoogleFonts.montserrat(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: AppFontSizes.mediumLarge,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            AppLocalizations.of(context)!.delete_account_screen_backup_text,
            style: GoogleFonts.montserrat(
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
                style: GoogleFonts.montserrat(
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
                style: GoogleFonts.montserrat(
                  color: AppColors.errorColor,
                  fontWeight: FontWeight.w600,
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

  Widget _buildWarningIcon(BuildContext context) {
    return Container(
      width: 100.w,
      height: 100.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            AppColors.errorColor.withValues(alpha: 0.2),
            AppColors.errorColor.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          MingCuteIcons.mgc_alert_line,
          size: 60.sp,
          color: AppColors.errorColor,
        ),
      ),
    );
  }

  Widget _buildBodyText(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context)
                    .colorScheme
                    .tertiary
                    .withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.delete_account_screen_text_a,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: AppFontSizes.medium,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                AppLocalizations.of(context)!.delete_account_screen_text_b,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  color: Theme.of(context)
                      .colorScheme
                      .tertiary
                      .withValues(alpha: 0.8),
                  fontSize: AppFontSizes.regular,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: AppColors.errorColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: AppColors.errorColor.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Icon(
                MingCuteIcons.mgc_information_line,
                color: AppColors.errorColor,
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.delete_account_screen_text_c,
                  style: GoogleFonts.montserrat(
                    color: AppColors.errorColor,
                    fontSize: AppFontSizes.regular,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteButton() {
    return ButtonWidget(
      backgroundColor: AppColors.errorColor,
      text: AppLocalizations.of(context)!.delete_account_screen_delete_button,
      textColor: Theme.of(context).colorScheme.primary,
      width: 150.w,
      height: 50.h,
      fontSize: AppFontSizes.regular,
      icon: MingCuteIcons.mgc_delete_2_line,
      iconSize: 18.sp,
      onPressed: _deleteAccount,
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
