import 'dart:io';
import 'dart:math';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/generated/l10n.dart';
import 'package:shox/models/shoes_model.dart';
import 'package:shox/pages/shoes/shoes_languages.dart';
import 'package:shox/services/shoes_service.dart';
import 'package:shox/theme/app_colors.dart';
// import 'package:shox/utils/api_client.dart';
import 'package:shox/utils/utils.dart';
import 'package:shox/widgets/shoes_textfield.dart';

class ShoesAdderPage extends StatefulWidget {
  // Callback to call when shoes are added
  final VoidCallback onShoesAdded;
  const ShoesAdderPage({super.key, required this.onShoesAdded});

  @override
  ShoesAdderPageState createState() => ShoesAdderPageState();
}

class ShoesAdderPageState extends State<ShoesAdderPage>
    with SingleTickerProviderStateMixin {
  var logger = Logger();
  final ShoesService _shoesService = ShoesService();
  late AnimationController _loadingController;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  // final ApiClient _apiClient = ApiClient();
  XFile? _imageFile;
  Color _color = AppColors.smoothBlack;
  bool _colorSelected = false;
  IconData? _seasonIcon;
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  late String _languageCode;
  late Map<String, String> translatedCategoryOptions;
  late Map<String, String> translatedTypeOptions;

  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _languageCode = Localizations.localeOf(context).languageCode;
    translatedCategoryOptions =
        ShoesLanguages.categoryTranslations[_languageCode] ?? {};
    translatedTypeOptions =
        ShoesLanguages.typeTranslations[_languageCode] ?? {};
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: source, maxHeight: 1280, maxWidth: 720);
    _updateImageFile(pickedFile);
  }

  Future<void> _cropImage() async {
    if (_imageFile == null) return;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: _imageFile!.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop image',
          toolbarColor: Theme.of(context).colorScheme.secondary,
          toolbarWidgetColor: AppColors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
        ),
        IOSUiSettings(
          title: 'Crop image',
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
          ],
        ),
        WebUiSettings(
          context: context,
        ),
      ],
      compressFormat: ImageCompressFormat.png,
    );

    if (croppedFile != null) {
      _updateImageFile(XFile(croppedFile.path));
      Get.back();
    }
  }

  // Future<void> _removeBackground() async {
  //   if (_imageFile != null) {
  //     final resultBytes = await _apiClient.removeBgApi(_imageFile!.path);
  //     final filePath = _imageFile!.path;
  //     final newFilePath = '${filePath}_no_bg.png';

  //     // Convert XFile to File
  //     final file = File(newFilePath);

  //     // Write byte in file
  //     await file.writeAsBytes(resultBytes);

  //     // Update _imageFile with new path
  //     _updateImageFile(XFile(newFilePath));
  //     Get.back();
  //   }
  // }

  void _updateImageFile(XFile? newFile) {
    setState(
      () {
        _imageFile = newFile;
      },
    );
  }

  void _showPickImageModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                iconSize: 38.r,
                icon: Icon(Icons.camera,
                    color: Theme.of(context).colorScheme.secondary),
                onPressed: () {
                  _pickImage(ImageSource.camera);
                  Get.back();
                },
              ),
              IconButton(
                iconSize: 38.r,
                icon: Icon(Icons.image,
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

  @override
  void dispose() {
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          S.current.adder_title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontWeight: FontWeight.bold,
            fontFamily: 'CustomFont',
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.secondary,
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.r, horizontal: 30.r),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showPickImageModal(context);
                      },
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: _imageFile == null
                            ? Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 80.r,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withOpacity(0.2),
                                    child: Icon(
                                      MingCuteIcons.mgc_pic_fill,
                                      size: 100,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                    ),
                                  ),
                                  Positioned(
                                    top: 0.r,
                                    right: 0.r,
                                    child: CircleAvatar(
                                      radius: 25.r,
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      child: Icon(MingCuteIcons.mgc_add_fill,
                                          size: 30.r,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    ),
                                  ),
                                ],
                              )
                            : Card(
                                color: Theme.of(context).colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0.r),
                                ),
                                elevation: 5,
                                clipBehavior: Clip.antiAlias,
                                child: Image.file(
                                  File(_imageFile!.path),
                                  width: 200.r,
                                  height: 200.r,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                    if (_imageFile != null)
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                insetPadding:
                                    EdgeInsets.symmetric(horizontal: 100.r),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(12.r),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      IconButton(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        onPressed: _cropImage,
                                        icon: Icon(
                                          MingCuteIcons.mgc_scissors_2_fill,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                        ),
                                      ),
                                      // IconButton(
                                      //   color: Theme.of(context)
                                      //       .colorScheme
                                      //       .secondary,
                                      //   onPressed: _removeBackground,
                                      //   icon: Icon(
                                      //     MingCuteIcons.mgc_mirror_fill,
                                      //     color: Theme.of(context)
                                      //         .colorScheme
                                      //         .tertiary,
                                      //   ),
                                      // ),
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
                            width: 120.r,
                            padding: EdgeInsets.all(8.r),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Stack(
                                  children: [
                                    Text(
                                      'Edit',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                        fontFamily: 'CustomFont',
                                        fontSize: 16.r,
                                      ),
                                    ),
                                  ],
                                ),
                                const Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.r),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.all(12.r),
                                        child: Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: colorList.map(
                                            (color) {
                                              return GestureDetector(
                                                onTap: () {
                                                  setState(
                                                    () {
                                                      _color = color;
                                                      _colorSelected = true;
                                                      Get.back();
                                                    },
                                                  );
                                                },
                                                child: Container(
                                                  width: 24.r,
                                                  height: 24.r,
                                                  decoration: BoxDecoration(
                                                    color: color,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50.r),
                                                    border: Border.all(
                                                      color: _color == color
                                                          ? Colors.black
                                                          : Colors.transparent,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ).toList(),
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
                                  width: 100.r,
                                  padding: EdgeInsets.all(8.r),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Stack(
                                        children: [
                                          if (_colorSelected == false)
                                            Text(
                                              S.current.field_color,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .tertiary,
                                                fontFamily: 'CustomFont',
                                                fontSize: 16.r,
                                              ),
                                            ),
                                          if (_colorSelected == true)
                                            Icon(
                                              Icons.palette,
                                              color: _color,
                                              size: 32.r,
                                              shadows: [
                                                Shadow(
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  offset: const Offset(2, 2),
                                                  blurRadius: 5,
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                      const Icon(Icons.arrow_drop_down),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      insetPadding: EdgeInsets.symmetric(
                                        horizontal: 100.r,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.r),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.all(12.r),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: Shoes.seasonOptions.map(
                                            (icon) {
                                              return GestureDetector(
                                                onTap: () {
                                                  setState(
                                                    () {
                                                      _seasonIcon = icon;
                                                    },
                                                  );
                                                  Get.back();
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.all(4.r),
                                                  child: Icon(
                                                    icon,
                                                    color: _seasonIcon == icon
                                                        ? Colors.black
                                                        : Colors.black
                                                            .withOpacity(0.3),
                                                    size: 32,
                                                  ),
                                                ),
                                              );
                                            },
                                          ).toList(),
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
                                  width: 100.r,
                                  padding: EdgeInsets.all(8.r),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Stack(
                                        children: [
                                          if (_seasonIcon == null)
                                            Text(
                                              S.current.field_season,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .tertiary,
                                                fontFamily: 'CustomFont',
                                                fontSize: 16.r,
                                              ),
                                            ),
                                          if (_seasonIcon != null)
                                            Icon(
                                              _seasonIcon!,
                                              size: 32.r,
                                            ),
                                        ],
                                      ),
                                      const Icon(Icons.arrow_drop_down),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    20.verticalSpace,
                    ShoesTextField(
                      controller: _brandController,
                      labelText: S.current.field_brand,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.sentences,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.current.field_insert_brand;
                        }
                        return null;
                      },
                    ),
                    ShoesTextField(
                      controller: _sizeController,
                      labelText: S.current.field_size,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.current.field_insert_size;
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<String>(
                      value: _categoryController.text.isNotEmpty
                          ? _categoryController.text
                          : null,
                      onChanged: (newValue) {
                        setState(
                          () {
                            _categoryController.text = newValue!;
                          },
                        );
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      items: translatedCategoryOptions.keys.map(
                        (category) {
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
                        },
                      ).toList(),
                      decoration: InputDecoration(
                        labelText: S.current.field_category,
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontFamily: 'CustomFont',
                        ),
                        errorStyle: const TextStyle(
                          color: AppColors.errorColor,
                          fontFamily: 'CustomFont',
                          fontWeight: FontWeight.bold,
                        ),
                        errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.errorColor,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      ),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontFamily: 'CustomFont',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.current.field_insert_category;
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<String>(
                      value: _typeController.text.isNotEmpty
                          ? _typeController.text
                          : null,
                      onChanged: (newValue) {
                        setState(
                          () {
                            _typeController.text = newValue!;
                          },
                        );
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      items: translatedTypeOptions.keys.map(
                        (type) {
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
                        },
                      ).toList(),
                      decoration: InputDecoration(
                        labelText: S.current.field_type,
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontFamily: 'CustomFont',
                        ),
                        errorStyle: const TextStyle(
                          color: AppColors.errorColor,
                          fontFamily: 'CustomFont',
                          fontWeight: FontWeight.bold,
                        ),
                        errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.errorColor,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      ),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontFamily: 'CustomFont',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.current.field_insert_type;
                        }
                        return null;
                      },
                    ),
                    ShoesTextField(
                      controller: _notesController,
                      labelText: S.current.field_notes,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    20.verticalSpace,
                    SizedBox(
                      width: 70.r,
                      height: 70.r,
                      child: FloatingActionButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            // Checking if the user has selected a color
                            if (!_colorSelected) {
                              // Show error toastbar
                              DelightToastBar(
                                snackbarDuration:
                                    const Duration(milliseconds: 1500),
                                builder: (context) => ToastCard(
                                  color: AppColors.errorColor,
                                  leading: Icon(
                                    MingCuteIcons.mgc_color_picker_fill,
                                    color: AppColors.white,
                                    size: 28.r,
                                  ),
                                  title: Text(
                                    S.current.field_insert_color,
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 16.r,
                                      fontFamily: 'CustomFont',
                                    ),
                                  ),
                                ),
                                autoDismiss: true,
                              ).show(context);
                              return;
                            }

                            // Checking if the user has selected an image
                            if (_imageFile == null) {
                              // Show error toastbar
                              DelightToastBar(
                                snackbarDuration:
                                    const Duration(milliseconds: 1500),
                                builder: (context) => ToastCard(
                                  color: AppColors.errorColor,
                                  leading: Icon(
                                    MingCuteIcons.mgc_pic_fill,
                                    color: AppColors.white,
                                    size: 28.r,
                                  ),
                                  title: Text(
                                    S.current.field_insert_image,
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 16.r,
                                      fontFamily: 'CustomFont',
                                    ),
                                  ),
                                ),
                                autoDismiss: true,
                              ).show(context);
                              return;
                            }

                            // Set isLoading to true before starting the operation
                            setState(
                              () {
                                _isLoading = true;
                              },
                            );

                            // Create Shoes object and add to Firestore
                            Shoes newShoes = Shoes(
                              imageUrl:
                                  _imageFile != null ? _imageFile!.path : '',
                              color: _color,
                              seasonIcon: _seasonIcon,
                              brand: _brandController.text.trim(),
                              size: _sizeController.text,
                              category: _categoryController.text,
                              type: _typeController.text,
                              notes: _notesController.text.isNotEmpty
                                  ? _notesController.text
                                  : null,
                            );
                            _shoesService.addShoes(newShoes, _imageFile).then(
                              (_) {
                                // Show confirmation toastbar
                                DelightToastBar(
                                  snackbarDuration:
                                      const Duration(milliseconds: 1500),
                                  builder: (context) => ToastCard(
                                    color: AppColors.confirmColor,
                                    leading: Icon(
                                      MingCuteIcons.mgc_celebrate_fill,
                                      color: AppColors.white,
                                      size: 28.r,
                                    ),
                                    title: Text(
                                      S.current.toast_add_shoes_success,
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: 16.r,
                                        fontFamily: 'CustomFont',
                                      ),
                                    ),
                                  ),
                                  autoDismiss: true,
                                ).show(context);

                                // Reset isLoading to false after operation completes
                                setState(
                                  () {
                                    _isLoading = false;
                                  },
                                );

                                // Call callback to notify that shoes have been added
                                widget.onShoesAdded();

                                // Navigate back to the previous screen
                                Get.back();
                              },
                            ).catchError(
                              (error) {
                                // Show error toastbar
                                DelightToastBar(
                                  snackbarDuration:
                                      const Duration(milliseconds: 1500),
                                  builder: (context) => ToastCard(
                                    color: AppColors.errorColor,
                                    leading: Icon(
                                      MingCuteIcons.mgc_warning_fill,
                                      color: AppColors.white,
                                      size: 28.r,
                                    ),
                                    title: Text(
                                      "${S.current.toast_add_shoes_error}$error",
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: 16.r,
                                        fontFamily: 'CustomFont',
                                      ),
                                    ),
                                  ),
                                  autoDismiss: true,
                                ).show(context);
                              },
                            );
                          }
                        },
                        backgroundColor: AppColors.confirmColor,
                        shape: const CircleBorder(),
                        child: Icon(
                          MingCuteIcons.mgc_save_2_fill,
                          size: 32,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Theme.of(context).colorScheme.tertiary.withOpacity(0.7),
              child: Center(
                child: AnimatedBuilder(
                  animation: _loadingController,
                  builder: (_, child) {
                    return Transform(
                      transform: Matrix4.rotationY(
                        _loadingController.value * 2.0 * pi,
                      ),
                      alignment: Alignment.center,
                      child: child,
                    );
                  },
                  child: Icon(
                    MingCuteIcons.mgc_save_2_fill,
                    size: 120.r,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
