import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/shoes/shoes_model.dart';
import 'package:shox/shoes/shoes_service.dart';
import 'package:shox/utils/utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
                  size: 50,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            )
          : _totalShoesCount == 0
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No shoes',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 24,
                          fontFamily: 'CustomFont',
                        ),
                      ),
                      Icon(
                        MingCuteIcons.mgc_package_line,
                        size: 60,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      Text(
                        'in the box',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 24,
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
                          'Shoes: $_totalShoesCount',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontFamily: 'CustomFont',
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _buildPieChartColor(),
                        _buildBrandPieChart(),
                        _buildCategoryPieChart(),
                        _buildTypePieChart(),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildPieChartColor() {
    List<ColorChartData> chartData = _colorCounts.entries.map(
      (entry) {
        Color color = Color(int.parse(entry.key, radix: 16) + 0xFF000000);
        String colorName = colorNames[entry.key.toUpperCase()] ?? 'Unknown';
        return ColorChartData(colorName, entry.value, color);
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
    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          'Colors',
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontFamily: 'CustomFont',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 400,
          width: 400,
          child: SfCircularChart(
            legend: Legend(
              isVisible: true,
              position: LegendPosition.bottom,
              height: '40%',
              textStyle: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontFamily: 'CustomFont',
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              overflowMode: LegendItemOverflowMode.wrap,
            ),
            series: <PieSeries<ColorChartData, String>>[
              PieSeries<ColorChartData, String>(
                dataSource: chartData,
                xValueMapper: (ColorChartData data, _) => data.colorHex,
                yValueMapper: (ColorChartData data, _) => data.count,
                pointColorMapper: (ColorChartData data, _) => data.color,
                dataLabelMapper: (ColorChartData data, _) => '${data.count}',
                sortFieldValueMapper: (ColorChartData data, _) => data.count,
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  labelIntersectAction: LabelIntersectAction.shift,
                  labelPosition: ChartDataLabelPosition.outside,
                  textStyle: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontFamily: 'CustomFont',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  connectorLineSettings: const ConnectorLineSettings(
                    length: '10%',
                    type: ConnectorType.line,
                  ),
                ),
                sortingOrder: SortingOrder.descending,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BrandPieChartWidget extends StatelessWidget {
  final Map<String, double> chartData;

  const BrandPieChartWidget(this.chartData, {super.key});

  @override
  Widget build(BuildContext context) {
    Set<Color> usedColors = {};
    List<BrandChartData> data = chartData.entries
        .map((entry) => BrandChartData(entry.key, entry.value))
        .toList();

    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          'Brands',
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontFamily: 'CustomFont',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 400,
          width: 400,
          child: SfCircularChart(
            legend: Legend(
              isVisible: true,
              position: LegendPosition.bottom,
              height: '40%',
              textStyle: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontFamily: 'CustomFont',
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              overflowMode: LegendItemOverflowMode.wrap,
            ),
            series: <CircularSeries>[
              PieSeries<BrandChartData, String>(
                dataSource: data,
                xValueMapper: (BrandChartData data, _) => data.brand,
                yValueMapper: (BrandChartData data, _) => data.value,
                pointColorMapper: (BrandChartData data, int index) {
                  // Genera dinamicamente un colore per ogni categoria
                  Color color;
                  do {
                    color = getRandomColor();
                  } while (usedColors.contains(color));

                  usedColors.add(color);
                  return color;
                },
                sortFieldValueMapper: (BrandChartData data, _) => data.value,
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  labelIntersectAction: LabelIntersectAction.shift,
                  labelPosition: ChartDataLabelPosition.outside,
                  textStyle: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontFamily: 'CustomFont',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  connectorLineSettings: const ConnectorLineSettings(
                    length: '10%',
                    type: ConnectorType.line,
                  ),
                ),
                sortingOrder: SortingOrder.descending,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CategoryPieChartWidget extends StatelessWidget {
  final Map<String, double> chartData;

  const CategoryPieChartWidget(this.chartData, {super.key});

  @override
  Widget build(BuildContext context) {
    Set<Color> usedColors = {};
    List<CategoryChartData> data = chartData.entries
        .map((entry) => CategoryChartData(entry.key, entry.value))
        .toList();

    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          'Categories',
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontFamily: 'CustomFont',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 400,
          width: 400,
          child: SfCircularChart(
            legend: Legend(
              isVisible: true,
              position: LegendPosition.bottom,
              height: '40%',
              textStyle: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontFamily: 'CustomFont',
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              overflowMode: LegendItemOverflowMode.wrap,
            ),
            series: <CircularSeries>[
              PieSeries<CategoryChartData, String>(
                dataSource: data,
                pointColorMapper: (CategoryChartData data, _) {
                  // Genera dinamicamente un colore per ogni categoria
                  Color color;
                  do {
                    color = getRandomColor();
                  } while (usedColors.contains(color));

                  usedColors.add(color);
                  return color;
                },
                xValueMapper: (CategoryChartData data, _) => data.category,
                yValueMapper: (CategoryChartData data, _) => data.value,
                sortFieldValueMapper: (CategoryChartData data, _) => data.value,
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  labelIntersectAction: LabelIntersectAction.shift,
                  labelPosition: ChartDataLabelPosition.outside,
                  textStyle: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontFamily: 'CustomFont',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  connectorLineSettings: const ConnectorLineSettings(
                    length: '10%',
                    type: ConnectorType.line,
                  ),
                ),
                sortingOrder: SortingOrder.descending,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TypePieChartWidget extends StatelessWidget {
  final Map<String, double> chartData;

  const TypePieChartWidget(this.chartData, {super.key});

  @override
  Widget build(BuildContext context) {
    Set<Color> usedColors = {};
    List<TypeChartData> data = chartData.entries
        .map((entry) => TypeChartData(entry.key, entry.value))
        .toList();

    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          'Types',
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontFamily: 'CustomFont',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 400,
          width: 400,
          child: SfCircularChart(
            legend: Legend(
              isVisible: true,
              position: LegendPosition.bottom,
              height: '40%',
              textStyle: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontFamily: 'CustomFont',
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              overflowMode: LegendItemOverflowMode.wrap,
            ),
            series: <CircularSeries>[
              PieSeries<TypeChartData, String>(
                dataSource: data,
                pointColorMapper: (TypeChartData data, _) {
                  // Genera dinamicamente un colore per ogni categoria
                  Color color;
                  do {
                    color = getRandomColor();
                  } while (usedColors.contains(color));

                  usedColors.add(color);
                  return color;
                },
                xValueMapper: (TypeChartData data, _) => data.type,
                yValueMapper: (TypeChartData data, _) => data.value,
                sortFieldValueMapper: (TypeChartData data, _) => data.value,
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  labelIntersectAction: LabelIntersectAction.shift,
                  labelPosition: ChartDataLabelPosition.outside,
                  textStyle: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontFamily: 'CustomFont',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  connectorLineSettings: const ConnectorLineSettings(
                    length: '10%',
                    type: ConnectorType.line,
                  ),
                ),
                sortingOrder: SortingOrder.descending,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ColorChartData {
  final String colorHex;
  final int count;
  final Color color;

  ColorChartData(this.colorHex, this.count, this.color);
}

class BrandChartData {
  final String brand;
  final double value;

  BrandChartData(this.brand, this.value);
}

class CategoryChartData {
  final String category;
  final double value;

  CategoryChartData(this.category, this.value);
}

class TypeChartData {
  final String type;
  final double value;

  TypeChartData(this.type, this.value);
}

// Funzione per generare un colore casuale
Color getRandomColor() {
  Random random = Random();
  return Color.fromARGB(
    255,
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
  );
}
