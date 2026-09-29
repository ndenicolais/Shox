import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:shox/features/home/widgets/filter_bar.dart';
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
              padding: EdgeInsets.symmetric(
                vertical: AppSpacing.s.r,
                horizontal: AppSpacing.l.r,
              ),
              child: Column(
                children: [
                  TopBar(userController: userController),
                  SizedBox(height: 10.h),
                  FilterBar(
                    searchController: _searchController,
                    searchQuery: searchQuery,
                    onChanged: _onSearchChanged,
                    onReset: () {
                      setState(() {
                        _resetFilters();
                      });
                    },
                    onFilter: _showFilterDialog,
                    onToggleGrid: toggleGrid,
                    onToggleFavorites: () {
                      setState(() {
                        showOnlyFavorites = !showOnlyFavorites;
                      });
                    },
                    filtersActive: _filter.isActive,
                    currentIcon: currentIcon,
                    showOnlyFavorites: showOnlyFavorites,
                  ),
                  SizedBox(height: 20.h),
                  _buildMainContent(context),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 10.sp),
          child: FloatingActionButton(
            tooltip: AppLocalizations.of(context)!.a11y_add_shoe,
            onPressed: () {
              Get.toNamed(AppRoutes.shoesAdder);
            },
            backgroundColor: Theme.of(context).colorScheme.secondary,
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.w),
            ),
            child: Icon(
              MingCuteIcons.mgc_add_line,
              color: Theme.of(context).colorScheme.surface,
              size: 28.w,
            ),
          ),
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

  /// Placeholder grid with the same columns and cell shape as the real one.
  Widget _buildGridSkeleton(BuildContext context) {
    return Semantics(
      label: AppLocalizations.of(context)!.a11y_loading,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final int columns = _columnsFor(constraints.maxWidth);
          final double spacing = AppSpacing.grid.r;
          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              childAspectRatio: _gridTileAspectRatio,
            ),
            itemCount: columns * 4,
            itemBuilder: (context, index) => SkeletonWidget(
              borderRadius: BorderRadius.all(Radius.circular(20.r)),
            ),
          );
        },
      ),
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

    return LayoutBuilder(
      key: ValueKey('grid|$_gridViewKey'),
      builder: (context, constraints) {
        final int columns = _columnsFor(constraints.maxWidth);
        final double spacing = AppSpacing.grid.r;
        final double cellWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return RefreshIndicator(
          onRefresh: _refreshShoes,
          color: Theme.of(context).colorScheme.surface,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(bottom: 88.h),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              childAspectRatio: _gridTileAspectRatio,
            ),
            itemCount: filteredShoes.length,
            itemBuilder: (context, index) {
              ShoesModel shoe = filteredShoes[index];
              return _buildShoesCard(context, shoe, cellWidth);
            },
          ),
        );
      },
    );
  }

  /// Grid cells are square in every column layout.
  static const double _gridTileAspectRatio = 1;

  /// Fills its grid cell; [cellWidth] only sizes the decoded bitmap, so
  /// thumbnails are not decoded at the full photo resolution.
  Widget _buildImage(
    BuildContext context,
    String imageUrl,
    double cellWidth,
  ) {
    final int cacheWidth =
        (cellWidth * MediaQuery.devicePixelRatioOf(context)).round();

    if (imageUrl.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        width: double.infinity,
        height: double.infinity,
        memCacheWidth: cacheWidth,
        fit: BoxFit.cover,
        placeholder: (context, url) => const SkeletonWidget(),
        errorWidget: (context, url, error) => Icon(
          MingCuteIcons.mgc_close_line,
          color: Theme.of(context).colorScheme.secondary,
        ),
      );
    } else {
      return Image.asset(
        imageUrl,
        width: double.infinity,
        height: double.infinity,
        cacheWidth: cacheWidth,
        fit: BoxFit.cover,
      );
    }
  }

  Widget _buildShoesCard(
    BuildContext context,
    ShoesModel shoes,
    double cellWidth,
  ) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.shoesDetails, arguments: shoes.id!);
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: 'shoes-${shoes.id}',
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20.r)),
              child: _buildImage(context, shoes.imageUrl, cellWidth),
            ),
          ),
          Positioned(
            top: 2.r,
            right: 2.r,
            child: _buildFavoriteButton(shoes, context),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
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

  Widget _buildFavoriteButton(ShoesModel shoe, BuildContext context) {
    return IconButton(
      tooltip: shoe.isFavorite
          ? AppLocalizations.of(context)!.a11y_remove_from_favorites
          : AppLocalizations.of(context)!.a11y_add_to_favorites,
      // Semi-transparent backdrop keeps the heart readable on light photos.
      style: IconButton.styleFrom(
        backgroundColor:
            Theme.of(context).colorScheme.surface.withValues(alpha: 0.75),
      ),
      icon: Icon(
        shoe.isFavorite
            ? MingCuteIcons.mgc_heart_fill
            : MingCuteIcons.mgc_heart_line,
        color: Theme.of(context).colorScheme.secondary,
      ),
      onPressed: () {
        _shoesController.toggleFavoriteStatus(shoe.id!, !shoe.isFavorite);
      },
    );
  }
}
