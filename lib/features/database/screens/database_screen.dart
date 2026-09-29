import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shox/theme/app_spacing.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/common/widgets/app_bar_widget.dart';
import 'package:shox/common/widgets/empty_state_widget.dart';
import 'package:shox/features/database/controller/database_controller.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';
import 'package:shox/features/database/services/pdf_service.dart';
import 'package:shox/features/database/widgets/chart_colors.dart';
import 'package:shox/core/utils/db_localized_values.dart';
import 'package:shox/core/utils/permission_helper.dart';
import 'package:shox/common/widgets/loader_widget.dart';
import 'package:shox/features/database/widgets/shoes_pie_chart.dart';
import 'package:shox/common/widgets/toast_widget.dart';
import 'package:shox/theme/app_font_sizes.dart';
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
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.screen.r,
              vertical: AppSpacing.l.r,
            ),
            child: _isLoading
                ? LoaderWidget(width: 25.w, height: 25.h)
                : _totalShoesCount == 0
                    ? EmptyStateWidget(
                        message:
                            AppLocalizations.of(context)!.database_screen_empty,
                        icon: MingCuteIcons.mgc_package_line,
                        iconColor: Theme.of(context).colorScheme.secondary,
                      )
                    : SingleChildScrollView(
                        child: Center(
                          child: Column(
                            spacing: 10.h,
                            children: <Widget>[
                              _buildColorPieChart(),
                              _buildBrandPieChart(),
                              _buildCategoryPieChart(),
                              _buildTypePieChart(),
                            ],
                          ),
                        ),
                      ),
          ),
          if (_isPdfLoading) Positioned.fill(child: _buildPDFLoading(context)),
          if (_isJSONLoading)
            Positioned.fill(child: _buildJSONLoading(context)),
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

  Widget _buildPopupMenu(BuildContext context) {
    return PopupMenuButton<String>(
      color: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      icon: Icon(
        MingCuteIcons.mgc_more_2_line,
        color: Theme.of(context).colorScheme.secondary,
      ),
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
          Icon(
            icon,
            color: Theme.of(context).colorScheme.secondary,
          ),
          SizedBox(width: 10.w),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'CustomFontBold',
              color: Theme.of(context).colorScheme.secondary,
              fontSize: AppFontSizes.small,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPdfLoadingIndicator() {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 100.w,
              height: 100.h,
              child: CircularProgressIndicator(
                value: _downloadProgress,
                strokeWidth: 4.w,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            Text(
              '${(_downloadProgress * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                fontFamily: 'CustomFontBold',
                color: Theme.of(context).colorScheme.secondary,
                fontSize: AppFontSizes.medium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPDFLoading(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.5),
      child: Center(child: _buildPdfLoadingIndicator()),
    );
  }

  Widget _buildJSONLoading(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.5),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 100.w,
              height: 100.h,
              child: CircularProgressIndicator(
                value: _importProgress,
                strokeWidth: 4.w,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            Text(
              '${(_importProgress * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                fontFamily: 'CustomFontBold',
                color: Theme.of(context).colorScheme.secondary,
                fontSize: AppFontSizes.medium,
              ),
            ),
          ],
        ),
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

class ColorPieChart extends StatelessWidget {
  final List<ColorChartData> chartData;

  const ColorPieChart(this.chartData, {super.key});

  @override
  Widget build(BuildContext context) {
    return ShoesPieChart<ColorChartData>(
      chartData: chartData,
      title: AppLocalizations.of(context)!.database_screen_colors,
      xValueMapper: (data) => data.colorHex,
      yValueMapper: (data) => data.count,
      pointColorMapper: (data, _) => data.color,
    );
  }
}

class BrandPieChart extends StatelessWidget {
  final Map<String, double> chartData;

  const BrandPieChart(this.chartData, {super.key});

  @override
  Widget build(BuildContext context) {
    List<Color> shuffledColors = List.from(softColors)..shuffle();
    List<ChartData> data = chartData.entries.toList().asMap().entries.map(
      (entry) {
        int index = entry.key;
        var entryData = entry.value;
        return ChartData(
          entryData.key,
          entryData.value,
          color: shuffledColors[index % shuffledColors.length],
        );
      },
    ).toList();

    return ShoesPieChart<ChartData>(
      chartData: data,
      title: AppLocalizations.of(context)!.database_screen_brands,
      xValueMapper: (data) => data.label,
      yValueMapper: (data) => data.value,
      pointColorMapper: (data, _) => data.color,
    );
  }
}

class CategoryPieChart extends StatelessWidget {
  final Map<String, double> chartData;

  const CategoryPieChart(this.chartData, {super.key});

  @override
  Widget build(BuildContext context) {
    List<Color> shuffledColors = List.from(softColors)..shuffle();
    List<ChartData> data = chartData.entries.toList().asMap().entries.map(
      (entry) {
        int index = entry.key;
        var entryData = entry.value;
        return ChartData(
          DbLocalizedValues.getCategoryName(context, entryData.key),
          entryData.value,
          color: shuffledColors[index % shuffledColors.length],
        );
      },
    ).toList();

    return ShoesPieChart<ChartData>(
      chartData: data,
      title: AppLocalizations.of(context)!.database_screen_categories,
      xValueMapper: (data) => data.label,
      yValueMapper: (data) => data.value,
      pointColorMapper: (data, _) => data.color,
    );
  }
}

class TypePieChart extends StatelessWidget {
  final Map<String, double> chartData;

  const TypePieChart(this.chartData, {super.key});

  @override
  Widget build(BuildContext context) {
    List<Color> shuffledColors = List.from(softColors)..shuffle();
    List<ChartData> data = chartData.entries.toList().asMap().entries.map(
      (entry) {
        int index = entry.key;
        var entryData = entry.value;
        return ChartData(
          DbLocalizedValues.getTypeName(context, entryData.key),
          entryData.value,
          color: shuffledColors[index % shuffledColors.length],
        );
      },
    ).toList();

    return ShoesPieChart<ChartData>(
      chartData: data,
      title: AppLocalizations.of(context)!.database_screen_types,
      xValueMapper: (data) => data.label,
      yValueMapper: (data) => data.value,
      pointColorMapper: (data, _) => data.color,
    );
  }
}
