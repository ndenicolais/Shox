import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:shox/theme/app_spacing.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/common/widgets/app_bar_widget.dart';
import 'package:shox/common/widgets/info_tile_widget.dart';
import 'package:shox/common/widgets/progress_overlay_widget.dart';
import 'package:shox/features/database/widgets/database_charts.dart';
import 'package:shox/common/widgets/responsive_center_widget.dart';
import 'package:shox/common/widgets/empty_state_widget.dart';
import 'package:shox/features/database/controller/database_controller.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';
import 'package:shox/features/database/services/pdf_service.dart';
import 'package:shox/core/utils/db_localized_values.dart';
import 'package:shox/core/utils/permission_helper.dart';
import 'package:shox/common/widgets/loader_widget.dart';
import 'package:shox/features/database/widgets/shoes_pie_chart.dart';
import 'package:shox/common/widgets/toast_widget.dart';
import 'package:shox/theme/app_radius.dart';

class DatabaseScreen extends StatefulWidget {
  const DatabaseScreen({super.key});

  @override
  DatabaseScreenState createState() => DatabaseScreenState();
}

class DatabaseScreenState extends State<DatabaseScreen> {
  var logger = Logger();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final DatabaseController _databaseController = Get.find<DatabaseController>();
  late final PdfService _pdfService;
  bool _isLoading = true;
  bool _isPdfLoading = false;
  bool _isJSONLoading = false;
  double _downloadProgress = 0.0;
  double _importProgress = 0.0;
  int _totalShoesCount = 0;
  Map<String, int> _brandCounts = {};
  Map<String, int> _colorCounts = {};
  Map<String, int> _categoryCounts = {};
  Map<String, int> _typeCounts = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: AppLocalizations.of(context)!.database_screen_title,
        actions: [
          _buildPopupMenu(context),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: ResponsiveCenterWidget(
              child: _isLoading
                  ? const Center(child: LoaderWidget(width: 50, height: 50))
                  : _totalShoesCount == 0
                      ? EmptyStateWidget(
                          message: AppLocalizations.of(context)!
                              .database_screen_empty,
                          icon: MingCuteIcons.mgc_package_line,
                          iconColor: Theme.of(context).colorScheme.secondary,
                        )
                      : ListView(
                          padding: const EdgeInsets.all(AppSpacing.l),
                          children: [
                            _buildSummary(context),
                            const SizedBox(height: AppSpacing.m),
                            _buildColorPieChart(),
                            const SizedBox(height: AppSpacing.s),
                            _buildBrandPieChart(),
                            const SizedBox(height: AppSpacing.s),
                            _buildCategoryPieChart(),
                            const SizedBox(height: AppSpacing.s),
                            _buildTypePieChart(),
                          ],
                        ),
            ),
          ),
          if (_isPdfLoading)
            Positioned.fill(
              child: ProgressOverlayWidget(progress: _downloadProgress),
            ),
          if (_isJSONLoading)
            Positioned.fill(
              child: ProgressOverlayWidget(progress: _importProgress),
            ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _pdfService = PdfService(context, _databaseController);
    _fetchData();
  }

  Future<void> _fetchData() async {
    List<ShoesModel> shoesList = await _databaseController.getShoes();
    int totalShoesCount = shoesList.length;
    Map<String, int> colorCounts =
        await _databaseController.getShoesCountByColor();
    Map<String, int> brandCounts =
        await _databaseController.getShoesCountByBrand();
    Map<String, int> categoryCounts =
        await _databaseController.getShoesCountByCategory();
    Map<String, int> typeCounts =
        await _databaseController.getShoesCountByType();

    setState(
      () {
        _isLoading = false;
        _totalShoesCount = totalShoesCount;
        _colorCounts = colorCounts;
        _brandCounts = brandCounts;
        _categoryCounts = categoryCounts;
        _typeCounts = typeCounts;
      },
    );
  }

  Future<void> _generatePdf(BuildContext context) async {
    setState(() {
      _isPdfLoading = true;
      _downloadProgress = 0.0;
    });

    try {
      final filePath = await _pdfService.generateShoesPdf(context, (progress) {
        setState(() {
          _downloadProgress = progress;
        });
      });
      if (context.mounted) {
        showSuccessToast(
          context,
          AppLocalizations.of(context)!.database_screen_pdf_confirm,
        );
      }

      await Future.delayed(const Duration(milliseconds: 1400));
      await _sharePdf(filePath);
    } catch (e) {
      if (context.mounted) {
        showErrorToast(
          context,
          AppLocalizations.of(context)!.database_screen_pdf_error,
        );
      }
    } finally {
      setState(() {
        _isPdfLoading = false;
      });
    }
  }

  Future<void> _sharePdf(String filePath) async {
    final success = await _databaseController.shareFile(filePath);
    if (!success && mounted) {
      showErrorToast(
        context,
        AppLocalizations.of(context)!.database_screen_pdf_error,
      );
    }
  }

  Future<void> _exportShoes(BuildContext context) async {
    setState(() {
      _isJSONLoading = true;
    });

    try {
      String permissionStatus =
          await requestManageExternalStoragePermission(context);
      if (permissionStatus != 'Permission granted') {
        throw Exception('Permission not granted');
      }

      final result = await _databaseController.exportDatabase();

      if (context.mounted) {
        if (result.success) {
          showSuccessToast(
            context,
            AppLocalizations.of(context)!.database_screen_export_success,
          );
        } else {
          showErrorToast(
            context,
            '${AppLocalizations.of(context)!.database_screen_export_error} ${result.message}',
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        showErrorToast(
          context,
          '${AppLocalizations.of(context)!.database_screen_export_error} $e',
        );
      }
    } finally {
      setState(() {
        _isJSONLoading = false;
      });
    }
  }

  Future<void> _importShoes(BuildContext context) async {
    setState(() {
      _isJSONLoading = true;
      _importProgress = 0.0;
    });

    try {
      final result = await _databaseController.importDatabase(
        currentUser!.uid,
        onProgress: (progress) {
          setState(() {
            _importProgress = progress;
          });
        },
      );

      if (context.mounted) {
        if (result.success) {
          showSuccessToast(
            context,
            AppLocalizations.of(context)!.database_screen_import_success,
          );
          // Refresh data after import
          await _fetchData();
        } else if (!result.wasCancelled) {
          showErrorToast(
            context,
            '${AppLocalizations.of(context)!.database_screen_import_error} ${result.message}',
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        showErrorToast(
          context,
          '${AppLocalizations.of(context)!.database_screen_import_error} $e',
        );
      }
    } finally {
      setState(() {
        _isJSONLoading = false;
      });
    }
  }

  /// Totals shown above the charts.
  Widget _buildSummary(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: InfoTileWidget(
            label: l10n.user_screen_total_shoes,
            value: '$_totalShoesCount',
          ),
        ),
        const SizedBox(width: AppSpacing.s),
        Expanded(
          child: InfoTileWidget(
            label: l10n.database_screen_brands,
            value: '${_brandCounts.length}',
          ),
        ),
        const SizedBox(width: AppSpacing.s),
        Expanded(
          child: InfoTileWidget(
            label: l10n.database_screen_categories,
            value: '${_categoryCounts.length}',
          ),
        ),
      ],
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    return PopupMenuButton<String>(
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      icon: const Icon(MingCuteIcons.mgc_more_2_line),
      onSelected: (String result) {
        switch (result) {
          case 'pdf':
            _generatePdf(context);
            break;
          case 'export':
            _exportShoes(context);
            break;
          case 'import':
            _importShoes(context);
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        _buildPopupMenuItem(
          context,
          'pdf',
          MingCuteIcons.mgc_pdf_line,
          AppLocalizations.of(context)!.database_screen_pdf_download,
        ),
        _buildPopupMenuItem(
          context,
          'export',
          MingCuteIcons.mgc_file_export_line,
          AppLocalizations.of(context)!.database_screen_export_menu,
        ),
        _buildPopupMenuItem(
          context,
          'import',
          MingCuteIcons.mgc_file_import_line,
          AppLocalizations.of(context)!.database_screen_import_menu,
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(
    BuildContext context,
    String value,
    IconData icon,
    String text,
  ) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.onSurface),
          const SizedBox(width: AppSpacing.s),
          Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildColorPieChart() {
    List<ColorChartData> chartData = _colorCounts.entries.map(
      (entry) {
        Color color = Color(int.parse(entry.key, radix: 16) + 0xFF000000);
        String colorName = DbLocalizedValues.getColorName(context, color);
        return ColorChartData(colorName, entry.value.toDouble(), color);
      },
    ).toList();

    return ColorPieChart(chartData);
  }

  Widget _buildBrandPieChart() {
    Map<String, double> chartData =
        _brandCounts.map((key, value) => MapEntry(key, value.toDouble()));

    return BrandPieChart(chartData);
  }

  Widget _buildCategoryPieChart() {
    Map<String, double> chartData =
        _categoryCounts.map((key, value) => MapEntry(key, value.toDouble()));

    return CategoryPieChart(chartData);
  }

  Widget _buildTypePieChart() {
    Map<String, double> chartData =
        _typeCounts.map((key, value) => MapEntry(key, value.toDouble()));

    return TypePieChart(chartData);
  }
}
