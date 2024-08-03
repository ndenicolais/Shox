import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/generated/l10n.dart';
import 'package:shox/pages/profile_page.dart';
import 'package:shox/pages/settings_page.dart';
import 'package:shox/pages/shoes/shoes_adder.dart';
import 'package:shox/pages/shoes/shoes_details.dart';
import 'package:shox/models/shoes_model.dart';
import 'package:shox/pages/shoes/shoes_languages.dart';
import 'package:shox/services/shoes_service.dart';
import 'package:shox/theme/app_colors.dart';
import 'package:shox/utils/utils.dart';

class ShoesHome extends StatefulWidget {
  const ShoesHome({super.key});

  @override
  ShoesHomeState createState() => ShoesHomeState();
}

class ShoesHomeState extends State<ShoesHome>
    with SingleTickerProviderStateMixin {
  String _userName = '';
  final ShoesService shoesService = ShoesService();
  late Future<List<Shoes>> _shoesListFuture;
  late AnimationController _loadingController;
  IconData currentIcon = Icons.grid_on;
  GridColumns currentGridColumns = GridColumns.gTwo;
  bool filtersActive = false;
  bool showOnlyFavorites = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String searchKeyword = '';
  Color? selectedColor;
  IconData? selectedSeasonIcon;
  String selectedCategory = 'All';
  String selectedType = 'All';
  late String _languageCode;
  late Map<String, String> translatedCategoryOptions;
  late Map<String, String> translatedTypeOptions;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _shoesListFuture = shoesService.getShoes();
    _loadingController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _languageCode = Localizations.localeOf(context).languageCode;
    translatedCategoryOptions =
        ShoesLanguages.categoryTranslations[_languageCode] ?? {};
    translatedTypeOptions =
        ShoesLanguages.typeTranslations[_languageCode] ?? {};
  }

  Future<void> _loadUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (user.providerData.isNotEmpty &&
          user.providerData[0].providerId == 'google.com') {
        // If the user is logged in via Google, get the name from the Google account
        String? googleUserName = user.displayName;
        if (googleUserName != null) {
          List<String> nameParts = googleUserName.split(" ");
          setState(
            () {
              // Take only the first name
              _userName = nameParts[0];
            },
          );
        }
      } else {
        // Access Firestore to retrieve user data
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userSnapshot.exists) {
          // Handle nullable Map<String, dynamic>
          Map<String, dynamic>? userData =
              userSnapshot.data() as Map<String, dynamic>?;

          if (userData != null) {
            setState(
              () {
                _userName = userData['name'] ?? 'User';
              },
            );
          } else {
            setState(
              () {
                _userName = 'User';
              },
            );
          }
        } else {
          setState(
            () {
              _userName = 'User';
            },
          );
        }
      }
    }
  }

  // Method to change grid layout and icon
  void toggleGrid() {
    setState(
      () {
        // Logic to change between 1, 2 and 3 columns
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

  Future<void> _refreshShoesList() async {
    setState(
      () {
        _shoesListFuture =
            shoesService.getShoes(onlyFavorites: showOnlyFavorites);
      },
    );
  }

  void _updateShoesList() {
    setState(
      () {
        _shoesListFuture = shoesService.getShoes();
      },
    );
  }

  void _resetFocus() {
    setState(
      () {
        searchKeyword = '';
        _searchController.clear();
        _searchFocusNode.unfocus();
      },
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
              fontSize: 20.r,
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
                    padding: EdgeInsets.symmetric(vertical: 8.0.r),
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
                    spacing: 8.0.r,
                    runSpacing: 8.0.r,
                    children: colorList
                        .map(
                          (color) => GestureDetector(
                            onTap: () {
                              setState(
                                () {
                                  selectedColor = color;
                                },
                              );
                            },
                            child: Container(
                              width: 24.r,
                              height: 24.r,
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
                          ),
                        )
                        .toList(),
                  ),
                  10.verticalSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0.r),
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
                    children: Shoes.seasonOptions.map(
                      (IconData icon) {
                        return GestureDetector(
                          onTap: () {
                            setState(
                              () {
                                selectedSeasonIcon = icon;
                              },
                            );
                          },
                          child: Icon(
                            icon,
                            color: selectedSeasonIcon == icon
                                ? Theme.of(context).colorScheme.tertiary
                                : Theme.of(context)
                                    .colorScheme
                                    .tertiary
                                    .withOpacity(0.3),
                            size: 32,
                          ),
                        );
                      },
                    ).toList(),
                  ),
                  10.verticalSpace,
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    onChanged: (String? newValue) {
                      setState(
                        () {
                          selectedCategory = newValue!;
                        },
                      );
                    },
                    items: ['All', ...translatedCategoryOptions.keys]
                        .map(
                          (category) => DropdownMenuItem<String>(
                            value: category,
                            child: Text(
                              translatedCategoryOptions[category] ?? category,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontFamily: 'CustomFont',
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    dropdownColor: Theme.of(context).colorScheme.primary,
                    decoration: InputDecoration(
                      labelText: S.current.home_filter_category,
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
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    onChanged: (String? newValue) {
                      setState(
                        () {
                          selectedType = newValue!;
                        },
                      );
                    },
                    items: ['All', ...translatedTypeOptions.keys]
                        .map(
                          (type) => DropdownMenuItem<String>(
                            value: type,
                            child: Text(
                              translatedTypeOptions[type] ?? type,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontFamily: 'CustomFont',
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    dropdownColor: Theme.of(context).colorScheme.primary,
                    decoration: InputDecoration(
                      labelText: S.current.home_filter_type,
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
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  AppColors.errorColor,
                ),
              ),
              child: Text(
                S.current.home_filter_cancel,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16.r,
                  fontFamily: 'CustomFont',
                ),
              ),
              onPressed: () {
                setState(
                  () {
                    selectedCategory = 'All';
                    selectedType = 'All';
                    selectedColor = null;
                    selectedSeasonIcon = null;
                    showOnlyFavorites = false;
                    filtersActive = false;
                  },
                );
                Get.back();
              },
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  AppColors.confirmColor,
                ),
              ),
              child: Text(
                S.current.home_filter_apply,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16.r,
                  fontFamily: 'CustomFont',
                ),
              ),
              onPressed: () {
                setState(
                  () {
                    filtersActive = true;
                  },
                );
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    _searchController.dispose();
    // Make sure to delete focusNode when it is no longer needed
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the number of columns based on screen width
    final double screenWidth = MediaQuery.of(context).size.width;
    final int numberOfColumns = (screenWidth / 200.r).floor();

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.r, horizontal: 10.r),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Hey, ',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 40.r,
                        fontFamily: 'CustomFont',
                      ),
                    ),
                    Text(
                      _userName,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 40.r,
                        fontFamily: 'CustomFontBold',
                      ),
                    ),
                  ],
                ),
                10.verticalSpace,
                Row(
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
                          setState(
                            () {
                              // Update searchKeyword with the value entered by the user
                              searchKeyword = value.trim();
                            },
                          );
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            MingCuteIcons.mgc_search_2_fill,
                            size: 18.r,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                  onPressed: () {
                                    setState(
                                      () {
                                        _resetFocus();
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
                            _refreshShoesList();
                          },
                        );
                      },
                    ),
                  ],
                ),
                10.verticalSpace,
                Expanded(
                  child: FutureBuilder<List<Shoes>>(
                    future: _shoesListFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: AnimatedBuilder(
                            animation: _loadingController,
                            builder: (_, child) {
                              return Transform.rotate(
                                angle: _loadingController.value * 2.0 * 3.14159,
                                child: child,
                              );
                            },
                            child: Icon(
                              MingCuteIcons.mgc_shoe_line,
                              size: 50.r,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error: ${snapshot.error}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 20.r,
                              fontFamily: 'CustomFont',
                            ),
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              MingCuteIcons.mgc_package_line,
                              size: 60.r,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            Text(
                              S.current.home_empty,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 22.r,
                                fontFamily: 'CustomFont',
                              ),
                            ),
                          ],
                        );
                      } else {
                        List<Shoes> shoesList = snapshot.data!;

                        // Sorting the list by date added
                        shoesList.sort(
                          (a, b) => b.dateAdded.compareTo(a.dateAdded),
                        );

                        // Filtering by brand
                        if (searchKeyword.isNotEmpty) {
                          shoesList = shoesList
                              .where(
                                (shoes) => shoes.brand.toLowerCase().contains(
                                      searchKeyword.toLowerCase(),
                                    ),
                              )
                              .toList();
                        }

                        List<Shoes> filteredShoes = shoesList.where(
                          (shoes) {
                            // Filtering by favourites
                            if (showOnlyFavorites && !shoes.isFavorite) {
                              return false;
                            }
                            // Filtering by color
                            if (selectedColor != null &&
                                shoes.color != selectedColor) {
                              return false;
                            }
                            // Filtering by season icon
                            if (selectedSeasonIcon != null &&
                                shoes.seasonIcon != selectedSeasonIcon) {
                              return false;
                            }
                            // Filtering by category
                            if (selectedCategory != 'All' &&
                                shoes.category != selectedCategory) {
                              return false;
                            }
                            // Filtering by type
                            if (selectedType != 'All' &&
                                shoes.type != selectedType) {
                              return false;
                            }
                            return true;
                          },
                        ).toList();

                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                currentGridColumns == GridColumns.gOne
                                    ? 1
                                    : currentGridColumns == GridColumns.gTwo
                                        ? 2
                                        : 3,
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 2,
                          ),
                          itemCount: filteredShoes.length,
                          itemBuilder: (context, index) {
                            // Calculate dimensions based on screen width and number of columns
                            final double cardWidth =
                                (screenWidth - 24.r) / numberOfColumns;
                            final double imageHeight = cardWidth * 1.2.r;
                            Shoes shoe = filteredShoes[index];
                            return GestureDetector(
                              onTap: () {
                                Get.to(
                                  () => ShoesDetailsPage(
                                    shoes: filteredShoes[index],
                                  ),
                                  transition: Transition.fadeIn,
                                )?.then(
                                  (_) {
                                    setState(
                                      () {
                                        _shoesListFuture =
                                            shoesService.getShoes();
                                        _resetFocus();
                                      },
                                    );
                                  },
                                );
                              },
                              child: Stack(
                                children: [
                                  SizedBox(
                                    width: cardWidth.r,
                                    height: imageHeight.r,
                                    child: Card(
                                      color: AppColors.lightGrey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                      ),
                                      elevation: 10,
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.network(
                                        shoe.imageUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 4.r,
                                    right: 4.r,
                                    child: LikeButton(
                                      onTap: (isLiked) {
                                        setState(
                                          () {
                                            filteredShoes[index].isFavorite =
                                                !filteredShoes[index]
                                                    .isFavorite;
                                          },
                                        );
                                        shoesService.updateShoes(
                                            filteredShoes[index].id!,
                                            filteredShoes[index],
                                            null);
                                        return Future.value(!isLiked);
                                      },
                                      likeBuilder: (bool isLiked) {
                                        filteredShoes[index].isFavorite;
                                        return Icon(
                                          filteredShoes[index].isFavorite
                                              ? MingCuteIcons.mgc_heart_fill
                                              : MingCuteIcons.mgc_heart_line,
                                          color: filteredShoes[index].isFavorite
                                              ? AppColors.errorColor
                                              : AppColors.smoothBlack,
                                          size: 24,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: ConvexAppBar(
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
            setState(() {});
            _searchFocusNode.unfocus();

            if (index == 0) {
              Get.to(
                () => const ProfilePage(),
                transition: Transition.fade,
                duration: const Duration(milliseconds: 500),
              );
            } else if (index == 1) {
              Get.to(
                () => ShoesAdderPage(onShoesAdded: _updateShoesList),
                transition: Transition.zoom,
                duration: const Duration(milliseconds: 500),
              );
            } else if (index == 2) {
              Get.to(
                () => const SettingsPage(),
                transition: Transition.fade,
                duration: const Duration(milliseconds: 500),
              );
            }
          },
          backgroundColor: Theme.of(context).colorScheme.secondary,
          color: Theme.of(context).colorScheme.primary,
          activeColor: Theme.of(context).colorScheme.primary,
          height: 60.r,
          curveSize: 100.r,
          style: TabStyle.fixedCircle,
        ),
      ),
    );
  }
}
