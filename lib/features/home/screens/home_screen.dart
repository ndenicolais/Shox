import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:shox/theme/app_spacing.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/common/widgets/changelog_dialog_widget.dart';
import 'package:shox/common/widgets/empty_state_widget.dart';
import 'package:shox/common/widgets/error_state_widget.dart';
import 'package:shox/core/constants/changelog.dart';
import 'package:shox/core/routes/app_routes.dart';
import 'package:shox/core/utils/constants.dart';
import 'package:shox/features/shoes/models/shoes_filter.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';
import 'package:shox/features/shoes/controller/shoes_controller.dart';
import 'package:shox/features/shoes/widgets/shoes_categories_mixin.dart';
import 'package:shox/core/utils/utils.dart';
import 'package:shox/common/widgets/responsive_center_widget.dart';
import 'package:shox/common/widgets/skeleton_widget.dart';
import 'package:shox/features/home/widgets/top_bar.dart';
import 'package:shox/features/home/widgets/category_chips.dart';
import 'package:shox/features/home/widgets/filter_bar.dart';
import 'package:shox/features/home/widgets/shoe_card.dart';
import 'package:shox/features/home/widgets/filter_sheet.dart';
import 'package:shox/theme/app_breakpoints.dart';
import 'package:shox/theme/app_radius.dart';

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
    final prefs = await SharedPreferences.getInstance();
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;
    final lastSeen =
        prefs.getString(AppConstants.prefsLastSeenChangelogVersion);

    if (lastSeen == currentVersion) return;
    if (lastSeen == null) {
      await prefs.setString(
        AppConstants.prefsLastSeenChangelogVersion,
        currentVersion,
      );
      return;
    }

    final lastSeenIndex =
        changelogEntries.indexWhere((entry) => entry.version == lastSeen);
    final entriesToShow = lastSeenIndex == -1
        ? changelogEntries
        : changelogEntries.sublist(0, lastSeenIndex);

    await prefs.setString(
      AppConstants.prefsLastSeenChangelogVersion,
      currentVersion,
    );
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
              child: _buildGridSkeleton(context),
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

  int get _baseColumns => currentGridColumns == GridColumns.gOne
      ? 1
      : currentGridColumns == GridColumns.gTwo
          ? 2
          : 3;

  /// Columns actually shown for [maxWidth]: the user's choice, raised on
  /// wide screens (tablets, landscape).
  int _columnsFor(double maxWidth) => currentGridColumns == GridColumns.gOne
      ? 1
      : AppBreakpoints.gridColumnsForWidth(maxWidth, minColumns: _baseColumns)
          .clamp(_baseColumns, 4);

  static const double _gridCrossSpacing = AppSpacing.s;
  static const double _gridMainSpacing = AppSpacing.m;

  double _cellWidth(double maxWidth, int columns) =>
      (maxWidth - _gridCrossSpacing * (columns - 1)) / columns;

  /// Square photo plus the caption block of [ShoeCard].
  SliverGridDelegate _gridDelegate(int columns, double cellWidth) =>
      SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: _gridCrossSpacing,
        mainAxisSpacing: _gridMainSpacing,
        mainAxisExtent: cellWidth + ShoeCard.captionHeight(context),
      );

  /// Placeholder grid with the same columns and card shape as the real one.
  Widget _buildGridSkeleton(BuildContext context) {
    return Semantics(
      label: AppLocalizations.of(context)!.a11y_loading,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final int columns = _columnsFor(constraints.maxWidth);
          final double cellWidth = _cellWidth(constraints.maxWidth, columns);
          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: AppSpacing.xl),
            gridDelegate: _gridDelegate(columns, cellWidth),
            itemCount: columns * 4,
            itemBuilder: (context, index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonWidget(
                  width: cellWidth,
                  height: cellWidth,
                  borderRadius: BorderRadius.circular(AppRadius.extraLarge),
                ),
                const SizedBox(height: AppSpacing.xs),
                SkeletonWidget(
                  width: cellWidth * 0.6,
                  height: 12,
                  borderRadius: BorderRadius.circular(AppRadius.small),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// "12 pairs · 4 favorites" with the grid layout toggle.
  Widget _buildCountRow(BuildContext context, List<ShoesModel> shoes) {
    final l10n = AppLocalizations.of(context)!;
    final int favorites = shoes.where((s) => s.isFavorite).length;
    return Row(
      children: [
        Expanded(
          child: Text(
            '${l10n.home_screen_pairs_count(shoes.length)} · '
            '${l10n.home_screen_favorites_count(favorites)}',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ),
        IconButton(
          tooltip: l10n.a11y_toggle_grid,
          onPressed: toggleGrid,
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Icon(currentIcon, key: ValueKey(currentIcon)),
          ),
        ),
      ],
    );
  }

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
        _buildCountRow(context, filteredShoes),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final int columns = _columnsFor(constraints.maxWidth);
              final double cellWidth =
                  _cellWidth(constraints.maxWidth, columns);

              return RefreshIndicator(
                onRefresh: _refreshShoes,
                color: Theme.of(context).colorScheme.onPrimary,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: GridView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  // Keeps the last row clear of the floating button.
                  padding: const EdgeInsets.only(bottom: 96),
                  gridDelegate: _gridDelegate(columns, cellWidth),
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

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        Color? tempSelectedColor = selectedColor;
        Color? tempSelectedColorExtra = selectedColorExtra;
        String? tempSelectedCategory = selectedCategory;
        String? tempSelectedType = selectedType;
        String tempSelectedSeason = selectedSeason;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return FilterSheet(
              selectedColor: tempSelectedColor,
              selectedColorExtra: tempSelectedColorExtra,
              selectedCategory: tempSelectedCategory,
              selectedType: tempSelectedType,
              selectedSeason: tempSelectedSeason,
              translatedCategoryOptions: translatedCategoryOptions,
              translatedTypeOptions: translatedTypeOptions,
              translatedSeasonOptions: translatedSeasonOptions,
              categoryToTypes: categoryToTypes,
              colorList: colorList,
              onColorSelected: (color) {
                setModalState(() {
                  if (tempSelectedColor == color) {
                    tempSelectedColor = null;
                  } else {
                    tempSelectedColor = color;
                  }
                });
              },
              onColorExtraSelected: (color) {
                setModalState(() {
                  if (tempSelectedColorExtra == color) {
                    tempSelectedColorExtra = null;
                  } else {
                    tempSelectedColorExtra = color;
                  }
                });
              },
              onCategoryChanged: (newValue) {
                setModalState(() {
                  tempSelectedCategory = newValue != 'All'
                      ? translatedCategoryOptions.entries
                          .firstWhere((entry) => entry.value == newValue)
                          .key
                      : 'All';
                  tempSelectedType = 'All';
                });
              },
              onTypeChanged: (newValue) {
                setModalState(() {
                  tempSelectedType = newValue!;
                });
              },
              onSeasonChanged: (newValue) {
                setModalState(() {
                  tempSelectedSeason = newValue!;
                });
              },
              onReset: () {
                setState(() {
                  selectedColor = null;
                  selectedColorExtra = null;
                  selectedCategory = 'All';
                  selectedType = 'All';
                  selectedSeason = 'All';
                  showOnlyFavorites = false;
                });
                Get.back();
              },
              onApply: () {
                setState(() {
                  selectedColor = tempSelectedColor;
                  selectedColorExtra = tempSelectedColorExtra;
                  selectedCategory = tempSelectedCategory;
                  selectedType = tempSelectedType;
                  selectedSeason = tempSelectedSeason;
                });
                Get.back();
              },
            );
          },
        );
      },
    );
  }
}
