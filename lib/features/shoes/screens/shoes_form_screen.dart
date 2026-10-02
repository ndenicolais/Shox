import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:shox/theme/app_spacing.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/common/widgets/app_bar_widget.dart';
import 'package:shox/common/widgets/button_widget.dart';
import 'package:shox/common/widgets/responsive_center_widget.dart';
import 'package:shox/common/widgets/delete_dialog_widget.dart';
import 'package:shox/features/shoes/models/brand_suggestions.dart';
import 'package:shox/features/shoes/models/shoes_form_data.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';
import 'package:shox/features/shoes/widgets/shoes_categories_mixin.dart';
import 'package:shox/features/shoes/widgets/form/brand_textfield.dart';
import 'package:shox/features/shoes/widgets/form/category_dropdown.dart';
import 'package:shox/features/shoes/widgets/form/color_primary_selector.dart';
import 'package:shox/features/shoes/widgets/form/extra_colors_selector.dart';
import 'package:shox/features/shoes/widgets/form/notes_textfield.dart';
import 'package:shox/features/shoes/widgets/form/season_selector.dart';
import 'package:shox/features/shoes/widgets/form/shoe_photo_picker.dart';
import 'package:shox/features/shoes/widgets/form/size_selector.dart';
import 'package:shox/features/shoes/widgets/form/type_dropdown.dart';
import 'package:shox/theme/app_colors.dart';
import 'package:shox/common/widgets/toast_widget.dart';
import 'package:shox/core/utils/bg_remover.dart';
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
  BrandSuggestions _brandSuggestions = const BrandSuggestions([]);
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
    _shoesFormService.loadBrandSuggestions().then((suggestions) {
      if (mounted) setState(() => _brandSuggestions = suggestions);
    });
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
      builder: (_) => const BackgroundRemovalDialog(),
    );

    try {
      final noBgBytes = await _imageService.removeBackground(_newImage!);
      if (!mounted) return;
      Navigator.pop(context);
      setState(() {
        _imageNoBgBytes = noBgBytes;
        _bgRemoved = true;
        _isBgRemoving = false;
      });
      showSuccessToast(
        context,
        AppLocalizations.of(context)!.shoes_form_screen_bg_remove_success,
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      final l10n = AppLocalizations.of(context)!;
      showErrorToast(
        context,
        e is BackgroundModelDownloadingException
            ? l10n.shoes_form_screen_bg_remove_downloading
            : '${l10n.shoes_form_screen_bg_remove_error}$e',
      );
    }
  }

  Future<void> _showImageSelector() async {
    final source = await showImageSourceSheet(context);
    if (source != null) _handleImagePick(source);
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
        showErrorToast(
          context,
          '${AppLocalizations.of(context)!.shoes_adder_screen_toast_error}, $e',
        );
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
    final l10n = AppLocalizations.of(context)!;
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
          body: Stack(
            children: [
              SafeArea(
                child: ResponsiveCenterWidget(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.l,
                            AppSpacing.xs,
                            AppSpacing.l,
                            AppSpacing.l,
                          ),
                          children: [
                            ShoePhotoArea(
                              newImage: _newImage,
                              noBackgroundBytes:
                                  _bgRemoved ? _imageNoBgBytes : null,
                              existingImageUrl: _existingImageUrl,
                              canRemoveBackground: _newImage != null &&
                                  !_bgRemoved &&
                                  !_isBgRemoving,
                              onTap: _showImageSelector,
                              onRemove: _removeImage,
                              onRemoveBackground: _handleBackgroundRemoval,
                            ),
                            _buildSectionHeader(
                              l10n.shoes_form_screen_section_colors,
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
                            const SizedBox(height: AppSpacing.s),
                            ExtraColorsSelector(
                              selectedColors: _extraColors,
                              onColorsChanged: (List<Color> colors) {
                                setState(() => _extraColors = colors);
                              },
                            ),
                            _buildSectionHeader(
                              l10n.shoes_form_screen_section_details,
                            ),
                            BrandTextField(
                              controller: _brandController,
                              suggestions: _brandSuggestions,
                            ),
                            const SizedBox(height: AppSpacing.s),
                            SizeSelector(
                              selectedSize: _sizeController.text.isNotEmpty
                                  ? _sizeController.text
                                  : null,
                              onSizeSelected: (value) {
                                setState(() => _sizeController.text = value);
                              },
                            ),
                            const SizedBox(height: AppSpacing.s),
                            CategoryDropdown(
                              selectedCategory: _selectedCategory,
                              categoryController: _categoryController,
                              typeController: _typeController,
                              translatedCategoryOptions:
                                  translatedCategoryOptions,
                              onCategoryChanged: (value) {
                                setState(() {
                                  _selectedCategory = value;
                                  _categoryController.text = value;
                                  _selectedType = '';
                                  _typeController.text = '';
                                });
                              },
                            ),
                            const SizedBox(height: AppSpacing.s),
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
                            const SizedBox(height: AppSpacing.s),
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
                              l10n.shoes_form_screen_section_notes,
                            ),
                            NotesTextField(controller: _notesController),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.l,
                          AppSpacing.xs,
                          AppSpacing.l,
                          AppSpacing.m,
                        ),
                        child: ButtonWidget(
                          width: double.infinity,
                          text: l10n.shoes_form_screen_save,
                          icon: MingCuteIcons.mgc_check_line,
                          isLoading: _isSaveLoading,
                          onPressed: _saveForm,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_isSaveLoading)
                const ModalBarrier(
                  dismissible: false,
                  color: Colors.transparent,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppSpacing.xl,
        bottom: AppSpacing.s,
      ),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}
