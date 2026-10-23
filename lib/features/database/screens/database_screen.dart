import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:shox/theme/app_spacing.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/common/widgets/app_bar_widget.dart';
import 'package:shox/core/routes/app_routes.dart';
import 'package:shox/common/widgets/info_tile_widget.dart';
import 'package:shox/features/database/widgets/database_charts.dart';
import 'package:shox/common/widgets/responsive_center_widget.dart';
import 'package:shox/common/widgets/empty_state_widget.dart';
import 'package:shox/features/database/controller/database_controller.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';
import 'package:shox/core/utils/db_localized_values.dart';
import 'package:shox/common/widgets/loader_widget.dart';
import 'package:shox/features/database/widgets/shoes_pie_chart.dart';

class DatabaseScreen extends StatefulWidget {
  const DatabaseScreen({super.key});

  @override
  DatabaseScreenState createState() => DatabaseScreenState();
}

class DatabaseScreenState extends State<DatabaseScreen> {
  var logger = Logger();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final DatabaseController _databaseController = Get.find<DatabaseController>();
  bool _isLoading = true;
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
          IconButton(
            tooltip: AppLocalizations.of(context)!.data_management_title,
            icon: const Icon(MingCuteIcons.mgc_safe_box_line),
            onPressed: () => Get.toNamed(AppRoutes.dataManagement),
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: ResponsiveCenterWidget(
              child: _isLoading
                  ? const Center(child: LoaderWidget(width: 50, height: 50))
                  : _totalShoesCount == 0
                      ? EmptyStateWidget(
                          message: AppLocalizations.of(context)!
                              .database_screen_empty,
                          icon: MingCuteIcons.mgc_package_line,
                          iconColor: Theme.of(context).colorScheme.secondary,
                        )
                      : ListView(
                          padding: const EdgeInsets.all(AppSpacing.l),
                          children: [
                            _buildSummary(context),
                            const SizedBox(height: AppSpacing.m),
                            _buildColorPieChart(),
                            const SizedBox(height: AppSpacing.s),
                            _buildBrandPieChart(),
                            const SizedBox(height: AppSpacing.s),
                            _buildCategoryPieChart(),
                            const SizedBox(height: AppSpacing.s),
                            _buildTypePieChart(),
                          ],
                        ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
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

  /// Totals shown above the charts.
  Widget _buildSummary(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: InfoTileWidget(
            label: l10n.user_screen_total_shoes,
            value: '$_totalShoesCount',
          ),
        ),
        const SizedBox(width: AppSpacing.s),
        Expanded(
          child: InfoTileWidget(
            label: l10n.database_screen_brands,
            value: '${_brandCounts.length}',
          ),
        ),
        const SizedBox(width: AppSpacing.s),
        Expanded(
          child: InfoTileWidget(
            label: l10n.database_screen_categories,
            value: '${_categoryCounts.length}',
          ),
        ),
      ],
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
