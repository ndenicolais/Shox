import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieChartData {
  final String label;
  final double value;
  final Color color;

  PieChartData(this.label, this.value, {required this.color});
}

class ColorChartData {
  final String colorHex;
  final double count;
  final Color color;

  ColorChartData(this.colorHex, this.count, this.color);
}

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
        SizedBox(height: 20.h),
        Text(
          title,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          width: 350.w,
          height: 400.h,
          child: SfCircularChart(
            legend: Legend(
              isVisible: true,
              position: LegendPosition.bottom,
              height: '40%',
              textStyle: GoogleFonts.montserrat(
                color: Theme.of(context).colorScheme.tertiary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
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
                  textStyle: GoogleFonts.montserrat(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
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
