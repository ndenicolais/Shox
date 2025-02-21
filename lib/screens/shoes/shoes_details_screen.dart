import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/models/shoes_model.dart';
import 'package:shox/utils/custom_icons.dart';
import 'package:shox/utils/shoes_text_translations.dart';
import 'package:shox/screens/shoes/shoes_updater_screen.dart';
import 'package:shox/services/shoes_service.dart';
import 'package:shox/widgets/custom_delete_dialog.dart';
import 'package:shox/widgets/full_screen_image.dart';
import 'package:shox/widgets/custom_loader.dart';
import 'package:shox/widgets/custom_toast_bar.dart';

class ShoesDetailsScreen extends StatefulWidget {
  final String shoesId;

  const ShoesDetailsScreen({super.key, required this.shoesId});

  @override
  ShoesDetailsScreenState createState() => ShoesDetailsScreenState();
}

class ShoesDetailsScreenState extends State<ShoesDetailsScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final ShoesService _shoesService = ShoesService();
  late String currentLanguageCode;
  bool isShoesDeleted = false;

  @override
  Widget build(BuildContext context) {
    if (isShoesDeleted) {
      return _buildLoadingIndicator(context);
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
      stream: _shoesService.getShoesStreamById(widget.shoesId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingIndicator(context);
        }

        if (snapshot.hasError) {
          return _buildErrorState(context);
        }

        if (!snapshot.hasData) {
          return _buildEmptyState(context);
        }

        final shoes = snapshot.data!;

        return Scaffold(
          appBar: _buildAppBar(context, shoes),
          backgroundColor: Theme.of(context).colorScheme.primary,
          body: _buildShoesDetails(context, shoes),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, ShoesModel shoes) {
    return AppBar(
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
        AppLocalizations.of(context)!.shoes_details_screen_title,
        style: GoogleFonts.montserrat(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.secondary,
      actions: [
        _buildPopupMenu(context, shoes),
      ],
    );
  }

  Widget _buildPopupMenu(BuildContext context, ShoesModel shoes) {
    return PopupMenuButton<String>(
      color: Theme.of(context).colorScheme.primary,
      icon: Icon(
        MingCuteIcons.mgc_more_2_fill,
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
          _confirmDeleteShoes(context, shoes);
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          _buildPopupMenuItem(
            context,
            'edit',
            MingCuteIcons.mgc_edit_2_fill,
            AppLocalizations.of(context)!.shoes_details_screen_menu_edit,
          ),
          _buildPopupMenuItem(
            context,
            'delete',
            MingCuteIcons.mgc_delete_3_fill,
            AppLocalizations.of(context)!.shoes_details_screen_menu_delete,
          ),
        ];
      },
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(
    BuildContext context,
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
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return Center(
      child: CustomLoader(
        width: 50.w,
        height: 50.h,
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Text(
        AppLocalizations.of(context)!.shoes_details_screen_error_state,
        style: GoogleFonts.montserrat(
          color: Theme.of(context).colorScheme.tertiary,
          fontSize: 22.sp,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Text(
        AppLocalizations.of(context)!.shoes_details_screen_empty_state,
        style: GoogleFonts.montserrat(
          color: Theme.of(context).colorScheme.tertiary,
          fontSize: 22.sp,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildShoesDetails(BuildContext context, ShoesModel shoes) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.r),
        child: Column(
          spacing: 10.h,
          children: [
            _buildImageCard(context, shoes),
            _buildDetails(context, shoes),
            _buildNotesSection(context, shoes.notes),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context, String imageUrl) {
    final double imageWidth = ScreenUtil().screenWidth > 600 ? 560.w : 260.w;
    final double imageHeight = ScreenUtil().screenWidth > 600 ? 560.h : 260.h;

    return Card(
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
      ),
    );
  }

  Widget _buildImageCard(BuildContext context, ShoesModel shoes) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => FullScreenImage(imageUrl: shoes.imageUrl),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 500),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
        child: _buildImage(context, shoes.imageUrl),
      ),
    );
  }

  Widget _buildDetails(BuildContext context, ShoesModel shoes) {
    return Column(
      spacing: 10.h,
      children: [
        Column(
          children: [
            Text(
              AppLocalizations.of(context)!.shoes_details_screen_field_color,
              style: GoogleFonts.montserrat(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 20.w,
              children: [
                _buildColorSection(
                  context,
                  AppLocalizations.of(context)!
                      .shoes_details_screen_field_color_primary,
                  ShoxIcons.iconShoesPrimary,
                  shoes.colorPrimary,
                ),
                _buildColorSection(
                  context,
                  AppLocalizations.of(context)!
                      .shoes_details_screen_field_color_secondary,
                  ShoxIcons.iconShoesSecondary,
                  shoes.colorSecondary!,
                ),
              ],
            ),
          ],
        ),
        _buildTextSection(
          context,
          AppLocalizations.of(context)!.shoes_details_screen_field_brand,
          shoes.brand,
        ),
        _buildTextSection(
          context,
          AppLocalizations.of(context)!.shoes_details_screen_field_size,
          shoes.size,
        ),
        _buildTextSection(
          context,
          AppLocalizations.of(context)!.shoes_details_screen_field_category,
          ShoesTextTranslations.translateCategory(
            shoes.category,
            currentLanguageCode,
          ),
        ),
        _buildTextSection(
          context,
          AppLocalizations.of(context)!.shoes_details_screen_field_type,
          ShoesTextTranslations.translateType(
            shoes.type,
            currentLanguageCode,
          ),
        ),
        _buildTextSection(
          context,
          AppLocalizations.of(context)!.shoes_details_screen_field_season,
          ShoesTextTranslations.translateSeason(
            shoes.season!,
            currentLanguageCode,
          ),
        ),
      ],
    );
  }

  Widget _buildColorSection(
    BuildContext context,
    String label,
    IconData icon,
    Color iconColor,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        Icon(
          icon,
          size: 36.sp,
          color: iconColor,
        ),
      ],
    );
  }

  Widget _buildTextSection(
    BuildContext context,
    String label,
    String details,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          details,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection(BuildContext context, String? notes) {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.shoes_details_screen_field_note,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.r),
          child: Text(
            notes ?? '',
            style: GoogleFonts.montserrat(
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  void _confirmDeleteShoes(BuildContext context, ShoesModel shoes) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDeleteDialog(
          title:
              AppLocalizations.of(context)!.shoes_details_screen_delete_title,
          content: AppLocalizations.of(context)!
              .shoes_details_screen_delete_description,
          onCancelPressed: () {
            Get.back();
          },
          onConfirmPressed: () {
            _shoesService.deleteShoes(shoes.id!);
            if (shoes.imageUrl.isNotEmpty) {
              final fileName = shoes.imageUrl.split('/').last;
              _shoesService.deleteShoesImageSupabase(
                  currentUser!.uid, shoes.id!, fileName);
            }
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
