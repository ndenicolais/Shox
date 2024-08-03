import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/generated/l10n.dart';
import 'package:shox/models/shoes_model.dart';
import 'package:shox/pages/shoes/shoes_languages.dart';
import 'package:shox/services/shoes_service.dart';
import 'package:shox/pages/shoes/shoes_updater.dart';
import 'package:shox/theme/app_colors.dart';
import 'package:shox/widgets/custom_toast_bar.dart';

class ShoesDetailsPage extends StatefulWidget {
  final Shoes shoes;

  const ShoesDetailsPage({super.key, required this.shoes});

  @override
  ShoesDetailsPageState createState() => ShoesDetailsPageState();
}

class ShoesDetailsPageState extends State<ShoesDetailsPage> {
  late Shoes shoes;
  final ShoesService shoesService = ShoesService();
  late String currentLanguageCode;

  @override
  void initState() {
    super.initState();
    shoes = widget.shoes;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentLanguageCode = Localizations.localeOf(context).languageCode;
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            S.current.delete_shoes_title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: 20.r,
              fontWeight: FontWeight.bold,
              fontFamily: 'CustomFontBold',
            ),
          ),
          content: Text(
            S.current.delete_shoes_description,
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: 18.r,
              fontFamily: 'CustomFont',
            ),
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  AppColors.errorColor,
                ),
              ),
              child: Text(
                S.current.delete_shoes_cancel,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16.r,
                  fontFamily: 'CustomFont',
                ),
              ),
              onPressed: () {
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
                S.current.delete_shoes_confirm,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16.r,
                  fontFamily: 'CustomFont',
                ),
              ),
              onPressed: () {
                shoesService.deleteShoes(shoes.id!, shoes.imageUrl);
                // Show confirmation toastbar
                _showConfirmToastBar();
                // Close the dialog
                Get.back();
                // Back to previous screen
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateShoes(Shoes updatedShoes) {
    setState(
      () {
        shoes = updatedShoes;
      },
    );
  }

  void _showConfirmToastBar() {
    // Show confirm toastbar
    showCustomToastBar(
      context,
      position: DelightSnackbarPosition.bottom,
      color: AppColors.confirmColor,
      icon: const Icon(
        MingCuteIcons.mgc_check_fill,
      ),
      title: S.current.toast_delete_shoes_success,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            MingCuteIcons.mgc_large_arrow_left_fill,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          S.current.details_title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontWeight: FontWeight.bold,
            fontFamily: 'CustomFont',
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              MingCuteIcons.mgc_delete_fill,
              color: AppColors.errorColor,
            ),
            onPressed: () {
              _showDeleteConfirmationDialog(context);
            },
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.secondary,
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.r, horizontal: 10.r),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            backgroundColor: Colors.white,
                            insetPadding: EdgeInsets.all(10.r),
                            child: Stack(
                              children: [
                                Center(
                                  child: Image.network(shoes.imageUrl),
                                ),
                                Positioned(
                                  top: 10.r,
                                  left: 10.r,
                                  child: IconButton(
                                    icon: Icon(MingCuteIcons.mgc_close_fill,
                                        size: 36.r,
                                        color: AppColors.smoothBlack),
                                    onPressed: () {
                                      Get.back();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Card(
                      color: Theme.of(context).colorScheme.primary,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      elevation: 0,
                      clipBehavior: Clip.antiAlias,
                      child: Image.network(
                        shoes.imageUrl,
                        fit: BoxFit.cover,
                        width: 280.r,
                        height: 280.r,
                      ),
                    ),
                  ),
                ),
                20.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          S.current.text_color,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 24.r,
                            fontFamily: 'CustomFontBold',
                          ),
                        ),
                        Icon(
                          MingCuteIcons.mgc_palette_fill,
                          color: shoes.color,
                          size: 32.r,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: const Offset(1, 1),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        14.verticalSpace,
                        Text(
                          S.current.text_brand,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 24.r,
                            fontFamily: 'CustomFontBold',
                          ),
                        ),
                        Text(
                          shoes.brand,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 20.r,
                            fontFamily: 'CustomFont',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        14.verticalSpace,
                        Text(
                          S.current.text_size,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 24.r,
                            fontFamily: 'CustomFontBold',
                          ),
                        ),
                        Text(
                          shoes.size,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 20.r,
                            fontFamily: 'CustomFont',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          S.current.text_season,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 24.r,
                            fontFamily: 'CustomFontBold',
                          ),
                        ),
                        Icon(
                          shoes.seasonIcon,
                          color: Theme.of(context).colorScheme.tertiary,
                          size: 32.r,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: const Offset(1, 1),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        14.verticalSpace,
                        Text(
                          S.current.text_category,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 24.r,
                            fontFamily: 'CustomFontBold',
                          ),
                        ),
                        Text(
                          ShoesLanguages.translateCategory(
                              shoes.category, currentLanguageCode),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 20.r,
                            fontFamily: 'CustomFont',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        14.verticalSpace,
                        Text(
                          S.current.text_type,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 24.r,
                            fontFamily: 'CustomFontBold',
                          ),
                        ),
                        Text(
                          ShoesLanguages.translateType(
                              shoes.type, currentLanguageCode),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 20.r,
                            fontFamily: 'CustomFont',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                14.verticalSpace,
                Text(
                  S.current.text_notes,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 24.r,
                    fontFamily: 'CustomFontBold',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.r),
                  child: Text(
                    shoes.notes ?? '',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontSize: 16.r,
                      fontFamily: 'CustomFont',
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 70.r,
        height: 70.r,
        child: FloatingActionButton(
          onPressed: () async {
            final updatedShoes = await Get.to(
              () => ShoesUpdaterPage(shoes: shoes),
            );

            if (updatedShoes != null) {
              _updateShoes(updatedShoes);
            }
          },
          backgroundColor: Theme.of(context).colorScheme.secondary,
          shape: const CircleBorder(),
          child: Icon(
            MingCuteIcons.mgc_edit_2_fill,
            size: 32.r,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
