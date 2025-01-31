import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/generated/l10n.dart';
import 'package:shox/models/shoes_model.dart';
import 'package:shox/utils/category_translations.dart';
import 'package:shox/screens/shoes/shoes_updater_screen.dart';
import 'package:shox/services/shoes_service.dart';
import 'package:shox/widgets/custom_delete_dialog.dart';
import 'package:shox/widgets/custom_full_image.dart';
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
      return _buildLoadingIndicator();
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
          return _buildLoadingIndicator();
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

  AppBar _buildAppBar(BuildContext context, ShoesModel shoe) {
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
        S.current.shoes_details_screen_title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.tertiary,
          fontWeight: FontWeight.bold,
          fontFamily: 'CustomFont',
        ),
      ),
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.secondary,
      actions: [
        _buildPopupMenu(context, shoe),
      ],
    );
  }

  Widget _buildPopupMenu(BuildContext context, ShoesModel shoe) {
    return PopupMenuButton<String>(
      color: Theme.of(context).colorScheme.secondary,
      icon: Icon(
        MingCuteIcons.mgc_more_2_fill,
        color: Theme.of(context).colorScheme.secondary,
      ),
      onSelected: (value) {
        if (value == 'edit') {
          Get.to(
            () => ShoesUpdaterScreen(shoes: shoe),
            transition: Transition.fade,
            duration: const Duration(milliseconds: 500),
          );
        } else if (value == 'delete') {
          _confirmDeleteShoes(context, shoe);
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          _buildPopupMenuItem(
            context,
            'edit',
            MingCuteIcons.mgc_edit_2_fill,
            S.current.shoes_details_screen_menu_edit,
          ),
          _buildPopupMenuItem(
            context,
            'delete',
            MingCuteIcons.mgc_delete_3_fill,
            S.current.shoes_details_screen_menu_delete,
          ),
        ];
      },
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(
      BuildContext context, String value, IconData icon, String text) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(width: 10.w),
          Text(
            text,
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: 14.sp,
              fontFamily: 'CustomFont',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
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
        S.current.shoes_details_screen_error_state,
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
    return Center(
      child: Text(
        S.current.shoes_details_screen_empty_state,
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

  Widget _buildShoesDetails(BuildContext context, ShoesModel shoe) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20.h,
          children: [
            _buildImage(context, shoe),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLeftColumn(context, shoe),
                SizedBox(width: 20.w),
                _buildRightColumn(context, shoe),
              ],
            ),
            _buildIconSection(
              context,
              S.current.text_season,
              shoe.seasonIcon!,
              Theme.of(context).colorScheme.tertiary,
            ),
            _buildNotesSection(context, shoe.notes),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context, ShoesModel shoe) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => CustomFullImage(imageUrl: shoe.imageUrl),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 500),
        );
      },
      child: Card(
        color: Theme.of(context).colorScheme.primary,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        child: Image.network(
          shoe.imageUrl,
          fit: BoxFit.cover,
          width: 280.w,
          height: 280.h,
        ),
      ),
    );
  }

  Widget _buildLeftColumn(BuildContext context, ShoesModel shoe) {
    return Column(
      spacing: 10.h,
      children: [
        _buildIconSection(
          context,
          S.current.text_color,
          MingCuteIcons.mgc_palette_fill,
          shoe.color,
        ),
        _buildTextSection(
          context,
          S.current.text_brand,
          shoe.brand,
        ),
        _buildTextSection(
          context,
          S.current.text_category,
          CategoryTranslations.translateCategory(
              shoe.category, currentLanguageCode),
        ),
      ],
    );
  }

  Widget _buildRightColumn(BuildContext context, ShoesModel shoe) {
    return Column(
      spacing: 10.h,
      children: [
        _buildIconSection(
          context,
          S.current.text_details_color,
          MingCuteIcons.mgc_palette_3_fill,
          shoe.detailsColor!,
        ),
        _buildTextSection(
          context,
          S.current.text_size,
          shoe.size,
        ),
        _buildTextSection(
          context,
          S.current.text_type,
          CategoryTranslations.translateType(shoe.type, currentLanguageCode),
        ),
      ],
    );
  }

  Widget _buildIconSection(
      BuildContext context, String text, IconData icon, Color iconColor) {
    return Column(
      children: [
        Text(
          text,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 22.sp,
            fontFamily: 'CustomFontBold',
          ),
        ),
        Icon(
          icon,
          color: iconColor,
          size: 32.sp,
          shadows: [
            Shadow(
              color: Colors.black.withValues(alpha: 0.2),
              offset: const Offset(1, 1),
              blurRadius: 5,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextSection(BuildContext context, String label, String details) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 22.sp,
            fontFamily: 'CustomFontBold',
          ),
        ),
        Text(
          details,
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 20.sp,
            fontFamily: 'CustomFont',
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection(BuildContext context, String? notes) {
    return Column(
      children: [
        Text(
          S.current.text_notes,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 22.sp,
            fontFamily: 'CustomFontBold',
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.r),
          child: Text(
            notes ?? '',
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: 16.sp,
              fontFamily: 'CustomFont',
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  void _confirmDeleteShoes(BuildContext context, ShoesModel shoe) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDeleteDialog(
          title: S.current.delete_shoes_title,
          content: S.current.delete_shoes_description,
          onCancelPressed: () {
            Get.back();
          },
          onConfirmPressed: () {
            _shoesService.deleteShoes(shoe.id!);
            if (shoe.imageUrl.isNotEmpty) {
              final fileName = shoe.imageUrl.split('/').last;
              _shoesService.deleteShoeImageSupabase(
                  currentUser!.uid, shoe.id!, fileName);
            }
            showSuccessToast(
              context,
              S.current.toast_delete_shoes_success,
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
