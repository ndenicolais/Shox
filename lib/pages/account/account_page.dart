import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/generated/l10n.dart';
import 'package:shox/utils/validator.dart';
import 'package:shox/widgets/account_textfield.dart';
import 'package:shox/widgets/custom_button.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  String? _profileImageUrl;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadCurrentUserData();
  }

  void _loadCurrentUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;

        if (userData != null) {
          if (userData.containsKey('name')) {
            _nameController.text = userData['name'];
          }

          if (userData.containsKey('profile_image')) {
            _profileImageUrl = userData['profile_image'];
          } else {
            _profileImageUrl = null;
          }

          setState(() {});
        }
      }
    }
  }

  Future<void> _updateName() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'name': _nameController.text.trim(),
      });
      Get.back();
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      await _uploadImage(image.path);
    }
  }

  Future<void> _uploadImage(String filePath) async {
    User? user = _auth.currentUser;
    if (user != null) {
      Reference ref = _storage.ref().child('profile_images/${user.uid}/avatar');
      UploadTask uploadTask = ref.putFile(File(filePath));
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      await _firestore.collection('users').doc(user.uid).update(
        {
          'profile_image': downloadUrl,
        },
      );
      setState(
        () {
          _profileImageUrl = downloadUrl;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30.r, horizontal: 30.r),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildBodyPage(context),
                40.verticalSpace,
                _buildForm(context),
                40.verticalSpace,
                _buildButton(),
              ],
            ),
          ),
        ),
      ),
    );
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

  Widget _buildBodyPage(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 80.r,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          backgroundImage:
              _profileImageUrl != null ? NetworkImage(_profileImageUrl!) : null,
          child: _profileImageUrl == null
              ? const Icon(Icons.person, size: 50)
              : null,
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: _pickImage,
              icon: Icon(
                MingCuteIcons.mgc_edit_2_fill,
                color: Theme.of(context).colorScheme.secondary,
                size: 20.r,
              ),
            ),
          ),
        ),
      ],
    );
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
            (val) => _validateName(val),
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
      width: 320.r,
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

  String? _validateName(String? val) {
    if (val == null || val.isEmpty) {
      return S.current.validator_name_required;
    }
    String? nameError = val.nameValidationError;
    if (nameError != null) {
      return '${S.current.validator_name_error} $nameError';
    }
    return null;
  }

  Widget _buildButton() {
    return CustomButton(
      title: S.current.profile_edit_save,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      textColor: Theme.of(context).colorScheme.primary,
      onPressed: _updateName,
    );
  }
}
