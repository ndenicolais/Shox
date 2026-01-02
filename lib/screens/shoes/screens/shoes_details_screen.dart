import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shox/common/widgets/app_bar_widget.dart';
import 'package:shox/common/widgets/empty_state_widget.dart';
import 'package:shox/common/widgets/error_state_widget.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';
import 'package:shox/core/utils/shoes_text_translations.dart';
import 'package:shox/screens/shoes/screens/shoes_updater_screen.dart';
import 'package:shox/screens/shoes/widgets/shoes_colors_section.dart';
import 'package:shox/features/shoes/controller/shoes_controller.dart';
import 'package:shox/theme/app_font_sizes.dart';
import 'package:shox/common/widgets/delete_dialog_widget.dart';
import 'package:shox/screens/shoes/widgets/full_screen_image.dart';
import 'package:shox/common/widgets/loader_widget.dart';
import 'package:shox/common/widgets/toast_widget.dart';

class ShoesDetailsScreen extends StatefulWidget {
  final String shoesId;

  const ShoesDetailsScreen({super.key, required this.shoesId});

  @override
  ShoesDetailsScreenState createState() => ShoesDetailsScreenState();
}

class ShoesDetailsScreenState extends State<ShoesDetailsScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final ShoesController _shoesController = ShoesController();
  final ScreenshotController _screenshotController = ScreenshotController();
  late String currentLanguageCode;
  bool isShoesDeleted = false;

  @override
  Widget build(BuildContext context) {
    if (isShoesDeleted) {
      return LoaderWidget(
        width: 50.w,
        height: 50.h,
      );
    }
    return _buildShoesStream(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentLanguageCode = Localizations.localeOf(context).languageCode;
  }

  Widget _buildShoesStream(BuildContext context) {
    return StreamBuilder<ShoesModel>(
      stream: _shoesController.getShoesById(widget.shoesId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoaderWidget(
            width: 50.w,
            height: 50.h,
          );
        }

        if (snapshot.hasError) {
          return ErrorStateWidget(
            message:
                AppLocalizations.of(context)!.shoes_details_screen_error_state,
          );
        }

        if (!snapshot.hasData) {
          return EmptyStateWidget(
            message:
                AppLocalizations.of(context)!.shoes_details_screen_empty_state,
            icon: MingCuteIcons.mgc_shoe_line,
            iconColor: Theme.of(context).colorScheme.secondary,
          );
        }

        final shoes = snapshot.data!;

        return Scaffold(
          appBar: AppBarWidget(
            title: AppLocalizations.of(context)!.shoes_details_screen_title,
            actions: [_buildPopupMenu(shoes)],
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          body: Screenshot(
            controller: _screenshotController,
            child: Container(
              color: Theme.of(context).colorScheme.primary,
              child: _buildShoesDetails(shoes),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPopupMenu(ShoesModel shoes) {
    return PopupMenuButton<String>(
      color: Theme.of(context).colorScheme.primary,
      icon: Icon(
        MingCuteIcons.mgc_more_2_line,
        color: Theme.of(context).colorScheme.secondary,
      ),
      onSelected: (value) {
        if (value == 'edit') {
          Get.to(
            () => ShoesUpdaterScreen(shoes: shoes),
            transition: Transition.fade,
            duration: const Duration(milliseconds: 500),
          );
        } else if (value == 'delete') {
          _deleteShoes(context, shoes);
        } else if (value == 'share') {
          _shareScreenshot(context);
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          _buildPopupMenuItem(
            'edit',
            MingCuteIcons.mgc_edit_2_line,
            AppLocalizations.of(context)!.shoes_details_screen_menu_edit,
          ),
          _buildPopupMenuItem(
            'share',
            MingCuteIcons.mgc_share_3_line,
            AppLocalizations.of(context)!.shoes_details_screen_menu_share,
          ),
          _buildPopupMenuItem(
            'delete',
            MingCuteIcons.mgc_delete_3_line,
            AppLocalizations.of(context)!.shoes_details_screen_menu_delete,
          ),
        ];
      },
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(
    String value,
    IconData icon,
    String text,
  ) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.secondary,
          ),
          SizedBox(width: 10.w),
          Text(
            text,
            style: GoogleFonts.montserrat(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: AppFontSizes.small,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShoesDetails(ShoesModel shoes) {
    return SingleChildScrollView(
      child: Column(
        spacing: 10.h,
        children: [
          _buildImageCard(context, shoes.imageUrl),
          ShoesColorsSection(shoes: shoes),
          _buildInfoTile(
            icon: MingCuteIcons.mgc_tag_line,
            label:
                AppLocalizations.of(context)!.shoes_details_screen_field_brand,
            value: shoes.brand,
          ),
          _buildInfoTile(
            icon: MingCuteIcons.mgc_ruler_line,
            label:
                AppLocalizations.of(context)!.shoes_details_screen_field_size,
            value: shoes.size,
          ),
          _buildInfoTile(
            icon: MingCuteIcons.mgc_grid_line,
            label: AppLocalizations.of(context)!
                .shoes_details_screen_field_category,
            value: ShoesTextTranslations.translateCategory(
              shoes.category,
              currentLanguageCode,
            ),
          ),
          _buildInfoTile(
            icon: MingCuteIcons.mgc_shoe_line,
            label:
                AppLocalizations.of(context)!.shoes_details_screen_field_type,
            value: ShoesTextTranslations.translateType(
              shoes.type,
              currentLanguageCode,
            ),
          ),
          _buildInfoTile(
            icon: MingCuteIcons.mgc_cloud_line,
            label:
                AppLocalizations.of(context)!.shoes_details_screen_field_season,
            value: ShoesTextTranslations.translateSeason(
              shoes.season!,
              currentLanguageCode,
            ),
          ),
          if (shoes.notes != null && shoes.notes!.isNotEmpty)
            _buildNotesContent(context, shoes.notes!),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildImageCard(BuildContext context, String imageUrl) {
    final double imageWidth = ScreenUtil().screenWidth > 600 ? 480.w : 280.w;
    final double imageHeight = ScreenUtil().screenWidth > 600 ? 480.h : 280.h;

    return GestureDetector(
      onTap: () {
        Get.to(
          () => FullScreenImage(imageUrl: imageUrl),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 500),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(50.r)),
        child: Card(
          color: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          elevation: 0,
          clipBehavior: Clip.antiAlias,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            width: imageWidth,
            height: imageHeight,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Theme.of(context).colorScheme.surface,
              child: Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      spacing: 4.h,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: Theme.of(context).colorScheme.secondary,
            ),
            SizedBox(width: 4.w),
            Text(
              label.toUpperCase(),
              style: GoogleFonts.montserrat(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: AppFontSizes.small,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: AppFontSizes.regular,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildNotesContent(BuildContext context, String notes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      spacing: 6.h,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              MingCuteIcons.mgc_document_line,
              size: 16.sp,
              color: Theme.of(context).colorScheme.secondary,
            ),
            SizedBox(width: 4.w),
            Text(
              AppLocalizations.of(context)!
                  .shoes_details_screen_field_note
                  .toUpperCase(),
              style: GoogleFonts.montserrat(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: AppFontSizes.small,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        Container(
          width: 260.w,
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withAlpha(60),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary.withAlpha(60),
            ),
          ),
          child: Text(
            notes,
            style: GoogleFonts.montserrat(
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: AppFontSizes.small,
              fontWeight: FontWeight.w400,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _shareScreenshot(BuildContext context) async {
    try {
      final String timestamp =
          DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final image = await _screenshotController.capture();

      if (image != null) {
        final tempDir = await getTemporaryDirectory();
        final imagePath = '${tempDir.path}/shox_shoes_$timestamp.png';
        final imageFile = File(imagePath)..writeAsBytesSync(image);

        final shareResult = await Share.shareXFiles(
          [XFile(imageFile.path)],
          text: 'My shoes from Shox',
        );

        if (context.mounted) {
          if (shareResult.status == ShareResultStatus.success) {
            showSuccessToast(
              context,
              AppLocalizations.of(context)!.shoes_details_screen_share_success,
            );
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        showErrorToast(
          context,
          AppLocalizations.of(context)!.shoes_details_screen_share_error,
        );
      }
    }
  }

  void _deleteShoes(BuildContext context, ShoesModel shoes) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteDialogWidget(
          title:
              AppLocalizations.of(context)!.shoes_details_screen_delete_title,
          content: AppLocalizations.of(context)!
              .shoes_details_screen_delete_description,
          onCancelPressed: () {
            Get.back();
          },
          onConfirmPressed: () {
            _shoesController.deleteShoes(shoes);
            showSuccessToast(
              context,
              AppLocalizations.of(context)!
                  .shoes_details_screen_delete_toast_success,
            );
            setState(() {
              isShoesDeleted = true;
            });
            Get.back();
            Get.back();
          },
        );
      },
    );
  }
}
