import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/generated/l10n.dart';
import 'package:shox/models/user_model.dart';
import 'package:shox/screens/user/user_screen.dart';
import 'package:shox/services/user_service.dart';
import 'package:shox/utils/permission_helper.dart';
import 'package:shox/widgets/account_textfield.dart';
import 'package:shox/widgets/custom_button.dart';
import 'package:shox/widgets/custom_loader.dart';
import 'package:shox/widgets/custom_toast_bar.dart';

class UserUpdaterScreen extends StatefulWidget {
  final String userId;

  const UserUpdaterScreen({super.key, required this.userId});

  @override
  UserUpdaterScreenState createState() => UserUpdaterScreenState();
}

class UserUpdaterScreenState extends State<UserUpdaterScreen> {
  final Logger _logger = Logger();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final UserService _userService = UserService();
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
      appBar: _buildAppBar(context),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: isLoading
            ? Center(child: _buildLoadingIndicator(context))
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildUserImage(context),
                    SizedBox(height: 20.h),
                    _buildForm(context),
                    SizedBox(height: 40.h),
                    _buildButton(context),
                  ],
                ),
              ),
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
              _userService.getUserImageUrlSupabase(widget.userId, fileName2);
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
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: S.current.users_updater_screen_crop_image_title,
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
          title: S.current.users_updater_screen_crop_image_title,
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
          setState(() {
            userImage = croppedImage;
          });
        } else {
          if (_imageUrl != null) {
            final oldFileName = _imageUrl!.split('/').last;
            _userService.deleteUserImageSupabase(currentUser!.uid, oldFileName);
          }
          userImage = croppedImage;
        }
      } else {
        _logger.i("Cropping deleted, image not updated");
      }
    });
  }

  Future<void> _saveData() async {
    if (_nameController.text.trim().isEmpty) {
      showErrorToast(
        context,
        S.current.users_updater_screen_user_name_field_error,
      );
      return;
    }

    try {
      if (currentUser != null) {
        String? imagePath = _imageUrl;

        if (userImage != null && userImage!.path != imagePath) {
          try {
            String newPath = await _userService.addUserImageSupabase(
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

      Get.off(
        () => UserScreen(userId: currentUser!.uid),
        transition: Transition.fade,
        duration: const Duration(milliseconds: 500),
      );
    } catch (e) {
      _logger.e("Error during data saving: $e");
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
        S.current.profile_edit_title,
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

  Widget _buildUserImage(BuildContext context) {
    if (userImage == null || userImage!.path.isEmpty) {
      return Stack(
        children: [
          ClipOval(
            child: Image.asset(
              "assets/images/img_profile.png",
              width: 160.w,
              height: 160.h,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: ClipOval(
              child: Container(
                color: Theme.of(context).colorScheme.secondary,
                child: IconButton(
                  icon: Icon(
                    MingCuteIcons.mgc_camera_2_fill,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () => _pickImage(),
                ),
              ),
            ),
          ),
        ],
      );
    } else if (userImage!.path.startsWith('http')) {
      return Stack(
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: userImage!.path,
              width: 160.w,
              height: 160.h,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: ClipOval(
              child: Container(
                color: Theme.of(context).colorScheme.secondary,
                child: IconButton(
                  icon: Icon(
                    MingCuteIcons.mgc_edit_2_fill,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () => _pickImage(),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Stack(
        children: [
          ClipOval(
            child: Image.file(
              userImage!,
              width: 160.w,
              height: 160.h,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  "assets/images/img_profile.png",
                  width: 160.w,
                  height: 160.h,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: ClipOval(
              child: Container(
                color: Theme.of(context).colorScheme.secondary,
                child: IconButton(
                  icon: Icon(
                    MingCuteIcons.mgc_edit_2_fill,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () => _pickImage(),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextField(
            _nameController,
            S.current.validator_name,
            S.current.validator_name_hint,
            MingCuteIcons.mgc_user_2_fill,
            TextInputType.text,
            TextInputAction.done,
            (val) => null,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      String hint,
      IconData prefixIcon,
      TextInputType? keyboardType,
      TextInputAction? textInputAction,
      String? Function(String?) validator) {
    return SizedBox(
      width: 320.w,
      child: AccountTextField(
        controller: controller,
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        validator: validator,
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return CustomButton(
      title: S.current.profile_edit_save,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      textColor: Theme.of(context).colorScheme.primary,
      onPressed: _saveData,
    );
  }
}
