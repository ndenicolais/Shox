import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shox/theme/app_font_sizes.dart';

class ChartData {
  final String label;
  final double value;
  final Color color;

  ChartData(this.label, this.value, {required this.color});
}

class ColorChartData {
  final String colorHex;
  final double count;
  final Color color;

  ColorChartData(this.colorHex, this.count, this.color);
}

class PieChartWidget<T> extends StatefulWidget {
  final List<T> chartData;
  final String title;
  final String Function(T data) xValueMapper;
  final double Function(T data) yValueMapper;
  final Color Function(T data, int index)? pointColorMapper;

  const PieChartWidget({
    required this.chartData,
    required this.title,
    required this.xValueMapper,
    required this.yValueMapper,
    this.pointColorMapper,
    super.key,
  });

  @override
  State<PieChartWidget<T>> createState() => _PieChartWidgetState<T>();
}

class _PieChartWidgetState<T> extends State<PieChartWidget<T>> {
  int touchedIndex = -1;
  Set<Color> usedColors = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.title,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: AppFontSizes.large,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          width: 350.w,
          height: 280.h,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 1,
              centerSpaceRadius: 10,
              sections: _generateSections(),
            ),
          ),
        ),
        _buildLegend(context),
      ],
    );
  }

  List<PieChartSectionData> _generateSections() {
    final sortedData = List<T>.from(widget.chartData);
    sortedData.sort(
        (a, b) => widget.yValueMapper(b).compareTo(widget.yValueMapper(a)));

    return sortedData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? AppFontSizes.regular : AppFontSizes.small;
      final radius = isTouched ? 140.r : 120.r;
      final value = widget.yValueMapper(data);

      Color color;
      if (widget.pointColorMapper != null) {
        color = widget.pointColorMapper!(data, index);
      } else {
        do {
          color = getRandomColor();
        } while (usedColors.contains(color));
        usedColors.add(color);
      }

      return PieChartSectionData(
        color: color,
        value: value,
        title: '${value.toInt()}',
        radius: radius,
        titleStyle: GoogleFonts.montserrat(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            const Shadow(
              color: Colors.black,
              blurRadius: 6,
            ),
          ],
        ),
        titlePositionPercentageOffset: 0.8,
      );
    }).toList();
  }

  Widget _buildLegend(BuildContext context) {
    final sortedData = List<T>.from(widget.chartData);
    sortedData.sort(
        (a, b) => widget.yValueMapper(b).compareTo(widget.yValueMapper(a)));

    usedColors.clear();

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6.w,
      runSpacing: 8.h,
      children: sortedData.asMap().entries.map((entry) {
        final index = entry.key;
        final data = entry.value;
        final label = widget.xValueMapper(data);
        final value = widget.yValueMapper(data);

        Color color;
        if (widget.pointColorMapper != null) {
          color = widget.pointColorMapper!(data, index);
        } else {
          do {
            color = getRandomColor();
          } while (usedColors.contains(color));
          usedColors.add(color);
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 16.w,
                height: 16.h,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 6.w),
              Flexible(
                child: Text(
                  '$label (${value.toInt()})',
                  style: GoogleFonts.montserrat(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: AppFontSizes.extraSmall,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      }).toList(),
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
