import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/generated/l10n.dart';
import 'package:shox/models/shoes_model.dart';
import 'package:shox/utils/category_translations.dart';
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
  Color _color = AppColors.smoothBlack;
  Color _detailsColor = Colors.transparent;
  bool _colorSelected = false;
  bool _detailsColorSelected = false;
  IconData? _seasonIcon;
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  late String _languageCode;
  late Map<String, String> translatedCategoryOptions;
  late Map<String, String> translatedTypeOptions;
  String selectedCategory = '';
  String selectedType = '';
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
                    children: [
                      _buildImageSelector(context),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildColorSelector(context),
                          _buildDetailsColorSelector(context),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      _buildSeasonSelector(context),
                      SizedBox(height: 20.h),
                      _buildBrandTextField(context),
                      _buildSizeTextField(context),
                      _buildCategoryDropdown(context),
                      _buildTypeDropdown(context),
                      _buildNotesTextField(context),
                      SizedBox(height: 20.h),
                      _buildSaveButton(context),
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
        CategoryTranslations.categoryTranslations[_languageCode] ?? {};
    translatedTypeOptions =
        CategoryTranslations.typeTranslations[_languageCode] ?? {};
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
          toolbarTitle: S.current.shoes_adder_screen_crop_image_title,
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
          title: S.current.shoes_adder_screen_crop_image_title,
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
      if (!_colorSelected) {
        if (mounted) {
          showErrorToast(
            context,
            S.current.field_insert_color,
          );
        }
        return;
      }

      if (_imageFile == null) {
        if (mounted) {
          showErrorToast(
            context,
            S.current.field_insert_image,
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
        color: _color,
        detailsColor: _detailsColor,
        seasonIcon: _seasonIcon,
        brand: _brandController.text.trim(),
        size: _sizeController.text,
        category: selectedCategory,
        type: selectedType,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      String shoesId;
      try {
        shoesId = await _shoesService.addShoes(newShoes);
      } catch (e) {
        if (mounted) {
          showErrorToast(
              context, '${S.current.shoes_adder_screen_toast_error}, $e');
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
          color: _color,
          detailsColor: _detailsColor,
          seasonIcon: _seasonIcon,
          brand: _brandController.text.trim(),
          size: _sizeController.text,
          category: selectedCategory,
          type: selectedType,
          notes:
              _notesController.text.isNotEmpty ? _notesController.text : null,
        );

        await _shoesService.confirmAddShoes(confirmShoes);

        if (mounted) {
          showSuccessToast(
            context,
            S.current.shoes_adder_screen_toast_success,
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
        S.current.shoes_adder_screen_title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.tertiary,
          fontWeight: FontWeight.bold,
          fontFamily: 'CustomFont',
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
    return GestureDetector(
      onTap: () {
        _showImageSelector(context);
      },
      child: CircleAvatar(
        radius: 100.r,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: _imageFile == null
            ? CircleAvatar(
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
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Container(
                padding: EdgeInsets.all(12.r),
                child: Wrap(
                  spacing: 8.r,
                  runSpacing: 8.r,
                  children: colorList.map((color) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _color = color;
                          _colorSelected = true;
                          Get.back();
                        });
                      },
                      child: Container(
                        width: 24.w,
                        height: 24.h,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(50.r),
                          border: Border.all(
                            color: _color == color
                                ? Colors.black
                                : Colors.transparent,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        );
      },
      child: Card(
        color: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        elevation: 5,
        child: Container(
          width: 120.w,
          padding: EdgeInsets.all(8.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                children: [
                  if (_colorSelected == false)
                    Text(
                      S.current.field_color,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontFamily: 'CustomFont',
                        fontSize: 16.sp,
                      ),
                    ),
                  if (_colorSelected == true)
                    Icon(
                      MingCuteIcons.mgc_palette_fill,
                      color: _color,
                      size: 32.sp,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.6),
                          offset: const Offset(2, 2),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                ],
              ),
              Icon(
                MingCuteIcons.mgc_down_line,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsColorSelector(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Container(
                padding: EdgeInsets.all(12.r),
                child: Wrap(
                  spacing: 8.r,
                  runSpacing: 8.r,
                  children: colorList.map((detailsColor) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _detailsColor = detailsColor;
                          _detailsColorSelected = true;
                          Get.back();
                        });
                      },
                      child: Container(
                        width: 24.w,
                        height: 24.h,
                        decoration: BoxDecoration(
                          color: detailsColor,
                          borderRadius: BorderRadius.circular(50.r),
                          border: Border.all(
                            color: _detailsColor == detailsColor
                                ? Colors.black
                                : Colors.transparent,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        );
      },
      child: Card(
        color: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        elevation: 5,
        child: Container(
          width: 120.w,
          padding: EdgeInsets.all(8.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                children: [
                  if (_detailsColorSelected == false)
                    Text(
                      S.current.field_details_color,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontFamily: 'CustomFont',
                        fontSize: 16.sp,
                      ),
                    ),
                  if (_detailsColorSelected == true)
                    Icon(
                      MingCuteIcons.mgc_palette_3_fill,
                      color: _detailsColor,
                      size: 32.sp,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.6),
                          offset: const Offset(2, 2),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                ],
              ),
              Icon(
                MingCuteIcons.mgc_down_line,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeasonSelector(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: Theme.of(context).colorScheme.primary,
              insetPadding: EdgeInsets.symmetric(horizontal: 100.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Container(
                padding: EdgeInsets.all(12.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...ShoesModel.seasonOptions.map((icon) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _seasonIcon = icon;
                          });
                          Get.back();
                        },
                        child: Padding(
                          padding: EdgeInsets.all(4.r),
                          child: Icon(
                            icon,
                            color: _seasonIcon == icon
                                ? Colors.black
                                : Colors.black.withValues(alpha: 0.5),
                            size: 32.sp,
                          ),
                        ),
                      );
                    }),
                    GestureDetector(
                      onTap: () {
                        showSeasonDialog(context);
                      },
                      child: Icon(
                        MingCuteIcons.mgc_information_fill,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Card(
        color: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        elevation: 5,
        child: Container(
          width: 120.w,
          padding: EdgeInsets.all(8.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                children: [
                  if (_seasonIcon == null)
                    Text(
                      S.current.field_season,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontFamily: 'CustomFont',
                        fontSize: 16.sp,
                      ),
                    ),
                  if (_seasonIcon != null)
                    Icon(
                      _seasonIcon!,
                      size: 32.sp,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          offset: const Offset(2, 2),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                ],
              ),
              Icon(
                MingCuteIcons.mgc_down_line,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrandTextField(BuildContext context) {
    return ShoesTextField(
      controller: _brandController,
      labelText: S.current.field_brand,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.sentences,
      validator: (val) =>
          val!.isEmpty ? S.current.shoes_adder_screen_toast_error_brand : null,
    );
  }

  Widget _buildSizeTextField(BuildContext context) {
    return ShoesTextField(
      controller: _sizeController,
      labelText: S.current.field_size,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      validator: (val) =>
          val!.isEmpty ? S.current.shoes_adder_screen_toast_error_size : null,
    );
  }

  Widget _buildCategoryDropdown(BuildContext context) {
    return CustomDropdown<String>(
      label: S.current.field_category,
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
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontFamily: 'CustomFont',
            ),
          ),
        );
      }).toList(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return S.current.shoes_adder_screen_toast_error_category;
        }
        return null;
      },
    );
  }

  Widget _buildTypeDropdown(BuildContext context) {
    return CustomDropdown<String>(
      label: S.current.field_type,
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
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontFamily: 'CustomFont',
                ),
              ),
            );
          }).toList() ??
          [],
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return S.current.shoes_adder_screen_toast_error_type;
        }
        return null;
      },
    );
  }

  Widget _buildNotesTextField(BuildContext context) {
    return ShoesTextField(
      controller: _notesController,
      labelText: S.current.field_notes,
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
      child: const Icon(
        MingCuteIcons.mgc_check_fill,
      ),
    );
  }

  void showSeasonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            S.current.field_season_title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'CustomFontBold',
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.sunny,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    S.current.field_season_summer,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontFamily: 'CustomFont',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Icon(
                    Icons.ac_unit,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    S.current.field_season_winter,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontFamily: 'CustomFont',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    S.current.field_season_all,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontFamily: 'CustomFont',
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all<Color>(AppColors.confirmColor),
              ),
              child: Text(
                S.current.field_season_close,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16.sp,
                  fontFamily: 'CustomFont',
                ),
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }
}
