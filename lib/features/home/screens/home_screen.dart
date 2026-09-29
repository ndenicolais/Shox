import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:shox/theme/app_spacing.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/common/widgets/changelog_dialog_widget.dart';
import 'package:shox/common/widgets/empty_state_widget.dart';
import 'package:shox/common/widgets/error_state_widget.dart';
import 'package:shox/core/services/changelog_service.dart';
import 'package:shox/core/routes/app_routes.dart';
import 'package:shox/features/shoes/models/shoes_filter.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';
import 'package:shox/features/shoes/controller/shoes_controller.dart';
import 'package:shox/features/shoes/widgets/shoes_categories_mixin.dart';
import 'package:shox/core/utils/utils.dart';
import 'package:shox/common/widgets/responsive_center_widget.dart';
import 'package:shox/features/home/widgets/top_bar.dart';
import 'package:shox/features/home/widgets/category_chips.dart';
import 'package:shox/features/home/widgets/filter_bar.dart';
import 'package:shox/features/home/widgets/shoe_card.dart';
import 'package:shox/features/home/widgets/shoes_grid.dart';
import 'package:shox/features/home/widgets/filter_sheet.dart';
import 'package:shox/theme/app_breakpoints.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin, ShoesCategoriesMixin {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final ShoesController _shoesController = Get.find<ShoesController>();
  late Stream<List<ShoesModel>> _shoesListStream;
  IconData currentIcon = MingCuteIcons.mgc_dot_grid_line;
  GridColumns currentGridColumns = GridColumns.gTwo;
  bool showOnlyFavorites = false;
  final TextEditingController _searchController = TextEditingController();
  static const Duration _searchDebounceDuration = Duration(milliseconds: 300);
  Timer? _searchDebounce;
  String searchQuery = "";
  Color? selectedColor;
  Color? selectedColorExtra;
  String? selectedCategory = 'All';
  String? selectedType = 'All';
  String selectedSeason = 'All';

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: ResponsiveCenterWidget(
            maxWidth: AppBreakpoints.maxGridWidth,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.l,
                AppSpacing.s,
                AppSpacing.l,
                0,
              ),
              child: Column(
                children: [
                  TopBar(userController: userController),
                  const SizedBox(height: AppSpacing.l),
                  FilterBar(
                    searchController: _searchController,
                    onChanged: _onSearchChanged,
                    onClear: () => setState(_resetFilters),
                    onFilter: _showFilterDialog,
                    filtersActive: _filter.isActive,
                  ),
                  const SizedBox(height: AppSpacing.m),
                  CategoryChips(
                    categories: translatedCategoryOptions,
                    selectedCategory: selectedCategory,
                    onlyFavorites: showOnlyFavorites,
                    onCategorySelected: (category) => setState(() {
                      selectedCategory = category;
                      selectedType = ShoesFilter.all;
                    }),
                    onFavoritesToggled: () => setState(
                      () => showOnlyFavorites = !showOnlyFavorites,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  _buildMainContent(context),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          tooltip: AppLocalizations.of(context)!.a11y_add_shoe,
          onPressed: () => Get.toNamed(AppRoutes.shoesAdder),
          icon: const Icon(MingCuteIcons.mgc_add_line),
          label: Text(AppLocalizations.of(context)!.home_screen_add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _shoesListStream = _shoesController.getShoesList(currentUser!.uid);
    userController.loadUserName();
    userController.loadUserProfile(currentUser!.uid);
    loadUserGender(currentUser?.uid);
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowChangelog());
  }

  Future<void> _maybeShowChangelog() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final entriesToShow =
        await ChangelogService.pendingEntries(packageInfo.version);
    if (entriesToShow.isEmpty || !mounted) return;

    await showDialog<void>(
      context: context,
      builder: (context) => ChangelogDialogWidget(entries: entriesToShow),
    );
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  /// Filters the grid only once the user pauses typing, instead of at every
  /// keystroke.
  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(_searchDebounceDuration, () {
      if (!mounted) return;
      setState(() => searchQuery = value.trim());
    });
  }

  /// Re-subscribes to the shoes stream and completes once fresh data arrives.
  Future<void> _refreshShoes() async {
    final stream = _shoesController.getShoesList(currentUser!.uid);
    setState(() => _shoesListStream = stream);
    // Let the StreamBuilder subscribe first, so it cannot miss the first
    // snapshot of the (broadcast) Firestore stream.
    await WidgetsBinding.instance.endOfFrame;
    try {
      await stream.first.timeout(const Duration(seconds: 10));
    } catch (_) {
      // Errors and timeouts are surfaced by the StreamBuilder itself.
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    refreshTranslations();
  }

  void toggleGrid() {
    setState(() {
      if (currentGridColumns == GridColumns.gOne) {
        currentGridColumns = GridColumns.gTwo;
        currentIcon = MingCuteIcons.mgc_dot_grid_line;
      } else if (currentGridColumns == GridColumns.gTwo) {
        currentGridColumns = GridColumns.gThree;
        currentIcon = MingCuteIcons.mgc_distribute_spacing_vertical_line;
      } else {
        currentGridColumns = GridColumns.gOne;
        currentIcon = MingCuteIcons.mgc_layout_grid_line;
      }
    });
  }

  /// Current filter state as a pure value object (see [ShoesFilter]).
  ShoesFilter get _filter => ShoesFilter(
        searchQuery: searchQuery,
        onlyFavorites: showOnlyFavorites,
        colorPrimary: selectedColor,
        colorExtra: selectedColorExtra,
        category: selectedCategory,
        type: selectedType,
        season: selectedSeason,
        translatedTypeOptions: translatedTypeOptions,
        translatedCategoryOptions: translatedCategoryOptions,
      );

  void _resetFilters() {
    _searchDebounce?.cancel();
    searchQuery = '';
    selectedColor = null;
    selectedColorExtra = null;
    selectedCategory = 'All';
    selectedType = 'All';
    selectedSeason = 'All';
    showOnlyFavorites = false;
    _searchController.clear();
  }

  static const Duration _contentSwitchDuration = Duration(milliseconds: 250);

  /// Changes whenever the visible grid layout or result set changes, so the
  /// grid cross-fades on column toggles and filter changes, but not on
  /// ordinary stream updates such as toggling a favorite.
  String get _gridViewKey => [
        currentGridColumns,
        searchQuery,
        showOnlyFavorites,
        selectedColor?.toARGB32(),
        selectedColorExtra?.toARGB32(),
        selectedCategory,
        selectedType,
        selectedSeason,
      ].join('|');

  Widget _buildMainContent(BuildContext context) {
    return Expanded(
      child: StreamBuilder<List<ShoesModel>>(
        stream: _shoesListStream,
        builder: (context, snapshot) {
          final Widget content;
          if (snapshot.connectionState == ConnectionState.waiting) {
            content = KeyedSubtree(
              key: const ValueKey('loading'),
              child: ShoesGridSkeleton(layout: _gridLayout),
            );
          } else if (snapshot.hasError) {
            content = ErrorStateWidget(
              key: const ValueKey('error'),
              message: AppLocalizations.of(context)!.home_screen_error_state,
              onRetry: () => setState(() {
                _shoesListStream =
                    _shoesController.getShoesList(currentUser!.uid);
              }),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            content = EmptyStateWidget(
              key: const ValueKey('empty'),
              message: AppLocalizations.of(context)!.home_screen_empty_state,
              icon: MingCuteIcons.mgc_shoe_line,
              iconColor: Theme.of(context).colorScheme.secondary,
            );
          } else {
            content = _buildShoesGrid(context, snapshot.data!);
          }
          return AnimatedSwitcher(
            duration: _contentSwitchDuration,
            child: content,
          );
        },
      ),
    );
  }

  ShoesGridLayout get _gridLayout => ShoesGridLayout(currentGridColumns);

  Widget _buildShoesGrid(BuildContext context, List<ShoesModel> shoesList) {
    final List<ShoesModel> filteredShoes = _filter.apply(shoesList);

    if (filteredShoes.isEmpty) {
      return EmptyStateWidget(
        key: const ValueKey('no-results'),
        message: AppLocalizations.of(context)!.home_screen_no_results_state,
        icon: MingCuteIcons.mgc_search_2_line,
        iconColor: Theme.of(context).colorScheme.secondary,
        actionLabel: AppLocalizations.of(context)!.home_screen_no_results_reset,
        onAction: () => setState(_resetFilters),
      );
    }

    return Column(
      key: ValueKey('grid|$_gridViewKey'),
      children: [
        ShoesCountRow(
          shoes: filteredShoes,
          gridIcon: currentIcon,
          onToggleGrid: toggleGrid,
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final layout = _gridLayout;
              final int columns = layout.columnsFor(constraints.maxWidth);
              final double cellWidth =
                  layout.cellWidth(constraints.maxWidth, columns);

              return RefreshIndicator(
                onRefresh: _refreshShoes,
                color: Theme.of(context).colorScheme.onPrimary,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: GridView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  // Keeps the last row clear of the floating button.
                  padding: const EdgeInsets.only(bottom: 96),
                  gridDelegate: layout.delegate(
                    columns: columns,
                    cellWidth: cellWidth,
                    captionHeight: ShoeCard.captionHeight(context),
                  ),
                  itemCount: filteredShoes.length,
                  itemBuilder: (context, index) {
                    final shoe = filteredShoes[index];
                    return ShoeCard(
                      shoe: shoe,
                      typeLabel: translatedTypeOptions[shoe.type] ?? shoe.type,
                      cellWidth: cellWidth,
                      onTap: () => Get.toNamed(
                        AppRoutes.shoesDetails,
                        arguments: shoe.id!,
                      ),
                      onToggleFavorite: () =>
                          _shoesController.toggleFavoriteStatus(
                        shoe.id!,
                        !shoe.isFavorite,
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _showFilterDialog() async {
    final result = await showFilterSheet(
      context,
      initial: FilterSelection(
        color: selectedColor,
        colorExtra: selectedColorExtra,
        category: selectedCategory,
        type: selectedType,
        season: selectedSeason,
      ),
      translatedCategoryOptions: translatedCategoryOptions,
      translatedTypeOptions: translatedTypeOptions,
      translatedSeasonOptions: translatedSeasonOptions,
      categoryToTypes: categoryToTypes,
      colorList: colorList,
    );
    if (result == null || !mounted) return;

    setState(() {
      if (result.reset) {
        selectedColor = null;
        selectedColorExtra = null;
        selectedCategory = ShoesFilter.all;
        selectedType = ShoesFilter.all;
        selectedSeason = ShoesFilter.all;
        showOnlyFavorites = false;
      } else {
        selectedColor = result.color;
        selectedColorExtra = result.colorExtra;
        selectedCategory = result.category;
        selectedType = result.type;
        selectedSeason = result.season;
      }
    });
  }
}
