import 'dart:io';
import 'dart:math';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/shoes/shoes_model.dart';
import 'package:shox/shoes/shoes_service.dart';
import 'package:shox/theme/app_colors.dart';
import 'package:shox/utils/api_client.dart';
import 'package:shox/utils/utils.dart';
import 'package:shox/widgets/shoes_textfield.dart';

class ShoesUpdaterPage extends StatefulWidget {
  final Shoes shoes;

  const ShoesUpdaterPage({super.key, required this.shoes});

  @override
  ShoesUpdaterPageState createState() => ShoesUpdaterPageState();
}

class ShoesUpdaterPageState extends State<ShoesUpdaterPage>
    with SingleTickerProviderStateMixin {
  var logger = Logger();
  final ShoesService _shoesService = ShoesService();
  late AnimationController _loadingController;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final ApiClient _apiClient = ApiClient();
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  late String _imageUrl;
  Color _color = AppColors.smoothBlack;
  bool _colorSelected = false;
  IconData? _seasonIcon;
  late TextEditingController _brandController;
  late TextEditingController _sizeController;
  late TextEditingController _categoryController;
  late TextEditingController _typeController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
    _imageUrl = widget.shoes.imageUrl;
    _color = widget.shoes.color;
    _colorSelected = true;
    _seasonIcon = widget.shoes.seasonIcon;
    _brandController = TextEditingController(text: widget.shoes.brand);
    _sizeController = TextEditingController(text: widget.shoes.size.toString());
    _categoryController = TextEditingController(text: widget.shoes.category);
    _typeController = TextEditingController(text: widget.shoes.type);
    _notesController = TextEditingController(text: widget.shoes.notes);

    // // Initialize _imageFile if there is an existing image URL
    // if (_imageUrl.isNotEmpty) {
    //   _imageFile = XFile(_imageUrl);
    // }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile =
        await _picker.pickImage(source: source, maxHeight: 1280, maxWidth: 760);
    if (pickedFile != null) {
      setState(
        () {
          _imageFile = pickedFile;
        },
      );
    }
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

  Future<void> _removeBackground() async {
    if (_imageFile != null) {
      final resultBytes = await _apiClient.removeBgApi(_imageFile!.path);
      final filePath = _imageFile!.path;
      final newFilePath = '${filePath}_no_bg.png';

      // Convert XFile to File
      final file = File(newFilePath);

      // Update byte in file
      await file.writeAsBytes(resultBytes);

      // Update _imageFile with new path
      _updateImageFile(XFile(newFilePath));
      Get.back();
    }
  }

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
                iconSize: 38,
                icon: Icon(Icons.camera,
                    color: Theme.of(context).colorScheme.secondary),
                onPressed: () {
                  _pickImage(ImageSource.camera);
                  Get.back();
                },
              ),
              IconButton(
                iconSize: 38,
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
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.secondary,
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _showPickImageModal(context);
                        },
                        child: Card(
                          color: Theme.of(context).colorScheme.primary,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          elevation: 0,
                          clipBehavior: Clip.antiAlias,
                          child: _imageFile != null
                              ? Image.file(
                                  File(_imageFile!.path),
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                )
                              : (widget.shoes.imageUrl.isNotEmpty
                                  ? Image.network(
                                      widget.shoes.imageUrl,
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    )
                                  : const Placeholder(
                                      fallbackWidth: 200,
                                      fallbackHeight: 200,
                                    )),
                        ),
                      ),
                      if (_imageFile != null)
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  insetPadding: const EdgeInsets.symmetric(
                                      horizontal: 100),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                        IconButton(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          onPressed: _removeBackground,
                                          icon: Icon(
                                            MingCuteIcons.mgc_mirror_fill,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary,
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
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 5,
                            child: Container(
                              width: 120,
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                          fontSize: 16,
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
                                              BorderRadius.circular(15),
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
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
                                                    width: 24,
                                                    height: 24,
                                                    decoration: BoxDecoration(
                                                      color: color,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      border: Border.all(
                                                        color: _color == color
                                                            ? Colors.black
                                                            : Colors
                                                                .transparent,
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
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 5,
                                  child: Container(
                                    width: 100,
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Stack(
                                          children: [
                                            if (!_colorSelected)
                                              Text(
                                                'Color',
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiary,
                                                  fontFamily: 'CustomFont',
                                                  fontSize: 16,
                                                ),
                                              ),
                                            if (_colorSelected)
                                              Icon(
                                                Icons.palette,
                                                color: _color,
                                                size: 32,
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
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
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
                                                    padding:
                                                        const EdgeInsets.all(4),
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
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 5,
                                  child: Container(
                                    width: 100,
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Stack(
                                          children: [
                                            if (_seasonIcon == null)
                                              Text(
                                                'Season',
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiary,
                                                  fontFamily: 'CustomFont',
                                                  fontSize: 16,
                                                ),
                                              ),
                                            if (_seasonIcon != null)
                                              Icon(
                                                _seasonIcon!,
                                                size: 32,
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
                      const SizedBox(height: 20),
                      ShoesTextField(
                        controller: _brandController,
                        labelText: 'Brand',
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      ShoesTextField(
                        controller: _sizeController,
                        labelText: 'Size',
                        keyboardType: TextInputType.number,
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
                        items: Shoes.categoryOptions.map(
                          (category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            );
                          },
                        ).toList(),
                        decoration: InputDecoration(
                          labelText: 'Category',
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontFamily: 'CustomFont',
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
                            return 'Insert the category';
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
                        items: Shoes.typeOptions.map(
                          (type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            );
                          },
                        ).toList(),
                        decoration: InputDecoration(
                          labelText: 'Type',
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontFamily: 'CustomFont',
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
                            return 'Insert the type';
                          }
                          return null;
                        },
                      ),
                      ShoesTextField(
                        controller: _notesController,
                        labelText: 'Notes',
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      const SizedBox(height: 50),
                      SizedBox(
                        width: 70,
                        height: 70,
                        child: FloatingActionButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              // Set isLoading to true before starting the operation
                              setState(
                                () {
                                  _isLoading = true;
                                },
                              );

                              // Create updated Shoes object
                              Shoes updatedShoes = Shoes(
                                id: widget.shoes.id,
                                imageUrl: _imageUrl,
                                color: _color,
                                seasonIcon: _seasonIcon,
                                brand: _brandController.text.trim(),
                                size: _sizeController.text,
                                category: _categoryController.text,
                                type: _typeController.text,
                                notes: _notesController.text,
                              );

                              // Saving the updated Shoes item in the service
                              _shoesService
                                  .updateShoes(updatedShoes.id!, updatedShoes,
                                      _imageFile)
                                  .then(
                                (_) {
                                  // Show confirmation toastbar
                                  DelightToastBar(
                                    snackbarDuration:
                                        const Duration(milliseconds: 1500),
                                    builder: (context) => const ToastCard(
                                      color: AppColors.confirmColor,
                                      leading: Icon(
                                        MingCuteIcons.mgc_celebrate_fill,
                                        color: AppColors.white,
                                        size: 28,
                                      ),
                                      title: Text(
                                        "Shoes updated successfully",
                                        style: TextStyle(
                                          color: AppColors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    autoDismiss: true,
                                  ).show(context);
                                  Get.back(result: updatedShoes);
                                },
                              ).catchError(
                                (error) {
                                  // Show error toastbar
                                  DelightToastBar(
                                    snackbarDuration:
                                        const Duration(milliseconds: 1500),
                                    builder: (context) => ToastCard(
                                      color: AppColors.errorColor,
                                      leading: const Icon(
                                        MingCuteIcons.mgc_warning_fill,
                                        color: AppColors.white,
                                        size: 28,
                                      ),
                                      title: Text(
                                        "Error while updating the shoes $error",
                                        style: const TextStyle(
                                          color: AppColors.white,
                                          fontSize: 16,
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
                    size: 120,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
