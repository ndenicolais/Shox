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
import 'package:shox/features/users/widgets/delete_account_info.dart';
import 'package:shox/theme/app_colors.dart';
import 'package:shox/common/widgets/delete_dialog_widget.dart';
import 'package:shox/common/widgets/toast_widget.dart';

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
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const DeleteAccountHeader(),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: AppSpacing.xxl.r),
                        child: Column(
                          spacing: 16.h,
                          children: [
                            const DeleteAccountConsequencesCard(),
                            const DeleteAccountWarningBanner(),
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
        bool? backupChoice = await showBackupChoiceDialog(context);

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

  Widget _buildDeleteButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline,
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
          textColor: Colors.white,
          icon: MingCuteIcons.mgc_delete_2_line,
          iconSize: 20,
          onPressed: _deleteAccount,
        ),
      ),
    );
  }

  Widget _buildDeleteLoading() {
    return Container(
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
      child: LoaderWidget(
        width: 50.w,
        height: 50.h,
        icon: MingCuteIcons.mgc_eraser_line,
      ),
    );
  }
}
