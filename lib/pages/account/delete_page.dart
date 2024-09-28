import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/generated/l10n.dart';
import 'package:shox/pages/welcome_page.dart';
import 'package:shox/services/auth_service.dart';
import 'package:shox/theme/app_colors.dart';

class DeletePage extends StatefulWidget {
  const DeletePage({super.key});

  @override
  DeletePageState createState() => DeletePageState();
}

class DeletePageState extends State<DeletePage> {
  final AuthService _authService = AuthService();

  Future<void> _deleteAccount() async {
    User? user = _authService.currentUser;

    if (user != null) {
      bool confirmDelete = await _showDeleteDialog(context);

      if (confirmDelete) {
        if (!mounted) return;

        await _authService.deleteUserAccount(context);

        if (mounted) {
          Get.to(() => const WelcomePage(),
              transition: Transition.fade,
              duration: const Duration(milliseconds: 500));
        }
      }
    }
  }

  Future<bool> _showDeleteDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: Text(
              S.current.delete_d_title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontSize: 20.r,
                fontWeight: FontWeight.bold,
                fontFamily: 'CustomFontBold',
              ),
            ),
            content: Text(
              S.current.delete_d_description,
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontSize: 18.r,
                fontFamily: 'CustomFont',
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Get.back(result: false),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                    AppColors.errorColor,
                  ),
                ),
                child: Text(
                  S.current.delete_d_cancel,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16.r,
                    fontFamily: 'CustomFont',
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                    AppColors.confirmColor,
                  ),
                ),
                child: Text(
                  S.current.delete_d_confirm,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16.r,
                    fontFamily: 'CustomFont',
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30.r, horizontal: 30.r),
          child: Center(
            child: Column(
              children: [
                _buildTopImage(),
                40.verticalSpace,
                _buildBodyText(context),
                40.verticalSpace,
                _buildDeleteButton(context),
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
        S.current.delete_title,
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

  Widget _buildTopImage() {
    return Image.asset(
      'assets/images/img_user_delete.png',
      width: 120.r,
      height: 120.r,
    );
  }

  Widget _buildBodyText(BuildContext context) {
    return Text(
      S.current.delete_description,
      style: TextStyle(
        color: Theme.of(context).colorScheme.tertiary,
        fontSize: 20.r,
        fontFamily: 'CustomFont',
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return SizedBox(
      width: 70.r,
      height: 70.r,
      child: FloatingActionButton(
        onPressed: _deleteAccount,
        backgroundColor: AppColors.errorColor,
        shape: const CircleBorder(),
        child: Icon(
          MingCuteIcons.mgc_delete_2_fill,
          size: 32.r,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
