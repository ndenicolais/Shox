import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/generated/l10n.dart';
import 'package:shox/models/shoes_model.dart';
import 'package:shox/services/shoes_service.dart';
import 'package:shox/utils/db_localized_values.dart';
import 'package:shox/widgets/custom_pie_chart.dart';

class DatabasePage extends StatefulWidget {
  const DatabasePage({super.key});

  @override
  DatabasePageState createState() => DatabasePageState();
}

class DatabasePageState extends State<DatabasePage>
    with SingleTickerProviderStateMixin {
  final ShoesService _firebaseService = ShoesService();
  bool _isLoading = true;
  late AnimationController _loadingController;
  int _totalShoesCount = 0;
  Map<String, int> _brandCounts = {};
  Map<String, int> _colorCounts = {};
  Map<String, int> _categoryCounts = {};
  Map<String, int> _typeCounts = {};

  @override
  void initState() {
    super.initState();
    _fetchData();
    _loadingController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  Future<void> _fetchData() async {
    List<Shoes> shoesList = await _firebaseService.getShoes();
    int totalShoesCount = shoesList.length;
    Map<String, int> colorCounts =
        await _firebaseService.getShoesCountByColor();
    Map<String, int> brandCounts =
        await _firebaseService.getShoesCountByBrand();
    Map<String, int> categoryCounts =
        await _firebaseService.getShoesCountByCategory();
    Map<String, int> typeCounts = await _firebaseService.getShoesCountByType();

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

  @override
  void dispose() {
    _loadingController.dispose();
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
        actions: [
          IconButton(
            icon: Icon(
              MingCuteIcons.mgc_file_export_fill,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () {},
          ),
        ],
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
      body: _isLoading
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
                        Text(
                          '${S.current.database_shoes} $_totalShoesCount',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontFamily: 'CustomFont',
                            fontSize: 34.r,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _buildColorPieChart(context),
                        _buildBrandPieChart(),
                        _buildCategoryPieChart(),
                        _buildTypePieChart(),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildColorPieChart(BuildContext context) {
    List<ColorChartData> chartData = _colorCounts.entries.map(
      (entry) {
        Color color = Color(int.parse(entry.key, radix: 16) + 0xFF000000);
        String colorName = DbLocalizedValues.getColorName(color, context);
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
              DbLocalizedValues.getCategoryName(entry.key, context),
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
              DbLocalizedValues.getTypeName(entry.key, context),
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
