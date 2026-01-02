import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/common/widgets/app_bar_widget.dart';
import 'package:shox/core/utils/shoes_text_translations.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';
import 'package:shox/features/users/controller/user_controller.dart';
import 'package:shox/screens/shoes/widgets/form/brand_textfield.dart';
import 'package:shox/screens/shoes/widgets/form/category_dropdown.dart';
import 'package:shox/screens/shoes/widgets/form/color_primary_selector.dart';
import 'package:shox/screens/shoes/widgets/form/extra_colors_selector.dart';
import 'package:shox/screens/shoes/widgets/form/notes_textfield.dart';
import 'package:shox/screens/shoes/widgets/form/season_selector.dart';
import 'package:shox/screens/shoes/widgets/form/size_selector.dart';
import 'package:shox/screens/shoes/widgets/form/type_dropdown.dart';
import 'package:shox/theme/app_colors.dart';
import 'package:shox/common/widgets/loader_widget.dart';
import 'package:shox/common/widgets/toast_widget.dart';
import 'package:shox/screens/shoes/services/image_service.dart';
import 'package:shox/screens/shoes/services/shoes_save_service.dart';
import 'package:shox/screens/shoes/services/shoes_update_service.dart';

class ShoesFormScreen extends StatefulWidget {
  final ShoesModel? shoes; // null = ADD mode, not null = EDIT mode

  const ShoesFormScreen({super.key, this.shoes});

  @override
  ShoesFormScreenState createState() => ShoesFormScreenState();
}

class ShoesFormScreenState extends State<ShoesFormScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  final _imageService = ImageService();
  final _shoesSaveService = ShoesSaveService();
  final _shoesUpdateService = ShoesUpdateService();
  final _userController = UserController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _seasonController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  File? _newImage;
  Uint8List? _imageNoBgBytes;
  String? _existingImageUrl;
  bool _imageRemoved = false;
  bool _isBgRemoving = false;
  bool _bgRemoved = false;
  Color _colorPrimary = AppColors.darkGray;
  List<Color> _extraColors = [];
  bool _colorPrimarySelected = false;
  bool _isSaveLoading = false;
  String _selectedCategory = '';
  String _selectedType = '';
  String _selectedSeason = '';
  String? _userGender;
  Map<String, List<String>> _categoryToTypes = {};
  late String _languageCode;
  Map<String, String> translatedCategoryOptions = {};
  late Map<String, String> translatedTypeOptions;
  late Map<String, String> translatedSeasonOptions;
  bool get _isEditMode => widget.shoes != null;
  String get _screenTitle => _isEditMode
      ? AppLocalizations.of(context)!.shoes_updater_screen_title
      : AppLocalizations.of(context)!.shoes_adder_screen_title;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _loadUserGender();
  }

  void _loadUserGender() async {
    if (currentUser != null) {
      final userModel = await _userController.getUserDetails(currentUser!.uid);
      if (mounted && userModel != null) {
        setState(() {
          _userGender = userModel.gender;
          _categoryToTypes = ShoesModel.getCategoryToTypesByGender(_userGender);
          _updateTranslatedCategories();
        });
      }
    }
  }

  void _updateTranslatedCategories() {
    final allCategoryTranslations =
        ShoesTextTranslations.categoryTranslations[_languageCode] ?? {};

    if (_categoryToTypes.isNotEmpty) {
      translatedCategoryOptions = Map.fromEntries(
        allCategoryTranslations.entries
            .where((entry) => _categoryToTypes.keys.contains(entry.key)),
      );
    } else {
      translatedCategoryOptions = allCategoryTranslations;
    }
  }

  void _loadInitialData() {
    if (_isEditMode) {
      final shoes = widget.shoes!;
      _existingImageUrl = shoes.imageUrl;
      _colorPrimary = shoes.colorPrimary;
      _colorPrimarySelected = true;
      if (shoes.colorExtra != null && shoes.colorExtra!.isNotEmpty) {
        _extraColors =
            shoes.colorExtra!.map((intValue) => Color(intValue)).toList();
      }
      _brandController.text = shoes.brand;
      _sizeController.text = shoes.size.toString();
      _categoryController.text = shoes.category;
      _selectedCategory = shoes.category;
      _typeController.text = shoes.type;
      _selectedType = shoes.type;
      _seasonController.text = shoes.season!;
      _selectedSeason = shoes.season!;
      _notesController.text = shoes.notes ?? '';
    } else {
      _colorPrimary = AppColors.darkGray;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _languageCode = Localizations.localeOf(context).languageCode;

    translatedTypeOptions =
        ShoesTextTranslations.typeTranslations[_languageCode] ?? {};
    translatedSeasonOptions =
        ShoesTextTranslations.seasonTranslations[_languageCode] ?? {};

    if (_categoryToTypes.isNotEmpty) {
      _updateTranslatedCategories();
    }
  }

  @override
  void dispose() {
    _brandController.dispose();
    _sizeController.dispose();
    _categoryController.dispose();
    _typeController.dispose();
    _seasonController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _handleImagePick(ImageSource source) async {
    final image = await _imageService.pickImage(context, source);
    if (image != null) {
      setState(() {
        _newImage = image;
        _imageRemoved = false;
        _bgRemoved = false;
        _imageNoBgBytes = null;
      });
    }
  }

  void _removeImage() {
    setState(() {
      if (_newImage != null) {
        _newImage = null;
        _bgRemoved = false;
        _imageNoBgBytes = null;
      } else {
        _imageRemoved = true;
        _existingImageUrl = null;
      }
    });
  }

  void _handleBackgroundRemoval() async {
    if (_bgRemoved || _newImage == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: Container(
              padding: EdgeInsets.all(35.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiaryFixed,
                borderRadius: BorderRadius.circular(25.r),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withAlpha(51),
                    blurRadius: 20,
                    spreadRadius: 5,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).colorScheme.primary.withAlpha(25),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      MingCuteIcons.mgc_magic_2_line,
                      size: 40.sp,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 25.h),
                  LoaderWidget(width: 60.w, height: 60.h),
                  SizedBox(height: 25.h),
                  Text(
                    AppLocalizations.of(context)!
                        .shoes_form_screen_bg_remove_loading,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    try {
      final noBgBytes = await _imageService.removeBackground(_newImage!);

      if (mounted) {
        Navigator.pop(context);
      }

      setState(() {
        _imageNoBgBytes = noBgBytes;
        _bgRemoved = true;
        _isBgRemoving = false;
      });

      if (mounted) {
        showSuccessToast(
          context,
          AppLocalizations.of(context)!.shoes_form_screen_bg_remove_success,
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
      }

      if (mounted) {
        showErrorToast(context,
            '${AppLocalizations.of(context)!.shoes_form_screen_bg_remove_error}$e');
      }
    }
  }

  void _showImageSelector() {
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
                  MingCuteIcons.mgc_camera_2_line,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: () {
                  _handleImagePick(ImageSource.camera);
                  Get.back();
                },
              ),
              IconButton(
                iconSize: 32.sp,
                icon: Icon(
                  MingCuteIcons.mgc_photo_album_2_line,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: () {
                  _handleImagePick(ImageSource.gallery);
                  Get.back();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _saveForm() async {
    try {
      if (_formKey.currentState!.validate()) {
        if (!_isEditMode && _newImage == null) {
          if (mounted) {
            showErrorToast(
              context,
              AppLocalizations.of(context)!
                  .shoes_adder_screen_toast_error_image,
            );
          }
          return;
        }

        if (_isEditMode &&
            _newImage == null &&
            _existingImageUrl == null &&
            !_imageRemoved) {
          if (mounted) {
            showErrorToast(
              context,
              AppLocalizations.of(context)!
                  .shoes_adder_screen_toast_error_image,
            );
          }
          return;
        }

        if (!_colorPrimarySelected) {
          if (mounted) {
            showErrorToast(
              context,
              AppLocalizations.of(context)!
                  .shoes_adder_screen_toast_error_color,
            );
          }
          return;
        }

        setState(() {
          _isSaveLoading = true;
        });

        if (_isEditMode) {
          await _shoesUpdateService.updateShoes(
            context: context,
            existingShoes: widget.shoes!,
            newImageFile: _newImage,
            colorPrimary: _colorPrimary,
            extraColors: _extraColors,
            brand: _brandController.text,
            size: _sizeController.text,
            category: _selectedCategory,
            type: _selectedType,
            season: _selectedSeason,
            notes: _notesController.text,
            imageRemoved: _imageRemoved,
          );
        } else {
          await _shoesSaveService.saveShoes(
            context: context,
            imageFile: _newImage!,
            imageNoBgBytes: _imageNoBgBytes,
            colorPrimary: _colorPrimary,
            extraColors: _extraColors,
            brand: _brandController.text,
            size: _sizeController.text,
            category: _selectedCategory,
            type: _selectedType,
            season: _selectedSeason,
            notes: _notesController.text,
          );
        }

        if (mounted) {
          showSuccessToast(
            context,
            _isEditMode
                ? AppLocalizations.of(context)!
                    .shoes_updater_screen_toast_success
                : AppLocalizations.of(context)!
                    .shoes_adder_screen_toast_success,
          );
          Get.back();
        }
      }
    } catch (e) {
      if (mounted) {
        showErrorToast(context,
            '${AppLocalizations.of(context)!.shoes_adder_screen_toast_error}, $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaveLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBarWidget(title: _screenTitle),
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16.r, right: 16.r, bottom: 72.r),
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 10.h,
                    children: [
                      _buildImageSelector(),
                      ColorPrimarySelector(
                        selectedColor: _colorPrimary,
                        isSelected: _colorPrimarySelected,
                        onColorSelected: (Color color) {
                          setState(() {
                            _colorPrimary = color;
                            _colorPrimarySelected = true;
                          });
                        },
                      ),
                      ExtraColorsSelector(
                        selectedColors: _extraColors,
                        onColorsChanged: (List<Color> colors) {
                          setState(() {
                            _extraColors = colors;
                          });
                        },
                      ),
                      BrandTextField(controller: _brandController),
                      SizeSelector(
                        selectedSize: _sizeController.text.isNotEmpty
                            ? _sizeController.text
                            : null,
                        onSizeSelected: (value) {
                          setState(() {
                            _sizeController.text = value;
                          });
                        },
                      ),
                      CategoryDropdown(
                        selectedCategory: _selectedCategory,
                        categoryController: _categoryController,
                        typeController: _typeController,
                        translatedCategoryOptions: translatedCategoryOptions,
                        onCategoryChanged: (value) {
                          setState(() {
                            _selectedCategory = value;
                            _categoryController.text = value;
                            _selectedType = '';
                            _typeController.text = '';
                          });
                        },
                      ),
                      TypeDropdown(
                        selectedCategory: _selectedCategory,
                        selectedType: _selectedType,
                        typeController: _typeController,
                        categoryToTypes: _categoryToTypes,
                        translatedTypeOptions: translatedTypeOptions,
                        onTypeChanged: (value) {
                          setState(() {
                            _selectedType = value;
                            _typeController.text = value;
                          });
                        },
                      ),
                      SeasonSelector(
                        selectedSeason: _selectedSeason,
                        translatedSeasonOptions: translatedSeasonOptions,
                        onSeasonSelected: (value) {
                          setState(() {
                            _selectedSeason = value;
                            _seasonController.text = value;
                          });
                        },
                      ),
                      NotesTextField(controller: _notesController),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ),
            ),
            if (_isSaveLoading)
              Container(
                color: Theme.of(context)
                    .colorScheme
                    .tertiary
                    .withValues(alpha: 0.7),
                child: LoaderWidget(width: 50.w, height: 50.h),
              ),
          ],
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 10.sp),
          child: FloatingActionButton(
            onPressed: _saveForm,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            elevation: 12,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.w)),
            child: Icon(MingCuteIcons.mgc_check_line,
                color: Theme.of(context).colorScheme.primary, size: 28.w),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  Widget _buildImageSelector() {
    return Column(
      children: [
        if (_newImage == null && _existingImageUrl == null)
          GestureDetector(
            onTap: _showImageSelector,
            child: CircleAvatar(
              radius: 100.r,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: CircleAvatar(
                radius: 80.r,
                backgroundColor: AppColors.champagne,
                child: Stack(
                  children: [
                    Icon(
                      MingCuteIcons.mgc_pic_line,
                      color: Theme.of(context).colorScheme.tertiary,
                      size: 100.sp,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: ClipOval(
                        child: Container(
                          color: Theme.of(context).colorScheme.primary,
                          width: 30.w,
                          height: 30.h,
                          child: Icon(
                            MingCuteIcons.mgc_add_line,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                child: GestureDetector(
                  onTap: _showImageSelector,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                    child: _bgRemoved && _imageNoBgBytes != null
                        ? Image.memory(
                            _imageNoBgBytes!,
                            width: 200.w,
                            height: 200.h,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            _newImage!,
                            width: 200.w,
                            height: 200.h,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              Positioned(
                right: 0.r,
                bottom: 0.r,
                child: CircleAvatar(
                  radius: 20.r,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  child: IconButton(
                    onPressed: _removeImage,
                    icon: Icon(
                      MingCuteIcons.mgc_close_line,
                      color: Theme.of(context).colorScheme.tertiary,
                      size: 20.sp,
                    ),
                  ),
                ),
              ),
              if (_newImage != null && !_bgRemoved && !_isBgRemoving)
                Positioned(
                  left: 0.r,
                  bottom: 0.r,
                  child: CircleAvatar(
                    radius: 20.r,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    child: IconButton(
                      onPressed: _handleBackgroundRemoval,
                      icon: Icon(
                        MingCuteIcons.mgc_eraser_line,
                        color: Theme.of(context).colorScheme.tertiary,
                        size: 20.sp,
                      ),
                    ),
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
                child: GestureDetector(
                  onTap: _showImageSelector,
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
              ),
              Positioned(
                right: 0.r,
                bottom: 0.r,
                child: CircleAvatar(
                  radius: 25.r,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  child: IconButton(
                    onPressed: _removeImage,
                    icon: Icon(
                      MingCuteIcons.mgc_close_line,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
