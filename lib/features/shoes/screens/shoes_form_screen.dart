import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shox/theme/app_spacing.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/common/widgets/app_bar_widget.dart';
import 'package:shox/common/widgets/delete_dialog_widget.dart';
import 'package:shox/features/shoes/models/shoes_form_data.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';
import 'package:shox/features/shoes/widgets/shoes_categories_mixin.dart';
import 'package:shox/features/shoes/widgets/form/brand_textfield.dart';
import 'package:shox/features/shoes/widgets/form/category_dropdown.dart';
import 'package:shox/features/shoes/widgets/form/color_primary_selector.dart';
import 'package:shox/features/shoes/widgets/form/extra_colors_selector.dart';
import 'package:shox/features/shoes/widgets/form/notes_textfield.dart';
import 'package:shox/features/shoes/widgets/form/season_selector.dart';
import 'package:shox/features/shoes/widgets/form/size_selector.dart';
import 'package:shox/features/shoes/widgets/form/type_dropdown.dart';
import 'package:shox/theme/app_colors.dart';
import 'package:shox/theme/app_font_sizes.dart';
import 'package:shox/common/widgets/loader_widget.dart';
import 'package:shox/common/widgets/toast_widget.dart';
import 'package:shox/features/shoes/services/image_service.dart';
import 'package:shox/features/shoes/services/shoes_form_service.dart';

class ShoesFormScreen extends StatefulWidget {
  final ShoesModel? shoes; // null = ADD mode, not null = EDIT mode

  const ShoesFormScreen({super.key, this.shoes});

  @override
  ShoesFormScreenState createState() => ShoesFormScreenState();
}

class ShoesFormScreenState extends State<ShoesFormScreen>
    with ShoesCategoriesMixin {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  final _imageService = ImageService();
  final _shoesFormService = ShoesFormService();
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
  bool get _isEditMode => widget.shoes != null;
  String get _screenTitle => _isEditMode
      ? AppLocalizations.of(context)!.shoes_updater_screen_title
      : AppLocalizations.of(context)!.shoes_adder_screen_title;

  /// Snapshot of the form right after loading, used to detect unsaved edits.
  late final String _initialFormSignature;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _initialFormSignature = _formSignature();
    loadUserGender(currentUser?.uid);
  }

  String _formSignature() => [
        _brandController.text,
        _sizeController.text,
        _notesController.text,
        _selectedCategory,
        _selectedType,
        _selectedSeason,
        _colorPrimarySelected,
        _colorPrimary.toARGB32(),
        _extraColors.map((c) => c.toARGB32()).join(','),
        _newImage?.path,
        _imageRemoved,
        _bgRemoved,
      ].join('|');

  bool get _hasUnsavedChanges => _formSignature() != _initialFormSignature;

  /// Asks for confirmation before leaving the form with unsaved edits.
  Future<void> _handlePop(bool didPop, Object? result) async {
    if (didPop) return;
    if (_isSaveLoading) return;
    if (!_hasUnsavedChanges) {
      Get.back();
      return;
    }
    final l10n = AppLocalizations.of(context)!;
    final leave = await showDialog<bool>(
      context: context,
      builder: (context) => DeleteDialogWidget(
        title: l10n.shoes_form_screen_unsaved_title,
        content: l10n.shoes_form_screen_unsaved_text,
        cancelLabel: l10n.shoes_form_screen_unsaved_stay,
        confirmLabel: l10n.shoes_form_screen_unsaved_leave,
        onCancelPressed: () => Navigator.of(context).pop(false),
        onConfirmPressed: () => Navigator.of(context).pop(true),
      ),
    );
    if (leave == true && mounted) Get.back();
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
    refreshTranslations();
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
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(25.r),
                boxShadow: [
                  BoxShadow(
                    color:
                        Theme.of(context).colorScheme.secondary.withAlpha(51),
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
                    padding: EdgeInsets.all(AppSpacing.l.w),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).colorScheme.secondary.withAlpha(30),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      MingCuteIcons.mgc_magic_2_fill,
                      size: 40.sp,
                      color: Theme.of(context).colorScheme.secondary,
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
                tooltip: AppLocalizations.of(context)!.a11y_take_photo,
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
                tooltip: AppLocalizations.of(context)!.a11y_pick_from_gallery,
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

  ShoesFormData get _formData => ShoesFormData(
        brand: _brandController.text,
        size: _sizeController.text,
        category: _selectedCategory,
        type: _selectedType,
        season: _selectedSeason,
        notes: _notesController.text,
        colorPrimary: _colorPrimary,
        colorPrimarySelected: _colorPrimarySelected,
        extraColors: _extraColors,
        newImage: _newImage,
        imageNoBgBytes: _imageNoBgBytes,
        hasExistingImage: _existingImageUrl != null,
      );

  void _saveForm() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;
    final data = _formData;
    switch (data.validate()) {
      case ShoesFormError.missingImage:
        showErrorToast(context, l10n.shoes_adder_screen_toast_error_image);
        return;
      case ShoesFormError.missingColor:
        showErrorToast(context, l10n.shoes_adder_screen_toast_error_color);
        return;
      case null:
        break;
    }

    setState(() => _isSaveLoading = true);
    try {
      await _shoesFormService.save(data, existing: widget.shoes);
      if (mounted) {
        showSuccessToast(
          context,
          _isEditMode
              ? l10n.shoes_updater_screen_toast_success
              : l10n.shoes_adder_screen_toast_success,
        );
        Get.back();
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _handlePop,
      child: Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBarWidget(
            title: _screenTitle,
            onBackPressed: () => Navigator.of(context).maybePop(),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          body: Stack(
            children: [
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                      left: AppSpacing.m.r,
                      right: AppSpacing.m.r,
                      bottom: 72.r),
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 10.h,
                      children: [
                        _buildSectionHeader(
                          AppLocalizations.of(context)!
                              .shoes_form_screen_section_photo,
                        ),
                        _buildImageSelector(),
                        _buildSectionHeader(
                          AppLocalizations.of(context)!
                              .shoes_form_screen_section_colors,
                        ),
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
                        _buildSectionHeader(
                          AppLocalizations.of(context)!
                              .shoes_form_screen_section_details,
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
                          categoryToTypes: categoryToTypes,
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
                        _buildSectionHeader(
                          AppLocalizations.of(context)!
                              .shoes_form_screen_section_notes,
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
                      .primary
                      .withValues(alpha: 0.75),
                  child: LoaderWidget(width: 50.w, height: 50.h),
                ),
            ],
          ),
          floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: 10.sp),
            child: FloatingActionButton(
              tooltip: AppLocalizations.of(context)!.a11y_save_shoe,
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
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(top: AppSpacing.xxs.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontFamily: 'CustomFontBold',
                color: Theme.of(context).colorScheme.secondary,
              ),
        ),
      ),
    );
  }

  Widget _buildImageSelector() {
    return Column(
      children: [
        if (_newImage == null && _existingImageUrl == null)
          GestureDetector(
            onTap: _showImageSelector,
            child: Container(
              width: 140.w,
              height: 140.h,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 1.5.w,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(AppSpacing.s.r),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).colorScheme.secondary.withAlpha(30),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      MingCuteIcons.mgc_add_line,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 28.sp,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    AppLocalizations.of(context)!.shoes_form_screen_add_photo,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'CustomFontBold',
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: AppFontSizes.small,
                    ),
                  ),
                ],
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
                            width: 140.w,
                            height: 140.h,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            _newImage!,
                            width: 140.w,
                            height: 140.h,
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
                    tooltip: AppLocalizations.of(context)!.a11y_remove_image,
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
                      tooltip:
                          AppLocalizations.of(context)!.a11y_remove_background,
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
                      width: 140.w,
                      height: 140.h,
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
                    tooltip: AppLocalizations.of(context)!.a11y_remove_image,
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
