import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shox/generated/l10n.dart';
import 'package:shox/models/shoes_model.dart';
import 'package:shox/services/database_service.dart';
import 'package:shox/services/shoes_service.dart';
import 'package:shox/theme/app_colors.dart';
import 'package:shox/utils/db_localized_values.dart';
import 'package:shox/widgets/custom_pie_chart.dart';
import 'package:shox/widgets/custom_toast_bar.dart';

class DatabasePage extends StatefulWidget {
  const DatabasePage({super.key});

  @override
  DatabasePageState createState() => DatabasePageState();
}

class DatabasePageState extends State<DatabasePage>
    with TickerProviderStateMixin {
  var logger = Logger();
  final ShoesService _firebaseShoesService = ShoesService();
  late final ShoesService _shoesService;
  late final DatabaseService _databaseService;
  late AnimationController _loadingPdfController;
  bool _isPdfLoading = false;
  late AnimationController _loadingController;
  bool _isLoading = true;
  int _totalShoesCount = 0;
  Map<String, int> _brandCounts = {};
  Map<String, int> _colorCounts = {};
  Map<String, int> _categoryCounts = {};
  Map<String, int> _typeCounts = {};

  @override
  void initState() {
    super.initState();
    _shoesService = ShoesService();
    _databaseService = DatabaseService(_shoesService);
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
    List<Shoes> shoesList = await _firebaseShoesService.getShoes();
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

  Color getColorFromHex(String hexColor, List<Color> colorList) {
    int colorIndex = int.parse(hexColor, radix: 16) % colorList.length;
    return colorList[colorIndex];
  }

  Future<void> requestStoragePermission() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      logger.e('Storage permission granted');
    } else if (status.isDenied) {
      logger.e('Storage permission denied');
    } else if (status.isPermanentlyDenied) {
      logger.e('Storage permission permanently denied');
    }
  }

  Future<void> _generatePdf() async {
    setState(() {
      _isPdfLoading = true;
    });

    try {
      await _databaseService.generateShoesPdf();
      _showConfirmToastBar();
    } catch (e) {
      _showErrorSnackBar();
    } finally {
      setState(() {
        _isPdfLoading = false;
      });
    }
  }

  void _showConfirmToastBar() {
    // Show confirm toastbar
    showCustomToastBar(
      context,
      position: DelightSnackbarPosition.bottom,
      color: AppColors.confirmColor,
      icon: const Icon(
        MingCuteIcons.mgc_check_2_fill,
      ),
      title: S.current.database_pdf_confirm,
    );
  }

  void _showErrorSnackBar() {
    // Show error toastbar
    showCustomToastBar(
      context,
      position: DelightSnackbarPosition.top,
      color: AppColors.errorColor,
      icon: const Icon(
        MingCuteIcons.mgc_warning_fill,
      ),
      title: S.current.database_pdf_error,
    );
  }

  @override
  void dispose() {
    _loadingController.dispose();
    _loadingPdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          S.current.database_title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontWeight: FontWeight.bold,
            fontFamily: 'CustomFont',
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.secondary,
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.r, horizontal: 30.r),
            child: _isLoading
                ? Center(
                    child: AnimatedBuilder(
                      animation: _loadingController,
                      builder: (_, child) {
                        return Transform.rotate(
                          angle: _loadingController.value * 2.0 * 3.14159,
                          child: child,
                        );
                      },
                      child: Icon(
                        MingCuteIcons.mgc_shoe_fill,
                        size: 50.r,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  )
                : _totalShoesCount == 0
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              MingCuteIcons.mgc_package_line,
                              size: 80.r,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            Text(
                              S.current.database_empty,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 22.r,
                                fontFamily: 'CustomFont',
                              ),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${S.current.database_shoes} : ',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontFamily: 'CustomFont',
                                      fontSize: 28.r,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '$_totalShoesCount',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      fontFamily: 'CustomFontBold',
                                      fontSize: 28.r,
                                    ),
                                  ),
                                ],
                              ),
                              20.verticalSpace,
                              SizedBox(
                                width: 240.r,
                                height: 60.r,
                                child: MaterialButton(
                                  onPressed: _generatePdf,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.r),
                                  ),
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        MingCuteIcons.mgc_file_download_fill,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        size: 24.r,
                                      ),
                                      SizedBox(width: 8.r),
                                      Text(
                                        S.current.database_pdf_download,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontSize: 24.r,
                                          fontFamily: 'CustomFont',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              20.verticalSpace,
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
            Container(
              color: Theme.of(context).colorScheme.tertiary.withOpacity(0.7),
              child: Center(
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.5, end: 1.5).animate(
                    CurvedAnimation(
                      parent: _loadingController,
                      curve: Curves.easeInOut,
                    ),
                  ),
                  child: Icon(
                    MingCuteIcons.mgc_file_download_fill,
                    size: 120.r,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildColorPieChart(BuildContext context) {
    List<ColorChartData> chartData = _colorCounts.entries.map(
      (entry) {
        Color color = Color(int.parse(entry.key, radix: 16) + 0xFF000000);
        String colorName = DbLocalizedValues.getColorName(color);
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

// Colors pie chart widget
class ColorPieChartWidget extends StatelessWidget {
  final List<ColorChartData> chartData;

  const ColorPieChartWidget(this.chartData, {super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPieChartWidget<ColorChartData>(
      chartData: chartData,
      title: S.current.database_colors,
      xValueMapper: (data) => data.colorHex,
      yValueMapper: (data) => data.count,
      pointColorMapper: (data, _) => data.color,
    );
  }
}

// Brands pie chart widget
class BrandPieChartWidget extends StatelessWidget {
  final Map<String, double> chartData;

  const BrandPieChartWidget(this.chartData, {super.key});

  @override
  Widget build(BuildContext context) {
    List<PieChartData> data = chartData.entries
        .map((entry) => PieChartData(entry.key, entry.value))
        .toList();

    return CustomPieChartWidget<PieChartData>(
      chartData: data,
      title: S.current.database_brands,
      xValueMapper: (data) => data.label,
      yValueMapper: (data) => data.value,
    );
  }
}

// Categories pie chart widget
class CategoryPieChartWidget extends StatelessWidget {
  final Map<String, double> chartData;

  const CategoryPieChartWidget(this.chartData, {super.key});

  @override
  Widget build(BuildContext context) {
    List<PieChartData> data = chartData.entries
        .map((entry) => PieChartData(
              DbLocalizedValues.getCategoryName(entry.key),
              entry.value,
            ))
        .toList();

    return CustomPieChartWidget<PieChartData>(
      chartData: data,
      title: S.current.database_categories,
      xValueMapper: (data) => data.label,
      yValueMapper: (data) => data.value,
    );
  }
}

// Types pie chart widget
class TypePieChartWidget extends StatelessWidget {
  final Map<String, double> chartData;

  const TypePieChartWidget(this.chartData, {super.key});

  @override
  Widget build(BuildContext context) {
    List<PieChartData> data = chartData.entries
        .map((entry) => PieChartData(
              DbLocalizedValues.getTypeName(entry.key),
              entry.value,
            ))
        .toList();

    return CustomPieChartWidget<PieChartData>(
      chartData: data,
      title: S.current.database_types,
      xValueMapper: (data) => data.label,
      yValueMapper: (data) => data.value,
    );
  }
}
