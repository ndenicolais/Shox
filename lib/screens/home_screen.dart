import 'package:cached_network_image/cached_network_image.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/generated/l10n.dart';
import 'package:shox/models/shoes_model.dart';
import 'package:shox/screens/user/user_controller.dart';
import 'package:shox/screens/user/user_screen.dart';
import 'package:shox/screens/settings/settings_screen.dart';
import 'package:shox/screens/shoes/shoes_adder_screen.dart';
import 'package:shox/screens/shoes/shoes_details_screen.dart';
import 'package:shox/utils/category_translations.dart';
import 'package:shox/services/shoes_service.dart';
import 'package:shox/theme/app_colors.dart';
import 'package:shox/utils/utils.dart';
import 'package:shox/widgets/custom_loader.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final UserController userController = Get.put(UserController());
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final ShoesService _shoesService = ShoesService();
  late Stream<List<ShoesModel>> _shoesListFuture;
  IconData currentIcon = Icons.grid_on;
  GridColumns currentGridColumns = GridColumns.gTwo;
  bool filtersActive = false;
  bool showOnlyFavorites = false;
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";
  Color? selectedColor;
  IconData? selectedSeasonIcon;
  String selectedCategory = 'All';
  String? selectedType = 'All';
  late String _languageCode;
  late Map<String, String> translatedCategoryOptions;
  late Map<String, String> translatedTypeOptions;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: _buildBody(context),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    userController.loadUserName();
    _shoesListFuture = _shoesService.getShoesList(currentUser!.uid);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _languageCode = Localizations.localeOf(context).languageCode;
    translatedCategoryOptions =
        CategoryTranslations.categoryTranslations[_languageCode] ?? {};
    translatedTypeOptions =
        CategoryTranslations.typeTranslations[_languageCode] ?? {};
  }

  void toggleGrid() {
    setState(
      () {
        if (currentGridColumns == GridColumns.gOne) {
          currentGridColumns = GridColumns.gTwo;
          currentIcon = Icons.grid_on;
        } else if (currentGridColumns == GridColumns.gTwo) {
          currentGridColumns = GridColumns.gThree;
          currentIcon = Icons.view_agenda_outlined;
        } else {
          currentGridColumns = GridColumns.gOne;
          currentIcon = Icons.grid_view;
        }
      },
    );
  }

  void _resetFilters() {
    searchQuery = '';
    selectedType = 'All';
    _searchController.clear();
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CustomLoader(
        width: 50.w,
        height: 50.h,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.r, horizontal: 20.r),
        child: Column(
          children: [
            _buildGreeting(),
            SizedBox(height: 10.h),
            _buildSearchBar(context),
            SizedBox(height: 20.h),
            _builMainContent(context),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget _buildGreeting() {
    return Row(
      children: [
        Text(
          'Hey',
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 40.sp,
            fontFamily: 'CustomFont',
          ),
        ),
        SizedBox(width: 10.w),
        Obx(
          () => Text(
            userController.userName.value,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 40.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'CustomFontBold',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            onTapOutside: (event) =>
                FocusManager.instance.primaryFocus?.unfocus(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontFamily: 'CustomFont',
            ),
            cursorColor: Theme.of(context).colorScheme.tertiary,
            onChanged: (value) {
              setState(() {
                searchQuery = value.trim();
              });
            },
            decoration: InputDecoration(
              prefixIcon: Icon(
                MingCuteIcons.mgc_search_2_fill,
                size: 18.sp,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      onPressed: () {
                        setState(
                          () {
                            _resetFilters();
                          },
                        );
                      },
                    )
                  : null,
              labelText: S.current.home_search,
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontFamily: 'CustomFont',
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            filtersActive
                ? MingCuteIcons.mgc_filter_fill
                : MingCuteIcons.mgc_filter_line,
            color: filtersActive
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.tertiary,
          ),
          onPressed: () {
            _showFilterDialog();
          },
        ),
        IconButton(
          icon: Icon(
            currentIcon,
            color: Theme.of(context).colorScheme.tertiary,
          ),
          onPressed: () {
            toggleGrid();
          },
        ),
        IconButton(
          icon: Icon(
            showOnlyFavorites
                ? MingCuteIcons.mgc_heart_fill
                : MingCuteIcons.mgc_heart_line,
            color: showOnlyFavorites
                ? AppColors.errorColor
                : Theme.of(context).colorScheme.tertiary,
          ),
          onPressed: () {
            setState(
              () {
                showOnlyFavorites = !showOnlyFavorites;
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return SizedBox(
      width: 320.w,
      child: Text(
        'Error state',
        style: TextStyle(
          color: Theme.of(context).colorScheme.tertiary,
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
          fontFamily: 'CustomFont',
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          MingCuteIcons.mgc_package_line,
          size: 60.sp,
          color: Theme.of(context).colorScheme.secondary,
        ),
        Text(
          S.current.home_empty,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 22.sp,
            fontFamily: 'CustomFont',
          ),
        ),
      ],
    );
  }

  Widget _builMainContent(BuildContext context) {
    return Expanded(
      child: StreamBuilder<List<ShoesModel>>(
        stream: _shoesListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingIndicator();
          } else if (snapshot.hasError) {
            return _buildErrorState(context);
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState(context);
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
      if (selectedColor != null && shoes.color != selectedColor) return false;
      if (selectedSeasonIcon != null &&
          shoes.seasonIcon != selectedSeasonIcon) {
        return false;
      }
      if (selectedCategory != 'All' && shoes.category != selectedCategory) {
        return false;
      }
      if (selectedType != 'All' && shoes.type != selectedType) return false;
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
        placeholder: (context, url) => Center(child: _buildLoadingIndicator()),
        errorWidget: (context, url, error) => Icon(
          MingCuteIcons.mgc_close_fill,
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            S.current.home_filter_title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'CustomFontBold',
            ),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.r),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        S.current.home_filter_color,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontFamily: 'CustomFont',
                        ),
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 8.r,
                    runSpacing: 8.r,
                    children: colorList.map((color) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedColor = color;
                          });
                        },
                        child: Container(
                          width: 24.w,
                          height: 24.h,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(50.r),
                            border: Border.all(
                              color: selectedColor == color
                                  ? Theme.of(context).colorScheme.tertiary
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.r),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        S.current.home_filter_season,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontFamily: 'CustomFont',
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: ShoesModel.seasonOptions.map((IconData icon) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedSeasonIcon = icon;
                          });
                        },
                        child: Icon(
                          icon,
                          color: selectedSeasonIcon == icon
                              ? Theme.of(context).colorScheme.tertiary
                              : Theme.of(context)
                                  .colorScheme
                                  .tertiary
                                  .withValues(alpha: 0.3),
                          size: 32.sp,
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10.h),
                  _buildDropdown(
                    value: selectedCategory,
                    items: ['All', ...translatedCategoryOptions.keys],
                    onChanged: (newValue) {
                      setState(() {
                        selectedCategory = newValue!;
                      });
                    },
                    labelText: S.current.home_filter_category,
                  ),
                  _buildDropdown(
                    value: selectedType,
                    items: selectedType == null
                        ? []
                        : [
                            'All',
                            ...ShoesModel.categoryToTypes[selectedCategory] ??
                                []
                          ],
                    onChanged: (newValue) {
                      setState(() {
                        selectedType = newValue!;
                      });
                    },
                    labelText: S.current.home_filter_type,
                  ),
                ],
              );
            },
          ),
          actions: [
            _buildActionButton(
              label: S.current.home_filter_cancel,
              color: AppColors.errorColor,
              onPressed: () {
                setState(() {
                  selectedCategory = 'All';
                  selectedType = 'All';
                  selectedColor = null;
                  selectedSeasonIcon = null;
                  showOnlyFavorites = false;
                  filtersActive = false;
                });
                Get.back();
              },
            ),
            _buildActionButton(
              label: S.current.home_filter_apply,
              color: AppColors.confirmColor,
              onPressed: () {
                setState(() {
                  filtersActive = true;
                });
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(color),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.white,
          fontSize: 16.sp,
          fontFamily: 'CustomFont',
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required String labelText,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            translatedCategoryOptions[item] ?? item,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontFamily: 'CustomFont',
            ),
          ),
        );
      }).toList(),
      dropdownColor: Theme.of(context).colorScheme.primary,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.tertiary,
          fontFamily: 'CustomFont',
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ),
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
        _shoesService.toggleFavoriteStatus(shoe.id!, !shoe.isFavorite);
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return ConvexAppBar(
      items: [
        TabItem(
          fontFamily: 'CustomFont',
          title: S.current.home_profile,
          icon: MingCuteIcons.mgc_user_3_fill,
        ),
        TabItem(
          fontFamily: 'CustomFont',
          title: S.current.home_add,
          icon: MingCuteIcons.mgc_add_line,
        ),
        TabItem(
          fontFamily: 'CustomFont',
          title: S.current.home_settings,
          icon: MingCuteIcons.mgc_settings_5_fill,
        ),
      ],
      onTap: (int index) {
        switch (index) {
          case 0:
            Get.to(() => UserScreen(userId: currentUser!.uid),
                transition: Transition.fade,
                duration: const Duration(milliseconds: 500));
            break;
          case 1:
            Get.to(() => const ShoesAdderScreen(),
                transition: Transition.zoom,
                duration: const Duration(milliseconds: 500));
            break;
          case 2:
            Get.to(() => const SettingsPage(),
                transition: Transition.fade,
                duration: const Duration(milliseconds: 500));
            break;
        }
      },
      backgroundColor: Theme.of(context).colorScheme.secondary,
      color: Theme.of(context).colorScheme.primary,
      activeColor: Theme.of(context).colorScheme.primary,
      height: 60.h,
      curveSize: 100.r,
      style: TabStyle.fixedCircle,
    );
  }
}
