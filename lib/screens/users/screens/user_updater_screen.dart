import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/common/widgets/app_bar_widget.dart';
import 'package:shox/features/users/models/user_model.dart';
import 'package:shox/features/users/controller/user_controller.dart';
import 'package:shox/core/utils/permission_helper.dart';
import 'package:shox/common/widgets/textfield_widget.dart';
import 'package:shox/common/widgets/button_widget.dart';
import 'package:shox/common/widgets/loader_widget.dart';
import 'package:shox/common/widgets/toast_widget.dart';
import 'package:shox/theme/app_font_sizes.dart';

class UserUpdateScreen extends StatefulWidget {
  final String userId;

  const UserUpdateScreen({super.key, required this.userId});

  @override
  UserUpdateScreenState createState() => UserUpdateScreenState();
}

class UserUpdateScreenState extends State<UserUpdateScreen> {
  final Logger _logger = Logger();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final UserController _userController = UserController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  File? userImage;
  String? _imageUrl;
  final ImagePicker _picker = ImagePicker();
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
          title: AppLocalizations.of(context)!.user_updater_screen_title),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: isLoading
          ? Center(child: LoaderWidget(width: 50.w, height: 50.h))
          : Stack(
              fit: StackFit.expand,
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.all(30.r),
                  child: Column(
                    spacing: 50.h,
                    children: [
                      _buildProfileImageSection(),
                      _buildNameField(_nameController),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.all(20.r),
                    child: _buildSaveButton(),
                  ),
                ),
              ],
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      setState(() {
        isLoading = true;
      });

      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUser!.uid).get();

      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>;
        UserModel user = UserModel.fromFirestore(userData);

        setState(() {
          _nameController.text = user.userName;
        });

        if (user.userImage != null) {
          final imageUrl2 = user.userImage!;
          final fileName2 = imageUrl2.split('/').last;
          _imageUrl =
              _userController.getUserImageUrlSupabase(widget.userId, fileName2);
          if (_imageUrl != null && _imageUrl!.isNotEmpty) {
            setState(() {
              userImage = File(_imageUrl!);
            });
          }
        }

        setState(() {
          isLoading = false;
        });
      } else {
        _logger.e("Document not found");
      }
    } catch (e) {
      _logger.e("Error during data loading: $e");
    }
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
              .user_updater_screen_crop_image_title,
          toolbarColor: Theme.of(context).colorScheme.secondary,
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
              .user_updater_screen_crop_image_title,
        ),
      ],
    );

    return croppedFile != null ? File(croppedFile.path) : null;
  }

  Future<void> _pickImage() async {
    await requestStoragePermission(context, () async {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        File? croppedImage = await _cropImage(File(pickedFile.path));
        if (croppedImage != null) {
          File compressedImage = await _compressImage(croppedImage);
          setState(() {
            userImage = compressedImage;
          });
        } else {
          if (_imageUrl != null) {
            final oldFileName = _imageUrl!.split('/').last;
            _userController.deleteUserImageSupabase(
                currentUser!.uid, oldFileName);
          }
          userImage = croppedImage;
        }
      } else {
        _logger.i("Cropping deleted, image not updated");
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

  Future<void> _saveData() async {
    if (_nameController.text.trim().isEmpty) {
      showErrorToast(
        context,
        AppLocalizations.of(context)!.user_updater_screen_username_field_error,
      );
      return;
    }

    try {
      if (currentUser != null) {
        String? imagePath = _imageUrl;

        if (userImage != null && userImage!.path != imagePath) {
          try {
            String newPath = await _userController.addUserImageSupabase(
                widget.userId, userImage!);
            if (newPath != imagePath) {
              imagePath = newPath;
            }
          } catch (e) {
            _logger.e("Error during update of userImage: $e");
          }
        }
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .update({
          'userName': _nameController.text.trim(),
          'userImage': imagePath,
        });
      }

      Get.back(result: true);
    } catch (e) {
      _logger.e("Error during data saving: $e");
    }
  }

  Widget _buildProfileImageSection() {
    return Stack(
      children: [
        ClipOval(child: _buildProfileImage()),
        Positioned(
          bottom: 0,
          right: 0,
          child: ClipOval(
            child: Container(
              color: Theme.of(context).colorScheme.secondary,
              child: IconButton(
                icon: Icon(
                  userImage == null || userImage!.path.isEmpty
                      ? MingCuteIcons.mgc_camera_2_line
                      : MingCuteIcons.mgc_edit_2_line,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: _pickImage,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileImage() {
    if (userImage == null || userImage!.path.isEmpty) {
      return Image.asset(
        'assets/images/img_profile.png',
        width: 120.w,
        height: 120.h,
        fit: BoxFit.cover,
      );
    } else if (userImage!.path.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: userImage!.path,
        width: 120.w,
        height: 120.h,
        fit: BoxFit.cover,
      );
    } else {
      return Image.file(
        userImage!,
        width: 120.w,
        height: 120.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/images/img_profile.png',
            width: 120.w,
            height: 120.h,
            fit: BoxFit.cover,
          );
        },
      );
    }
  }

  Widget _buildNameField(TextEditingController controller) {
    return Form(
      key: _formKey,
      child: TextFieldWidget(
        controller: _nameController,
        labelText: AppLocalizations.of(context)!.validator_name,
        hintText: AppLocalizations.of(context)!.validator_name_hint,
        prefixIcon: MingCuteIcons.mgc_user_2_line,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        validator: (val) => null,
      ),
    );
  }

  Widget _buildSaveButton() {
    return ButtonWidget(
      text: AppLocalizations.of(context)!.user_updater_screen_save,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      textColor: Theme.of(context).colorScheme.primary,
      width: 120.w,
      height: 50.h,
      fontSize: AppFontSizes.regular,
      icon: MingCuteIcons.mgc_save_2_line,
      iconSize: 18.sp,
      onPressed: _saveData,
    );
  }
}
