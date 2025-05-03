import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/models/shoes_model.dart';
import 'package:shox/utils/custom_icons.dart';
import 'package:shox/utils/shoes_text_translations.dart';
import 'package:shox/services/shoes_service.dart';
import 'package:shox/theme/app_colors.dart';
import 'package:shox/utils/permission_helper.dart';
import 'package:shox/utils/utils.dart';
import 'package:shox/widgets/custom_dropdown.dart';
import 'package:shox/widgets/custom_loader.dart';
import 'package:shox/widgets/custom_toast_bar.dart';
import 'package:shox/widgets/shoes_textfield.dart';

class ShoesUpdaterScreen extends StatefulWidget {
  final ShoesModel shoes;

  const ShoesUpdaterScreen({super.key, required this.shoes});

  @override
  ShoesUpdaterScreenState createState() => ShoesUpdaterScreenState();
}

class ShoesUpdaterScreenState extends State<ShoesUpdaterScreen>
    with SingleTickerProviderStateMixin {
  final Logger _logger = Logger();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final ShoesService _shoesService = ShoesService();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  String? _existingImageUrl;
  String? _removedExistingImages;
  File? _newImage;
  Color _colorPrimary = AppColors.smoothBlack;
  Color _colorSecondary = Colors.transparent;
  bool _colorPrimarySelected = false;
  bool _colorSecondarySelected = false;
  late TextEditingController _brandController;
  late TextEditingController _sizeController;
  late TextEditingController _categoryController;
  late TextEditingController _typeController;
  late TextEditingController _seasonController;
  late TextEditingController _notesController;
  late String _languageCode;
  late Map<String, String> translatedCategoryOptions;
  late Map<String, String> translatedTypeOptions;
  late Map<String, String> translatedSeasonOptions;
  bool isSaveLoading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: _buildAppBar(context),
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.r),
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 10.h,
                    children: [
                      _buildImageSelector(context),
                      _buildColorSelector(context),
                      _buildBrandTextField(context),
                      _buildSizeTextField(context),
                      _buildCategoryDropdown(context),
                      _buildTypeDropdown(context),
                      _buildSeasonDropdown(context),
                      _buildNotesTextField(context),
                      _buildSaveButton(context),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
            if (isSaveLoading)
              Container(
                color: Theme.of(context)
                    .colorScheme
                    .tertiary
                    .withValues(alpha: 0.7),
                child: Center(
                  child: _buildLoadingIndicator(context),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadShoes();
  }

  void loadShoes() {
    _existingImageUrl = widget.shoes.imageUrl;
    _colorPrimary = widget.shoes.colorPrimary;
    _colorPrimarySelected = true;
    _colorSecondary = widget.shoes.colorSecondary!;
    _colorSecondarySelected = true;
    _brandController = TextEditingController(text: widget.shoes.brand);
    _sizeController = TextEditingController(text: widget.shoes.size.toString());
    _categoryController = TextEditingController(text: widget.shoes.category);
    _typeController = TextEditingController(text: widget.shoes.type);
    _seasonController = TextEditingController(text: widget.shoes.season);
    _notesController = TextEditingController(text: widget.shoes.notes);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _languageCode = Localizations.localeOf(context).languageCode;
    translatedCategoryOptions =
        ShoesTextTranslations.categoryTranslations[_languageCode] ?? {};
    translatedTypeOptions =
        ShoesTextTranslations.typeTranslations[_languageCode] ?? {};
    translatedSeasonOptions =
        ShoesTextTranslations.seasonTranslations[_languageCode] ?? {};
  }

  Future<File?> _cropImage(File imageFile) async {
    final extension = imageFile.path.split('.').last.toLowerCase();
    final format = (extension == 'png')
        ? ImageCompressFormat.png
        : ImageCompressFormat.jpg;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      compressFormat: format,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: AppLocalizations.of(context)!
              .shoes_updater_screen_crop_image_title,
          toolbarColor: Theme.of(context).colorScheme.secondary,
          statusBarColor: Theme.of(context).colorScheme.secondary,
          toolbarWidgetColor: Theme.of(context).colorScheme.primary,
          activeControlsWidgetColor: Theme.of(context).colorScheme.secondary,
          initAspectRatio: CropAspectRatioPreset.original,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          lockAspectRatio: false,
          hideBottomControls: false,
          showCropGrid: true,
        ),
        IOSUiSettings(
          title: AppLocalizations.of(context)!
              .shoes_updater_screen_crop_image_title,
        ),
      ],
    );
    return croppedFile != null ? File(croppedFile.path) : null;
  }

  Future<void> _pickImage(ImageSource source) async {
    await requestStoragePermission(context, () async {
      final XFile? pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        File? croppedImage = await _cropImage(File(pickedFile.path));
        if (croppedImage != null) {
          File compressedImage = await _compressImage(croppedImage);
          setState(() {
            _newImage = compressedImage;
          });
        }
      } else {
        _logger.e("Error: no image selected");
      }
    });
  }

  Future<File> _compressImage(File imageFile) async {
    final extension = imageFile.path.split('.').last.toLowerCase();
    final format =
        (extension == 'png') ? CompressFormat.png : CompressFormat.jpeg;

    final compressedBytes = await FlutterImageCompress.compressWithFile(
      imageFile.path,
      quality: 70,
      format: format,
    );

    final compressedFile = File(imageFile.path);
    await compressedFile.writeAsBytes(compressedBytes!);
    return compressedFile;
  }

  void _removeExistingImage() {
    setState(() {
      if (_existingImageUrl != null && _existingImageUrl!.isNotEmpty) {
        _removedExistingImages = _existingImageUrl;
        _existingImageUrl = null;
      }
    });
  }

  void _removeNewImage() {
    setState(() {
      _newImage = null;
    });
  }

  void _updateShoes() async {
    if (_formKey.currentState!.validate()) {
      if (_newImage != null) {
        final path = await _shoesService.addShoesImageSupabase(
            currentUser!.uid, widget.shoes.id!, _newImage!);
        final fileName = path.split('/').last;
        _existingImageUrl = _shoesService.getShoesImageUrlSupabase(
            currentUser!.uid, widget.shoes.id!, fileName);

        if (_removedExistingImages != null) {
          final existingFileName = _removedExistingImages!.split('/').last;
          try {
            await _shoesService.deleteShoesImageSupabase(
                currentUser!.uid, widget.shoes.id!, existingFileName);
            _logger.i("Deleted existing image: $existingFileName");
          } catch (e) {
            _logger.e(
                "Failed to delete existing image: $existingFileName, error: $e");
          }
        }
      }

      setState(() {
        isSaveLoading = true;
      });

      final updateShoe = ShoesModel(
        id: widget.shoes.id,
        imageUrl: _existingImageUrl!,
        colorPrimary: _colorPrimary,
        colorSecondary: _colorSecondary,
        brand: _brandController.text.trim(),
        size: _sizeController.text,
        category: _categoryController.text,
        type: _typeController.text,
        season: _seasonController.text,
        notes: _notesController.text,
        dateAdded: widget.shoes.dateAdded,
        dateUpdated: DateTime.now(),
      );

      await _shoesService.updateShoes(updateShoe);

      if (mounted) {
        showSuccessToast(
          context,
          AppLocalizations.of(context)!.shoes_updater_screen_toast_success,
        );
        Get.back();
      }

      setState(() {
        isSaveLoading = false;
      });
    }
  }

  AppBar _buildAppBar(BuildContext context) {
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
        AppLocalizations.of(context)!.shoes_adder_screen_title,
        style: GoogleFonts.montserrat(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.secondary,
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

  void _showImageSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.primary,
      builder: (BuildContext context) {
        return SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                iconSize: 32.sp,
                icon: Icon(MingCuteIcons.mgc_camera_2_fill,
                    color: Theme.of(context).colorScheme.secondary),
                onPressed: () {
                  _pickImage(ImageSource.camera);
                  Get.back();
                },
              ),
              IconButton(
                iconSize: 32.sp,
                icon: Icon(MingCuteIcons.mgc_photo_album_2_fill,
                    color: Theme.of(context).colorScheme.secondary),
                onPressed: () {
                  _pickImage(ImageSource.gallery);
                  Get.back();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageSelector(BuildContext context) {
    return Column(
      children: [
        if (_newImage == null &&
            (_existingImageUrl == null || _existingImageUrl!.isEmpty))
          CircleAvatar(
            radius: 80.r,
            backgroundColor:
                Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2),
            child: IconButton(
              icon: Icon(
                MingCuteIcons.mgc_pic_fill,
                color: Theme.of(context).colorScheme.tertiary,
                size: 100.sp,
              ),
              onPressed: () {
                _showImageSelector(context);
              },
            ),
          ),
        if (_newImage != null)
          Stack(
            children: [
              Card(
                color: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.r),
                ),
                elevation: 0,
                clipBehavior: Clip.antiAlias,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10.r)),
                  child: Image.file(
                    File(_newImage!.path),
                    width: 200.w,
                    height: 200.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: -4,
                right: -4,
                child: IconButton(
                  icon: Icon(
                    MingCuteIcons.mgc_close_fill,
                    size: 30.sp,
                    color: AppColors.errorColor,
                  ),
                  onPressed: () {
                    _removeNewImage();
                  },
                ),
              ),
            ],
          ),
        if (_existingImageUrl != null && _existingImageUrl!.isNotEmpty)
          Stack(
            children: [
              Card(
                color: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.r),
                ),
                elevation: 0,
                clipBehavior: Clip.antiAlias,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10.r)),
                  child: Image.network(
                    _existingImageUrl!,
                    width: 200.w,
                    height: 200.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: -4,
                right: -4,
                child: IconButton(
                  icon: Icon(
                    MingCuteIcons.mgc_close_fill,
                    size: 30.sp,
                    color: AppColors.errorColor,
                  ),
                  onPressed: () {
                    _removeExistingImage();
                  },
                ),
              ),
            ],
          )
      ],
    );
  }

  Widget _buildColorSelector(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return _buildColorPrimaryDialog(context);
              },
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 14.r),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.secondary,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(50.r),
            ),
            child: Row(
              children: [
                if (_colorPrimarySelected)
                  Row(
                    children: [
                      SizedBox(width: 10.w),
                      Icon(
                        ShoxIcons.iconShoesPrimary,
                        color: _colorPrimary,
                        size: 32.sp,
                        shadows: [
                          Shadow(
                            offset: const Offset(1, 1),
                            blurRadius: 12,
                            color: Colors.black.withValues(alpha: 0.5),
                          ),
                        ],
                      ),
                    ],
                  ),
                SizedBox(width: 10.w),
                Text(
                  AppLocalizations.of(context)!
                      .shoes_updater_screen_field_color_primary,
                  style: GoogleFonts.montserrat(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 16.sp,
                  ),
                ),
                const Spacer(),
                Icon(
                  MingCuteIcons.mgc_down_line,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                SizedBox(width: 10.w),
              ],
            ),
          ),
        ),
        SizedBox(height: 10.h),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return _buildColorSecondaryDialog(context);
              },
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 14.r),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.secondary,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(50.r),
            ),
            child: Row(
              children: [
                if (_colorSecondarySelected)
                  Row(
                    children: [
                      SizedBox(width: 10.w),
                      Icon(
                        ShoxIcons.iconShoesSecondary,
                        color: _colorSecondary,
                        size: 32.sp,
                        shadows: [
                          Shadow(
                            offset: const Offset(1, 1),
                            blurRadius: 12,
                            color: Colors.black.withValues(alpha: 0.5),
                          ),
                        ],
                      ),
                    ],
                  ),
                SizedBox(width: 10.w),
                Text(
                  AppLocalizations.of(context)!
                      .shoes_updater_screen_field_color_secondary,
                  style: GoogleFonts.montserrat(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 16.sp,
                  ),
                ),
                const Spacer(),
                Icon(
                  MingCuteIcons.mgc_down_line,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                SizedBox(width: 10.w),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildColorPrimaryDialog(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Container(
        padding: EdgeInsets.all(12.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!
                  .shoes_updater_screen_field_color_primary_selection,
              style: GoogleFonts.montserrat(
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16.h),
            Wrap(
              spacing: 8.r,
              runSpacing: 8.r,
              children: colorList.map((colorPrimary) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _colorPrimary = colorPrimary;
                      _colorPrimarySelected = true;
                      Get.back();
                    });
                  },
                  child: Icon(
                    ShoxIcons.iconShoesPrimary,
                    size: 28.sp,
                    color: colorPrimary,
                    shadows: [
                      Shadow(
                        offset: const Offset(1, 1),
                        blurRadius: 1,
                        color: Colors.black.withValues(alpha: 0.5),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSecondaryDialog(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Container(
        padding: EdgeInsets.all(12.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!
                  .shoes_updater_screen_field_color_secondary_selection,
              style: GoogleFonts.montserrat(
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16.h),
            Wrap(
              spacing: 8.r,
              runSpacing: 8.r,
              children: colorList.map((colorSecondary) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _colorSecondary = colorSecondary;
                      _colorSecondarySelected = true;
                      Get.back();
                    });
                  },
                  child: Icon(
                    ShoxIcons.iconShoesSecondary,
                    size: 28.sp,
                    color: colorSecondary,
                    shadows: [
                      Shadow(
                        offset: const Offset(1, 1),
                        blurRadius: 1,
                        color: Colors.black.withValues(alpha: 0.5),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandTextField(BuildContext context) {
    return ShoesTextField(
      controller: _brandController,
      labelText: AppLocalizations.of(context)!.shoes_updater_screen_field_brand,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.sentences,
      validator: (val) => val!.isEmpty
          ? AppLocalizations.of(context)!.shoes_updater_screen_toast_error_brand
          : null,
    );
  }

  Widget _buildSizeTextField(BuildContext context) {
    return ShoesTextField(
      controller: _sizeController,
      labelText: AppLocalizations.of(context)!.shoes_updater_screen_field_size,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      validator: (val) => val!.isEmpty
          ? AppLocalizations.of(context)!.shoes_updater_screen_toast_error_size
          : null,
    );
  }

  Widget _buildCategoryDropdown(BuildContext context) {
    return CustomDropdown<String>(
      label: AppLocalizations.of(context)!.shoes_updater_screen_field_category,
      value:
          _categoryController.text.isNotEmpty ? _categoryController.text : null,
      onChanged: (newValue) {
        setState(
          () {
            _categoryController.text = newValue!;
            _typeController.text = '';
          },
        );
      },
      items: translatedCategoryOptions.keys.map((category) {
        return DropdownMenuItem<String>(
          value: category,
          child: Text(
            translatedCategoryOptions[category] ?? category,
            style: GoogleFonts.montserrat(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        );
      }).toList(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget _buildTypeDropdown(BuildContext context) {
    return CustomDropdown<String>(
      label: AppLocalizations.of(context)!.shoes_updater_screen_field_type,
      value: _typeController.text.isNotEmpty ? _typeController.text : null,
      onChanged: (newValue) {
        setState(
          () {
            _typeController.text = newValue!;
          },
        );
      },
      items: ShoesModel.categoryToTypes[_categoryController.text]?.map((type) {
            return DropdownMenuItem<String>(
              value: type,
              child: Text(
                translatedTypeOptions[type] ?? type,
                style: GoogleFonts.montserrat(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            );
          }).toList() ??
          [],
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget _buildSeasonDropdown(BuildContext context) {
    return CustomDropdown<String>(
      label: AppLocalizations.of(context)!.shoes_updater_screen_field_season,
      value: _seasonController.text.isNotEmpty ? _seasonController.text : null,
      onChanged: (newValue) {
        setState(() {
          _seasonController.text = newValue!;
        });
      },
      items: translatedSeasonOptions.keys.map((season) {
        return DropdownMenuItem<String>(
          value: season,
          child: Text(
            translatedSeasonOptions[season] ?? season,
            style: GoogleFonts.montserrat(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        );
      }).toList(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget _buildNotesTextField(BuildContext context) {
    return ShoesTextField(
      controller: _notesController,
      labelText: AppLocalizations.of(context)!.shoes_updater_screen_field_note,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      textCapitalization: TextCapitalization.sentences,
      maxLength: 160,
      validator: (val) => null,
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: _updateShoes,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      shape: const CircleBorder(),
      child: const Icon(MingCuteIcons.mgc_check_fill),
    );
  }
}
