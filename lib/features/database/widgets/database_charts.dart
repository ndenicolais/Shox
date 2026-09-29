import 'package:flutter/material.dart';
import 'package:shox/core/utils/db_localized_values.dart';
import 'package:shox/features/database/widgets/chart_colors.dart';
import 'package:shox/features/database/widgets/shoes_pie_chart.dart';
import 'package:shox/l10n/app_localizations.dart';

// Pie charts of the database screen, one per statistic.

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
