import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/shoes/shoes_model.dart';
import 'package:shox/shoes/shoes_service.dart';
import 'package:shox/shoes/shoes_updater.dart';
import 'package:shox/theme/app_colors.dart';

class ShoesDetailsPage extends StatefulWidget {
  final Shoes shoes;

  const ShoesDetailsPage({super.key, required this.shoes});

  @override
  ShoesDetailsPageState createState() => ShoesDetailsPageState();
}

class ShoesDetailsPageState extends State<ShoesDetailsPage> {
  late Shoes shoes;
  final ShoesService shoesService = ShoesService();

  @override
  void initState() {
    super.initState();
    shoes = widget.shoes;
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            'Delete',
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'CustomFontBold',
            ),
          ),
          content: Text(
            'Are you sure you want to delete this shoes?',
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: 18,
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
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
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
              child: const Text(
                'Confirm',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontFamily: 'CustomFont',
                ),
              ),
              onPressed: () {
                shoesService.deleteShoes(shoes.id!, shoes.imageUrl);
                // Show confirmation toastbar
                DelightToastBar(
                  snackbarDuration: const Duration(milliseconds: 1500),
                  builder: (context) => const ToastCard(
                    color: AppColors.confirmColor,
                    leading: Icon(
                      MingCuteIcons.mgc_check_fill,
                      size: 28,
                    ),
                    title: Text(
                      "Shoes deleted successfully",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  autoDismiss: true,
                ).show(context);
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
          padding: const EdgeInsets.symmetric(horizontal: 12),
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
                            insetPadding: const EdgeInsets.all(10),
                            child: Stack(
                              children: [
                                Center(
                                  child: Image.network(shoes.imageUrl),
                                ),
                                Positioned(
                                  top: 10,
                                  left: 10,
                                  child: IconButton(
                                    icon: Icon(MingCuteIcons.mgc_close_fill,
                                        size: 36,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary),
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
                        width: 280,
                        height: 280,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          'COLOR',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 24,
                            fontFamily: 'CustomFontBold',
                          ),
                        ),
                        Icon(
                          MingCuteIcons.mgc_palette_fill,
                          color: shoes.color,
                          size: 32,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: const Offset(1, 1),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'BRAND',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 24,
                            fontFamily: 'CustomFontBold',
                          ),
                        ),
                        Text(
                          shoes.brand,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 20,
                            fontFamily: 'CustomFont',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'SIZE',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 24,
                            fontFamily: 'CustomFontBold',
                          ),
                        ),
                        Text(
                          shoes.size,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 20,
                            fontFamily: 'CustomFont',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'SEASON',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 24,
                            fontFamily: 'CustomFontBold',
                          ),
                        ),
                        Icon(
                          shoes.seasonIcon,
                          color: Theme.of(context).colorScheme.tertiary,
                          size: 32,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: const Offset(1, 1),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'CATEGORY',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 24,
                            fontFamily: 'CustomFontBold',
                          ),
                        ),
                        Text(
                          shoes.category,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 20,
                            fontFamily: 'CustomFont',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'TYPE',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 24,
                            fontFamily: 'CustomFontBold',
                          ),
                        ),
                        Text(
                          shoes.type,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 20,
                            fontFamily: 'CustomFont',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'NOTES',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 24,
                    fontFamily: 'CustomFontBold',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    shoes.notes ?? '',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontSize: 16,
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
        width: 70,
        height: 70,
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
          child: Icon(MingCuteIcons.mgc_edit_2_fill,
              size: 32, color: Theme.of(context).colorScheme.primary),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
