import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// Generic data for the pie chart
class PieChartData {
  final String label;
  final double value;

  PieChartData(this.label, this.value);
}

// Specific data for the color pie chart
class ColorChartData {
  final String colorHex;
  final double count;
  final Color color;

  ColorChartData(this.colorHex, this.count, this.color);
}

// Reusable widget for pie chart
class CustomPieChartWidget<T> extends StatelessWidget {
  final List<T> chartData;
  final String title;
  final String Function(T data) xValueMapper;
  final double Function(T data) yValueMapper;
  final Color Function(T data, int index)? pointColorMapper;

  const CustomPieChartWidget({
    required this.chartData,
    required this.title,
    required this.xValueMapper,
    required this.yValueMapper,
    this.pointColorMapper,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Set<Color> usedColors = {};

    return Column(
      children: [
        20.verticalSpace,
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontFamily: 'CustomFont',
            fontSize: 24.r,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 400.r,
          width: 350.r,
          child: SfCircularChart(
            legend: Legend(
              isVisible: true,
              position: LegendPosition.bottom,
              height: '40%',
              textStyle: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontFamily: 'CustomFont',
                fontSize: 14.r,
                fontWeight: FontWeight.bold,
              ),
              overflowMode: LegendItemOverflowMode.wrap,
            ),
            series: <CircularSeries>[
              PieSeries<T, String>(
                dataSource: chartData,
                pointColorMapper: (T data, int index) {
                  if (pointColorMapper != null) {
                    return pointColorMapper!(data, index);
                  } else {
                    Color color;
                    do {
                      color = getRandomColor();
                    } while (usedColors.contains(color));

                    usedColors.add(color);
                    return color;
                  }
                },
                xValueMapper: (T data, _) => xValueMapper(data),
                yValueMapper: (T data, _) => yValueMapper(data),
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  labelIntersectAction: LabelIntersectAction.shift,
                  labelPosition: ChartDataLabelPosition.outside,
                  textStyle: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontFamily: 'CustomFont',
                    fontSize: 12.r,
                    fontWeight: FontWeight.bold,
                  ),
                  connectorLineSettings: const ConnectorLineSettings(
                    type: ConnectorType.curve,
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

  // Function to generate a random color
  Color getRandomColor() {
    Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }
}
