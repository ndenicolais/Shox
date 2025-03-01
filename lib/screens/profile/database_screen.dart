import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shox/models/shoes_model.dart';
import 'package:shox/services/database_service.dart';
import 'package:shox/services/pdf_service.dart';
import 'package:shox/services/shoes_service.dart';
import 'package:shox/theme/app_colors.dart';
import 'package:shox/utils/db_localized_values.dart';
import 'package:shox/utils/permission_helper.dart';
import 'package:shox/widgets/custom_loader.dart';
import 'package:shox/widgets/custom_pie_chart.dart';
import 'package:shox/widgets/custom_toast_bar.dart';

class DatabaseScreen extends StatefulWidget {
  const DatabaseScreen({super.key});

  @override
  DatabaseScreenState createState() => DatabaseScreenState();
}

class DatabaseScreenState extends State<DatabaseScreen>
    with TickerProviderStateMixin {
  var logger = Logger();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final ShoesService _shoesService = ShoesService();
  final DatabaseService _databaseService = DatabaseService();
  late final PdfService _pdfService;
  late AnimationController _loadingController;
  bool _isLoading = true;
  late AnimationController _loadingPdfController;
  bool _isPdfLoading = false;
  bool _isJSONLoading = false;
  double _downloadProgress = 0.0;
  int _totalShoesCount = 0;
  Map<String, int> _brandCounts = {};
  Map<String, int> _colorCounts = {};
  Map<String, int> _categoryCounts = {};
  Map<String, int> _typeCounts = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.r),
            child: _isLoading
                ? _buildLoadingIndicator(context)
                : _totalShoesCount == 0
                    ? _buildDatabaseEmpty(context)
                    : SingleChildScrollView(
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              _buildDatabaseInfo(context),
                              _buildColorPieChart(context),
                              _buildBrandPieChart(),
                              _buildCategoryPieChart(),
                              _buildTypePieChart(),
                            ],
                          ),
                        ),
                      ),
          ),
          if (_isPdfLoading)
            Positioned.fill(
              child: _buildPDFLoading(context),
            ),
          if (_isJSONLoading)
            Positioned.fill(
              child: _buildJSONLoading(context),
            ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _pdfService = PdfService(context, _databaseService);
    _fetchData();
    _loadingController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
    _loadingPdfController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  Future<void> _fetchData() async {
    List<ShoesModel> shoesList = await _databaseService.getShoes();
    int totalShoesCount = shoesList.length;
    Map<String, int> colorCounts =
        await _databaseService.getShoesCountByColor();
    Map<String, int> brandCounts =
        await _databaseService.getShoesCountByBrand();
    Map<String, int> categoryCounts =
        await _databaseService.getShoesCountByCategory();
    Map<String, int> typeCounts = await _databaseService.getShoesCountByType();

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
            context, AppLocalizations.of(context)!.database_screen_pdf_confirm);
      }

      await Future.delayed(const Duration(milliseconds: 1400));
      await _sharePdf(filePath);
    } catch (e) {
      if (context.mounted) {
        showErrorToast(
            context, AppLocalizations.of(context)!.database_screen_pdf_error);
      }
    } finally {
      setState(() {
        _isPdfLoading = false;
      });
    }
  }

  Future<void> _sharePdf(String filePath) async {
    final xFile = XFile(filePath);
    await Share.shareXFiles([xFile]);
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

      final jsonCodes = await _shoesService.exportCodesToJson();
      final directory = Directory('/storage/emulated/0/Download');
      final now = DateTime.now();
      final dateFormat = DateFormat('yyyyMMdd_HHmmss');
      final formattedDate = dateFormat.format(now);
      final filePath = '${directory.path}/shox_db_$formattedDate.json';
      final file = File(filePath);
      await file.writeAsString(jsonCodes);
      if (context.mounted) {
        showSuccessToast(context,
            AppLocalizations.of(context)!.database_screen_export_success);
      }
    } catch (e) {
      if (context.mounted) {
        showErrorToast(context,
            '${AppLocalizations.of(context)!.database_screen_export_error} $e');
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
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        String jsonCodes = await file.readAsString();
        await _shoesService.importCodesFromJson(jsonCodes, currentUser!.uid);
        if (context.mounted) {
          showSuccessToast(context,
              AppLocalizations.of(context)!.database_screen_import_success);
        }
      }
    } catch (e) {
      if (context.mounted) {
        showErrorToast(context,
            '${AppLocalizations.of(context)!.database_screen_import_error} $e');
      }
    } finally {
      setState(() {
        _isJSONLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _loadingController.dispose();
    _loadingPdfController.dispose();
    super.dispose();
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          MingCuteIcons.mgc_large_arrow_left_fill,
          color: Theme.of(context).colorScheme.secondary,
        ),
        onPressed: () {
          Get.back();
        },
      ),
      title: Text(
        AppLocalizations.of(context)!.database_screen_title,
        style: GoogleFonts.montserrat(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.secondary,
      actions: [
        _buildPopupMenu(context),
      ],
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    return PopupMenuButton<String>(
      color: Theme.of(context).colorScheme.primary,
      icon: Icon(
        MingCuteIcons.mgc_more_2_fill,
        color: Theme.of(context).colorScheme.secondary,
      ),
      onSelected: (String result) {
        switch (result) {
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
            style: GoogleFonts.montserrat(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return Center(
      child: CustomLoader(
        width: 50.w,
        height: 50.h,
      ),
    );
  }

  Widget _buildDatabaseEmpty(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 260.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              MingCuteIcons.mgc_package_line,
              size: 80.sp,
              color: Theme.of(context).colorScheme.secondary,
            ),
            Text(
              AppLocalizations.of(context)!.database_screen_empty,
              style: GoogleFonts.montserrat(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 22.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPdfLoadingIndicator(BuildContext context) {
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
              style: GoogleFonts.montserrat(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatabaseInfo(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20.h,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${AppLocalizations.of(context)!.database_screen_shoes} : ',
                  style: GoogleFonts.montserrat(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '$_totalShoesCount',
                  style: GoogleFonts.montserrat(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 24.sp,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 240.w,
              height: 60.h,
              child: MaterialButton(
                onPressed: () {
                  _generatePdf(context);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.r),
                ),
                color: Theme.of(context).colorScheme.primary,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      MingCuteIcons.mgc_pdf_fill,
                      color: Theme.of(context).colorScheme.tertiary,
                      size: 24.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      AppLocalizations.of(context)!
                          .database_screen_pdf_download,
                      style: GoogleFonts.montserrat(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontSize: 24.sp,
                      ),
                    ),
                  ],
                ),
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
      child: Center(child: _buildPdfLoadingIndicator(context)),
    );
  }

  Widget _buildJSONLoading(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.5),
      child: Center(child: _buildLoadingIndicator(context)),
    );
  }

  Widget _buildColorPieChart(BuildContext context) {
    List<ColorChartData> chartData = _colorCounts.entries.map(
      (entry) {
        Color color = Color(int.parse(entry.key, radix: 16) + 0xFF000000);
        String colorName = DbLocalizedValues.getColorName(context, color);
        return ColorChartData(colorName, entry.value.toDouble(), color);
      },
    ).toList();

    return ColorPieChartWidget(chartData);
  }

  Widget _buildBrandPieChart() {
    Map<String, double> chartData =
        _brandCounts.map((key, value) => MapEntry(key, value.toDouble()));

    return BrandPieChartWidget(chartData);
  }

  Widget _buildCategoryPieChart() {
    Map<String, double> chartData =
        _categoryCounts.map((key, value) => MapEntry(key, value.toDouble()));

    return CategoryPieChartWidget(chartData);
  }

  Widget _buildTypePieChart() {
    Map<String, double> chartData =
        _typeCounts.map((key, value) => MapEntry(key, value.toDouble()));

    return TypePieChartWidget(chartData);
  }
}

class ColorPieChartWidget extends StatelessWidget {
  final List<ColorChartData> chartData;

  const ColorPieChartWidget(this.chartData, {super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPieChartWidget<ColorChartData>(
      chartData: chartData,
      title: AppLocalizations.of(context)!.database_screen_colors,
      xValueMapper: (data) => data.colorHex,
      yValueMapper: (data) => data.count,
      pointColorMapper: (data, _) => data.color,
    );
  }
}

class BrandPieChartWidget extends StatelessWidget {
  final Map<String, double> chartData;

  const BrandPieChartWidget(this.chartData, {super.key});

  @override
  Widget build(BuildContext context) {
    List<Color> shuffledColors = List.from(softColors)..shuffle();
    List<PieChartData> data = chartData.entries.toList().asMap().entries.map(
      (entry) {
        int index = entry.key;
        var entryData = entry.value;
        return PieChartData(
          entryData.key,
          entryData.value,
          color: shuffledColors[index % shuffledColors.length],
        );
      },
    ).toList();

    return CustomPieChartWidget<PieChartData>(
      chartData: data,
      title: AppLocalizations.of(context)!.database_screen_brands,
      xValueMapper: (data) => data.label,
      yValueMapper: (data) => data.value,
      pointColorMapper: (data, _) => data.color,
    );
  }
}

class CategoryPieChartWidget extends StatelessWidget {
  final Map<String, double> chartData;

  const CategoryPieChartWidget(this.chartData, {super.key});

  @override
  Widget build(BuildContext context) {
    List<Color> shuffledColors = List.from(softColors)..shuffle();
    List<PieChartData> data = chartData.entries.toList().asMap().entries.map(
      (entry) {
        int index = entry.key;
        var entryData = entry.value;
        return PieChartData(
          DbLocalizedValues.getCategoryName(context, entryData.key),
          entryData.value,
          color: shuffledColors[index % shuffledColors.length],
        );
      },
    ).toList();

    return CustomPieChartWidget<PieChartData>(
      chartData: data,
      title: AppLocalizations.of(context)!.database_screen_categories,
      xValueMapper: (data) => data.label,
      yValueMapper: (data) => data.value,
      pointColorMapper: (data, _) => data.color,
    );
  }
}

class TypePieChartWidget extends StatelessWidget {
  final Map<String, double> chartData;

  const TypePieChartWidget(this.chartData, {super.key});

  @override
  Widget build(BuildContext context) {
    List<Color> shuffledColors = List.from(softColors)..shuffle();
    List<PieChartData> data = chartData.entries.toList().asMap().entries.map(
      (entry) {
        int index = entry.key;
        var entryData = entry.value;
        return PieChartData(
          DbLocalizedValues.getTypeName(context, entryData.key),
          entryData.value,
          color: shuffledColors[index % shuffledColors.length],
        );
      },
    ).toList();

    return CustomPieChartWidget<PieChartData>(
      chartData: data,
      title: AppLocalizations.of(context)!.database_screen_types,
      xValueMapper: (data) => data.label,
      yValueMapper: (data) => data.value,
      pointColorMapper: (data, _) => data.color,
    );
  }
}
