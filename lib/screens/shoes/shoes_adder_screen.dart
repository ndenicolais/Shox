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
// import 'package:shox/utils/api_client.dart';
import 'package:shox/utils/utils.dart';
import 'package:shox/widgets/custom_dropdown.dart';
import 'package:shox/widgets/custom_loader.dart';
import 'package:shox/widgets/custom_toast_bar.dart';
import 'package:shox/widgets/shoes_textfield.dart';

class ShoesAdderScreen extends StatefulWidget {
  const ShoesAdderScreen({super.key});

  @override
  ShoesAdderScreenState createState() => ShoesAdderScreenState();
}

class ShoesAdderScreenState extends State<ShoesAdderScreen>
    with SingleTickerProviderStateMixin {
  final Logger _logger = Logger();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final ShoesService _shoesService = ShoesService();
  final _formKey = GlobalKey<FormState>();
  // final ApiClient _apiClient = ApiClient();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  Color _colorPrimary = AppColors.smoothBlack;
  Color _colorSecondary = Colors.transparent;
  bool _colorPrimarySelected = false;
  bool _colorSecondarySelected = false;
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _seasonController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  String selectedCategory = '';
  String selectedType = '';
  String selectedSeason = '';
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
          toolbarTitle:
              AppLocalizations.of(context)!.shoes_adder_screen_crop_image_title,
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
          title:
              AppLocalizations.of(context)!.shoes_adder_screen_crop_image_title,
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
            _imageFile = compressedImage;
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

  // Future<void> _removeBackground() async {
  //   if (_imageFile != null) {
  //     final resultBytes = await _apiClient.removeBgApi(_imageFile!.path);
  //     final filePath = _imageFile!.path;
  //     final newFilePath = '${filePath}_no_bg.png';
  //     final file = File(newFilePath);
  //     await file.writeAsBytes(resultBytes);
  //     setState(() {
  //       _imageFile = file;
  //     });
  //   }
  // }

  void _saveShoes() async {
    if (_formKey.currentState!.validate()) {
      if (_imageFile == null) {
        if (mounted) {
          showErrorToast(
            context,
            AppLocalizations.of(context)!.shoes_adder_screen_toast_error_image,
          );
        }
        return;
      }

      if (!_colorPrimarySelected) {
        if (mounted) {
          showErrorToast(
            context,
            AppLocalizations.of(context)!.shoes_adder_screen_toast_error_color,
          );
        }
        return;
      }

      setState(() {
        isSaveLoading = true;
      });

      final newShoes = ShoesModel(
        id: '',
        imageUrl: _imageFile!.path,
        colorPrimary: _colorPrimary,
        colorSecondary: _colorSecondary,
        brand: _brandController.text.trim(),
        size: _sizeController.text,
        category: selectedCategory,
        type: selectedType,
        season: selectedSeason.isNotEmpty ? selectedSeason : 'All',
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      String shoesId;
      try {
        shoesId = await _shoesService.addShoes(newShoes);
      } catch (e) {
        if (mounted) {
          showErrorToast(context,
              '${AppLocalizations.of(context)!.shoes_adder_screen_toast_error}, $e');
        }
        return;
      }

      String? imageUrl;
      if (_imageFile != null) {
        final path = await _shoesService.addShoesImageSupabase(
            currentUser!.uid, shoesId, _imageFile!);
        final fileName = path.split('/').last;
        imageUrl = _shoesService.getShoesImageUrlSupabase(
            currentUser!.uid, shoesId, fileName);
      }

      if (imageUrl != null) {
        final confirmShoes = ShoesModel(
          id: shoesId,
          imageUrl: imageUrl,
          colorPrimary: _colorPrimary,
          colorSecondary: _colorSecondary,
          brand: _brandController.text.trim(),
          size: _sizeController.text,
          category: selectedCategory,
          type: selectedType,
          season: selectedSeason.isNotEmpty ? selectedSeason : 'All',
          notes:
              _notesController.text.isNotEmpty ? _notesController.text : null,
        );

        await _shoesService.confirmAddShoes(confirmShoes);

        if (mounted) {
          showSuccessToast(
            context,
            AppLocalizations.of(context)!.shoes_adder_screen_toast_success,
          );
          Get.back();
        }

        setState(() {
          isSaveLoading = false;
        });
      }
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
                icon: Icon(
                  MingCuteIcons.mgc_camera_2_fill,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: () {
                  _pickImage(ImageSource.camera);
                  Get.back();
                },
              ),
              IconButton(
                iconSize: 32.sp,
                icon: Icon(
                  MingCuteIcons.mgc_photo_album_2_fill,
                  color: Theme.of(context).colorScheme.secondary,
                ),
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
    return GestureDetector(
      onTap: () {
        _showImageSelector(context);
      },
      child: CircleAvatar(
        radius: 100.r,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: _imageFile == null
            ? Stack(
                children: [
                  CircleAvatar(
                    radius: 80.r,
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withValues(alpha: 0.2),
                    child: Icon(
                      MingCuteIcons.mgc_pic_fill,
                      color: Theme.of(context).colorScheme.tertiary,
                      size: 100.sp,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 20,
                    child: ClipOval(
                      child: Container(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 30.w,
                        height: 30.h,
                        child: Icon(
                          MingCuteIcons.mgc_add_fill,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Stack(
                children: [
                  Card(
                    color: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    elevation: 0,
                    clipBehavior: Clip.antiAlias,
                    child: GestureDetector(
                      onTap: () => _showImageSelector(context),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10.r)),
                        child: Image.file(
                          File(_imageFile!.path),
                          width: 200.w,
                          height: 200.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  // Positioned(
                  //   right: 0.r,
                  //   bottom: 0.r,
                  //   child: CircleAvatar(
                  //     radius: 25.r,
                  //     backgroundColor: Theme.of(context).colorScheme.secondary,
                  //     child: IconButton(
                  //       color: Theme.of(context).colorScheme.secondary,
                  //       onPressed: _removeBackground,
                  //       icon: Icon(
                  //         MingCuteIcons.mgc_mirror_fill,
                  //         color: Theme.of(context).colorScheme.tertiary,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
      ),
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
                            blurRadius: 1,
                            color: Colors.black.withValues(alpha: 0.5),
                          ),
                        ],
                      ),
                    ],
                  ),
                SizedBox(width: 10.w),
                Text(
                  AppLocalizations.of(context)!
                      .shoes_adder_screen_field_color_primary,
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
                            blurRadius: 1,
                            color: Colors.black.withValues(alpha: 0.5),
                          ),
                        ],
                      ),
                    ],
                  ),
                SizedBox(width: 10.w),
                Text(
                  AppLocalizations.of(context)!
                      .shoes_adder_screen_field_color_secondary,
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
                  .shoes_adder_screen_field_color_primary_selection,
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
                  .shoes_adder_screen_field_color_secondary_selection,
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
      labelText: AppLocalizations.of(context)!.shoes_adder_screen_field_brand,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.sentences,
      validator: (val) => val!.isEmpty
          ? AppLocalizations.of(context)!.shoes_adder_screen_toast_error_brand
          : null,
    );
  }

  Widget _buildSizeTextField(BuildContext context) {
    return ShoesTextField(
      controller: _sizeController,
      labelText: AppLocalizations.of(context)!.shoes_adder_screen_field_size,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      validator: (val) => val!.isEmpty
          ? AppLocalizations.of(context)!.shoes_adder_screen_toast_error_size
          : null,
    );
  }

  Widget _buildCategoryDropdown(BuildContext context) {
    return CustomDropdown<String>(
      label: AppLocalizations.of(context)!.shoes_adder_screen_field_category,
      value: selectedCategory.isNotEmpty ? selectedCategory : null,
      onChanged: (newValue) {
        setState(() {
          selectedCategory = newValue!;
          _categoryController.text = selectedCategory;
          _typeController.text = '';
          selectedType = '';
        });
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)!
              .shoes_adder_screen_toast_error_category;
        }
        return null;
      },
    );
  }

  Widget _buildTypeDropdown(BuildContext context) {
    return CustomDropdown<String>(
      label: AppLocalizations.of(context)!.shoes_adder_screen_field_type,
      value: selectedType.isNotEmpty ? selectedType : null,
      onChanged: (newValue) {
        setState(() {
          selectedType = newValue!;
          _typeController.text = selectedType;
        });
      },
      items: ShoesModel.categoryToTypes[selectedCategory]?.map((type) {
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)!
              .shoes_adder_screen_toast_error_type;
        }
        return null;
      },
    );
  }

  Widget _buildSeasonDropdown(BuildContext context) {
    return CustomDropdown<String>(
      label: AppLocalizations.of(context)!.shoes_adder_screen_field_season,
      value: _seasonController.text.isNotEmpty ? _seasonController.text : null,
      onChanged: (newValue) {
        setState(() {
          selectedSeason = newValue!;
          _seasonController.text = selectedSeason;
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
      labelText: AppLocalizations.of(context)!.shoes_adder_screen_field_note,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      textCapitalization: TextCapitalization.sentences,
      maxLength: 160,
      validator: (val) => null,
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return FloatingActionButton(
      foregroundColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      elevation: 0,
      onPressed: _saveShoes,
      shape: const CircleBorder(),
      child: const Icon(MingCuteIcons.mgc_check_fill),
    );
  }
}
