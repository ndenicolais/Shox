import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shox/theme/app_spacing.dart';
import 'package:shox/theme/app_font_sizes.dart';
import 'package:shox/theme/app_radius.dart';

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

class ShoesPieChart<T> extends StatefulWidget {
  final List<T> chartData;
  final String title;
  final String Function(T data) xValueMapper;
  final double Function(T data) yValueMapper;
  final Color Function(T data, int index)? pointColorMapper;

  const ShoesPieChart({
    required this.chartData,
    required this.title,
    required this.xValueMapper,
    required this.yValueMapper,
    this.pointColorMapper,
    super.key,
  });

  @override
  State<ShoesPieChart<T>> createState() => _ShoesPieChartState<T>();
}

class _ShoesPieChartState<T> extends State<ShoesPieChart<T>> {
  int touchedIndex = -1;
  Set<Color> usedColors = {};

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.xxs.w),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.s.w,
          vertical: AppSpacing.m.h,
        ),
        child: Column(
          children: [
            Text(
              widget.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              textAlign: TextAlign.center,
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                final double side = constraints.maxWidth.clamp(240.0, 340.0);
                return SizedBox(
                  width: side,
                  height: side,
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
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 1,
                      centerSpaceRadius: side * 0.05,
                      sections: _generateSections(side),
                    ),
                  ),
                );
              },
            ),
            _buildLegend(context),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _generateSections(double side) {
    final sortedData = List<T>.from(widget.chartData);
    sortedData.sort(
      (a, b) => widget.yValueMapper(b).compareTo(widget.yValueMapper(a)),
    );

    return sortedData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? AppFontSizes.regular : AppFontSizes.small;
      final radius = isTouched ? side * 0.26 : side * 0.22;
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
        titleStyle: TextStyle(
          fontFamily: 'CustomFontBold',
          fontSize: fontSize,
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
      (a, b) => widget.yValueMapper(b).compareTo(widget.yValueMapper(a)),
    );

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
          padding:
              EdgeInsets.symmetric(horizontal: AppSpacing.s.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(15),
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 12.h,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 6.w),
              Flexible(
                child: Text(
                  '$label (${value.toInt()})',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
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
