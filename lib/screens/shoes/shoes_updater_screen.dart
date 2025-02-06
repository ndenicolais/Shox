import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/generated/l10n.dart';
import 'package:shox/models/shoes_model.dart';
import 'package:shox/screens/home_screen.dart';
import 'package:shox/utils/category_translations.dart';
import 'package:shox/services/shoes_service.dart';
import 'package:shox/theme/app_colors.dart';
import 'package:shox/utils/utils.dart';
import 'package:shox/widgets/custom_dropdown.dart';
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
  Color _color = AppColors.smoothBlack;
  Color _detailsColor = Colors.transparent;
  bool _colorSelected = false;
  bool _detailsColorSelected = false;
  IconData? _seasonIcon;
  late TextEditingController _brandController;
  late TextEditingController _sizeController;
  late TextEditingController _categoryController;
  late TextEditingController _typeController;
  late TextEditingController _notesController;
  late String _languageCode;
  late Map<String, String> translatedCategoryOptions;
  late Map<String, String> translatedTypeOptions;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: _buildAppBar(context),
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: SafeArea(
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
    _color = widget.shoes.color;
    _colorSelected = true;
    _detailsColor = widget.shoes.detailsColor!;
    _detailsColorSelected = true;
    _seasonIcon = widget.shoes.seasonIcon;
    _brandController = TextEditingController(text: widget.shoes.brand);
    _sizeController = TextEditingController(text: widget.shoes.size.toString());
    _categoryController = TextEditingController(text: widget.shoes.category);
    _typeController = TextEditingController(text: widget.shoes.type);
    _notesController = TextEditingController(text: widget.shoes.notes);
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
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: S.current.shoes_updater_screen_crop_image_title,
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
          title: S.current.shoes_updater_screen_crop_image_title,
        ),
      ],
      compressFormat: ImageCompressFormat.png,
    );
    return croppedFile != null ? File(croppedFile.path) : null;
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null && currentUser != null) {
      File? croppedImage = await _cropImage(File(pickedFile.path));
      if (croppedImage != null) {
        setState(() {
          _newImage = croppedImage;
        });
      }
    } else {
      _logger.e("Error: user not logged in or no image selected");
    }
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
        final path = await _shoesService.addShoeImageSupabase(
            currentUser!.uid, widget.shoes.id!, _newImage!);
        final fileName = path.split('/').last;
        _existingImageUrl = _shoesService.getShoeImageUrlSupabase(
            currentUser!.uid, widget.shoes.id!, fileName);

        if (_removedExistingImages != null) {
          final existingFileName = _removedExistingImages!.split('/').last;
          try {
            await _shoesService.deleteShoeImageSupabase(
                currentUser!.uid, widget.shoes.id!, existingFileName);
            _logger.i("Deleted existing image: $existingFileName");
          } catch (e) {
            _logger.e(
                "Failed to delete existing image: $existingFileName, error: $e");
          }
        }
      }

      final updateShoe = ShoesModel(
        id: widget.shoes.id,
        imageUrl: _existingImageUrl!,
        color: _color,
        detailsColor: _detailsColor,
        seasonIcon: _seasonIcon,
        brand: _brandController.text.trim(),
        size: _sizeController.text,
        category: _categoryController.text,
        type: _typeController.text,
        notes: _notesController.text,
        dateAdded: widget.shoes.dateAdded,
        dateUpdated: DateTime.now(),
      );

      await _shoesService.updateShoes(updateShoe);

      if (mounted) {
        showSuccessToast(
          context,
          S.current.shoes_updater_screen_toast_success,
        );
        Get.off(
          () => const HomeScreen(),
          transition: Transition.fade,
          duration: const Duration(milliseconds: 500),
        );
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
        S.current.shoes_updater_screen_title,
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

  void _showImageSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
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
      backgroundColor: Theme.of(context).colorScheme.primary,
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
                  child: CachedNetworkImage(
                    imageUrl: _existingImageUrl!,
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
              insetPadding: EdgeInsets.symmetric(horizontal: 100.w),
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
      validator: (val) => val!.isEmpty
          ? S.current.shoes_updater_screen_toast_error_brand
          : null,
    );
  }

  Widget _buildSizeTextField(BuildContext context) {
    return ShoesTextField(
      controller: _sizeController,
      labelText: S.current.field_size,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      validator: (val) =>
          val!.isEmpty ? S.current.shoes_updater_screen_toast_error_size : null,
    );
  }

  Widget _buildCategoryDropdown(BuildContext context) {
    return CustomDropdown<String>(
      label: S.current.field_category,
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
          return S.current.field_insert_category;
        }
        return null;
      },
    );
  }

  Widget _buildTypeDropdown(BuildContext context) {
    return CustomDropdown<String>(
      label: S.current.field_type,
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
          return S.current.field_insert_type;
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
      onPressed: _updateShoes,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      shape: const CircleBorder(),
      child: const Icon(
        MingCuteIcons.mgc_check_fill,
      ),
    );
  }

  Future<void> showSeasonDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
                  Icon(Icons.sunny,
                      color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(width: 8),
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
                  Icon(Icons.ac_unit,
                      color: Theme.of(context).colorScheme.secondary),
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
                  Icon(Icons.star,
                      color: Theme.of(context).colorScheme.secondary),
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
          backgroundColor: Theme.of(context).colorScheme.primary,
          actions: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  AppColors.confirmColor,
                ),
              ),
              child: Text(
                'Chiudi',
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
