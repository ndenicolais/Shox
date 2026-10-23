import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/common/widgets/app_bar_widget.dart';
import 'package:shox/common/widgets/button_widget.dart';
import 'package:shox/common/widgets/progress_overlay_widget.dart';
import 'package:shox/common/widgets/responsive_center_widget.dart';
import 'package:shox/common/widgets/toast_widget.dart';
import 'package:shox/features/data_management/controller/backup_controller.dart';
import 'package:shox/features/data_management/models/shoes_backup.dart';
import 'package:shox/features/data_management/widgets/restore_backup_dialog.dart';
import 'package:shox/features/database/controller/database_controller.dart';
import 'package:shox/features/database/services/pdf_service.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:shox/theme/app_radius.dart';
import 'package:shox/theme/app_spacing.dart';

/// Backup, restore and export of the shoes collection.
class DataManagementScreen extends StatefulWidget {
  const DataManagementScreen({super.key});

  @override
  State<DataManagementScreen> createState() => _DataManagementScreenState();
}

class _DataManagementScreenState extends State<DataManagementScreen> {
  final Logger _logger = Logger();
  final BackupController _backupController = Get.find<BackupController>();
  final DatabaseController _databaseController = Get.find<DatabaseController>();

  /// Non-null while an operation runs: shows the progress overlay and
  /// disables the buttons.
  double? _progress;

  bool get _isBusy => _progress != null;

  void _setProgress(double? value) {
    if (mounted) setState(() => _progress = value);
  }

  // ========== ACTIONS ==========

  Future<void> _createBackup() async {
    final l10n = AppLocalizations.of(context)!;
    _setProgress(0);
    try {
      final saved =
          await _backupController.createBackup(onProgress: _setProgress);
      if (!mounted) return;
      showSuccessToast(
        context,
        l10n.data_management_backup_success(saved.location),
      );
      if (saved.missingImages > 0) {
        showErrorToast(
          context,
          l10n.data_management_backup_missing_photos(saved.missingImages),
        );
      }
      _setProgress(null);
      await _backupController.shareFile(saved.filePath);
    } catch (e) {
      _logger.e('Backup failed: $e');
      if (mounted) showErrorToast(context, l10n.data_management_backup_error);
    } finally {
      _setProgress(null);
    }
  }

  Future<void> _restoreBackup() async {
    final l10n = AppLocalizations.of(context)!;

    final picked = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['zip', 'json'],
    );
    if (picked == null || !mounted) return;

    final ShoesBackup backup;
    final int currentCount;
    try {
      backup = _backupController.readBackup(await picked.readAsBytes());
      currentCount = await _backupController.currentShoesCount();
    } on BackupFormatException catch (e) {
      _logger.w('Invalid backup: $e');
      if (mounted) {
        showErrorToast(
          context,
          e.code == 'unsupported_version'
              ? l10n.data_management_restore_unsupported
              : l10n.data_management_restore_invalid,
        );
      }
      return;
    } catch (e) {
      _logger.e('Could not read backup: $e');
      if (mounted) showErrorToast(context, l10n.data_management_restore_error);
      return;
    }
    if (!mounted) return;

    final confirmed = await showRestoreBackupDialog(
      context,
      backup: backup,
      currentCount: currentCount,
    );
    if (!confirmed || !mounted) return;

    _setProgress(0);
    try {
      final result = await _backupController.restoreBackup(
        backup,
        onProgress: _setProgress,
      );
      if (!mounted) return;
      showSuccessToast(
        context,
        l10n.data_management_restore_success(result.restoredCount),
      );
      if (result.missingImages > 0) {
        showErrorToast(
          context,
          l10n.data_management_restore_missing_photos(result.missingImages),
        );
      }
    } catch (e) {
      _logger.e('Restore failed: $e');
      if (mounted) showErrorToast(context, l10n.data_management_restore_error);
    } finally {
      _setProgress(null);
    }
  }

  Future<void> _exportPdf() async {
    final l10n = AppLocalizations.of(context)!;
    _setProgress(0);
    try {
      final filePath = await PdfService(context, _databaseController)
          .generateShoesPdf(context, _setProgress);
      if (!mounted) return;
      showSuccessToast(context, l10n.database_screen_pdf_confirm);
      _setProgress(null);
      await _backupController.shareFile(filePath);
    } catch (e) {
      _logger.e('PDF export failed: $e');
      if (mounted) showErrorToast(context, l10n.database_screen_pdf_error);
    } finally {
      _setProgress(null);
    }
  }

  // ========== UI ==========

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PopScope(
      canPop: !_isBusy,
      child: Scaffold(
        appBar: AppBarWidget(title: l10n.data_management_title),
        body: Stack(
          children: [
            SafeArea(
              child: ResponsiveCenterWidget(
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.l),
                  children: [
                    _buildSection(
                      context,
                      icon: MingCuteIcons.mgc_safe_box_line,
                      title: l10n.data_management_backup_title,
                      text: l10n.data_management_backup_text,
                      footer: Obx(() => _buildLastBackup(context)),
                      button: ButtonWidget(
                        text: l10n.data_management_backup_button,
                        icon: MingCuteIcons.mgc_save_2_line,
                        onPressed: _isBusy ? null : _createBackup,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s),
                    _buildSection(
                      context,
                      icon: MingCuteIcons.mgc_history_line,
                      title: l10n.data_management_restore_title,
                      text: l10n.data_management_restore_text,
                      button: ButtonWidget(
                        text: l10n.data_management_restore_button,
                        icon: MingCuteIcons.mgc_file_import_line,
                        isOutline: true,
                        onPressed: _isBusy ? null : _restoreBackup,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s),
                    _buildSection(
                      context,
                      icon: MingCuteIcons.mgc_pdf_line,
                      title: l10n.data_management_export_title,
                      text: l10n.data_management_export_text,
                      button: ButtonWidget(
                        text: l10n.database_screen_pdf_download,
                        icon: MingCuteIcons.mgc_file_export_line,
                        isOutline: true,
                        onPressed: _isBusy ? null : _exportPdf,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_progress != null)
              Positioned.fill(
                child: ProgressOverlayWidget(progress: _progress!),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLastBackup(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final lastBackupAt = _backupController.lastBackupAt.value;
    final locale = Localizations.localeOf(context).toString();
    return Text(
      lastBackupAt == null
          ? l10n.data_management_never_backed_up
          : l10n.data_management_last_backup(
              DateFormat.yMMMMd(locale).add_Hm().format(lastBackupAt),
            ),
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String text,
    required Widget button,
    Widget? footer,
  }) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                  ),
                  child: Icon(icon, color: theme.colorScheme.onSurface),
                ),
                const SizedBox(width: AppSpacing.m),
                Expanded(
                  child: Text(title, style: theme.textTheme.titleMedium),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (footer != null) ...[
              const SizedBox(height: AppSpacing.xs),
              footer,
            ],
            const SizedBox(height: AppSpacing.m),
            SizedBox(width: double.infinity, child: button),
          ],
        ),
      ),
    );
  }
}
