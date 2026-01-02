import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/common/widgets/empty_state_widget.dart';
import 'package:shox/common/widgets/error_state_widget.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';
import 'package:shox/features/users/controller/user_controller.dart';
import 'package:shox/screens/shoes/screens/shoes_adder_screen.dart';
import 'package:shox/screens/shoes/screens/shoes_details_screen.dart';
import 'package:shox/core/utils/shoes_text_translations.dart';
import 'package:shox/features/shoes/controller/shoes_controller.dart';
import 'package:shox/core/utils/utils.dart';
import 'package:shox/common/widgets/loader_widget.dart';
import 'package:shox/screens/home/widgets/top_bar_widget.dart';
import 'package:shox/screens/home/widgets/filter_bar_widget.dart';
import 'package:shox/screens/home/widgets/filter_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final UserController _userController = Get.put(UserController());
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final ShoesController _shoesController = ShoesController();
  late Stream<List<ShoesModel>> _shoesListFuture;
  IconData currentIcon = MingCuteIcons.mgc_dot_grid_line;
  GridColumns currentGridColumns = GridColumns.gTwo;
  bool filtersActive = false;
  bool showOnlyFavorites = false;
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";
  Color? selectedColor;
  Color? selectedColorExtra;
  String? selectedCategory = 'All';
  String? selectedType = 'All';
  String selectedSeason = 'All';
  String? _userGender;
  Map<String, List<String>> _categoryToTypes = {};
  late String _languageCode;
  Map<String, String> translatedCategoryOptions = {};
  late Map<String, String> translatedTypeOptions;
  late Map<String, String> translatedSeasonOptions;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.r, horizontal: 20.r),
            child: Column(
              children: [
                TopBarWidget(userController: _userController),
                SizedBox(height: 10.h),
                FilterBarWidget(
                  searchController: _searchController,
                  searchQuery: searchQuery,
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.trim();
                    });
                  },
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
                  filtersActive: filtersActive,
                  currentIcon: currentIcon,
                  showOnlyFavorites: showOnlyFavorites,
                ),
                SizedBox(height: 20.h),
                _builMainContent(context),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 10.sp),
          child: FloatingActionButton(
            onPressed: () {
              Get.to(() => const ShoesAdderScreen(),
                  transition: Transition.fadeIn,
                  duration: const Duration(milliseconds: 500));
            },
            backgroundColor: Theme.of(context).colorScheme.secondary,
            elevation: 12,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.w)),
            child: Icon(MingCuteIcons.mgc_add_line,
                color: Theme.of(context).colorScheme.primary, size: 28.w),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _shoesListFuture = _shoesController.getShoesList(currentUser!.uid);
    _userController.loadUserName();
    _userController.loadUserProfile(currentUser!.uid);
    _loadUserGender();
  }

  void _loadUserGender() async {
    if (currentUser != null) {
      final userModel = await _userController.getUserDetails(currentUser!.uid);
      if (mounted && userModel != null) {
        setState(() {
          _userGender = userModel.gender;
          _categoryToTypes = ShoesModel.getCategoryToTypesByGender(_userGender);
          _updateTranslatedCategories();
        });
      }
    }
  }

  void _updateTranslatedCategories() {
    final allCategoryTranslations =
        ShoesTextTranslations.categoryTranslations[_languageCode] ?? {};

    // Filter categories based on user gender
    if (_categoryToTypes.isNotEmpty) {
      translatedCategoryOptions = Map.fromEntries(
        allCategoryTranslations.entries
            .where((entry) => _categoryToTypes.keys.contains(entry.key)),
      );
    } else {
      translatedCategoryOptions = allCategoryTranslations;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _languageCode = Localizations.localeOf(context).languageCode;

    translatedTypeOptions =
        ShoesTextTranslations.typeTranslations[_languageCode] ?? {};
    translatedSeasonOptions =
        ShoesTextTranslations.seasonTranslations[_languageCode] ?? {};

    // Update category translations if gender is already loaded
    if (_categoryToTypes.isNotEmpty) {
      _updateTranslatedCategories();
    }
  }

  void toggleGrid() {
    setState(
      () {
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
      },
    );
  }

  void _resetFilters() {
    searchQuery = '';
    selectedType = 'All';
    selectedSeason = 'All';
    _searchController.clear();
  }

  Widget _builMainContent(BuildContext context) {
    return Expanded(
      child: StreamBuilder<List<ShoesModel>>(
        stream: _shoesListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoaderWidget(
              width: 50.w,
              height: 50.h,
            );
          } else if (snapshot.hasError) {
            return ErrorStateWidget(
              message: AppLocalizations.of(context)!.home_screen_error_state,
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return EmptyStateWidget(
              message: AppLocalizations.of(context)!.home_screen_empty_state,
              icon: MingCuteIcons.mgc_shoe_line,
              iconColor: Theme.of(context).colorScheme.secondary,
            );
          }
          return _buildShoesGrid(context, snapshot.data!);
        },
      ),
    );
  }

  Widget _buildShoesGrid(BuildContext context, List<ShoesModel> shoesList) {
    shoesList.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));

    if (searchQuery.isNotEmpty) {
      shoesList = shoesList
          .where((shoes) =>
              shoes.brand.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    List<ShoesModel> filteredShoes = shoesList.where((shoes) {
      if (showOnlyFavorites && !shoes.isFavorite) return false;
      if (selectedColor != null && shoes.colorPrimary != selectedColor) {
        return false;
      }
      if (selectedColorExtra != null) {
        if (shoes.colorExtra == null || shoes.colorExtra!.isEmpty) {
          return false;
        }
        if (!shoes.colorExtra!.contains(selectedColorExtra!.value)) {
          return false;
        }
      }
      if (selectedCategory != 'All' && shoes.category != selectedCategory) {
        return false;
      }
      if (selectedType != null &&
          selectedType != 'All' &&
          (translatedTypeOptions[shoes.type] ?? shoes.type) != selectedType) {
        return false;
      }
      if (selectedSeason != 'All' && shoes.season != selectedSeason) {
        return false;
      }

      return true;
    }).toList();

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: currentGridColumns == GridColumns.gOne
            ? 1
            : currentGridColumns == GridColumns.gTwo
                ? 2
                : 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: filteredShoes.length,
      itemBuilder: (context, index) {
        ShoesModel shoe = filteredShoes[index];
        return _buildShoesCard(context, shoe);
      },
    );
  }

  Widget _buildImage(BuildContext context, String imageUrl) {
    double imageWidth;
    double imageHeight;

    if (currentGridColumns == GridColumns.gOne) {
      imageWidth = ScreenUtil().screenWidth;
      imageHeight = 800.h;
    } else {
      imageWidth = ScreenUtil().screenWidth > 600 ? 600.w : 300.w;
      imageHeight = ScreenUtil().screenWidth > 600 ? 1200.h : 200.h;
    }

    if (imageUrl.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        width: imageWidth,
        height: imageHeight,
        fit: BoxFit.cover,
        placeholder: (context, url) => LoaderWidget(width: 25.w, height: 25.h),
        errorWidget: (context, url, error) => Icon(
          MingCuteIcons.mgc_close_line,
          color: Theme.of(context).colorScheme.secondary,
        ),
      );
    } else {
      return Image.asset(
        imageUrl,
        width: imageWidth,
        height: imageHeight,
        fit: BoxFit.cover,
      );
    }
  }

  Widget _buildShoesCard(BuildContext context, ShoesModel shoes) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => ShoesDetailsScreen(shoesId: shoes.id!),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 500),
        );
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20.r)),
            child: _buildImage(context, shoes.imageUrl),
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
      backgroundColor: Theme.of(context).colorScheme.primary,
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
            return FilterWidget(
              selectedColor: tempSelectedColor,
              selectedColorExtra: tempSelectedColorExtra,
              selectedCategory: tempSelectedCategory,
              selectedType: tempSelectedType,
              selectedSeason: tempSelectedSeason,
              translatedCategoryOptions: translatedCategoryOptions,
              translatedTypeOptions: translatedTypeOptions,
              translatedSeasonOptions: translatedSeasonOptions,
              categoryToTypes: _categoryToTypes,
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
                      : null;
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
                  filtersActive = false;
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
                  filtersActive = true;
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
