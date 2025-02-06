import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/generated/l10n.dart';
import 'package:shox/screens/welcome_screen.dart';
import 'package:shox/services/auth_service.dart';
import 'package:shox/theme/app_colors.dart';
import 'package:shox/widgets/custom_delete_dialog.dart';
import 'package:shox/widgets/custom_toast_bar.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  DeleteAccountScreenState createState() => DeleteAccountScreenState();
}

class DeleteAccountScreenState extends State<DeleteAccountScreen>
    with TickerProviderStateMixin {
  final AuthService _authService = AuthService();
  late AnimationController _loadingController;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(30.r),
            child: Center(
              child: Column(
                children: [
                  _buildTopImage(context),
                  SizedBox(height: 40.h),
                  _buildBodyText(context),
                  SizedBox(height: 40.h),
                  _buildDeleteButton(context),
                ],
              ),
            ),
          ),
          if (_isLoading) _buildDeleteLoading(context)
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _loadingController.dispose();
    super.dispose();
  }

  Future<void> _deleteAccount() async {
    User? user = _authService.currentUser;

    if (user != null) {
      bool confirmDelete = await _showDeleteDialog(context);

      if (confirmDelete) {
        setState(() {
          _isLoading = true;
        });

        if (!mounted) return;

        await _authService.deleteAccount();

        setState(() {
          _isLoading = false;
        });

        if (mounted) {
          showSuccessToast(
            context,
            S.current.toast_delete_success,
          );
          Get.to(() => const WelcomeScreen(),
              transition: Transition.fade,
              duration: const Duration(milliseconds: 500));
        }
      }
    }
  }

  Future<bool> _showDeleteDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return CustomDeleteDialog(
              title: S.current.delete_d_title,
              content: S.current.delete_d_description,
              onCancelPressed: () {
                Get.back(result: false);
              },
              onConfirmPressed: () {
                Get.back(result: true);
              },
            );
          },
        ) ??
        false;
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

  Widget _buildTopImage(BuildContext context) {
    return Image.asset(
      'assets/images/img_user_delete.png',
      width: 120.w,
      height: 120.h,
    );
  }

  Widget _buildBodyText(BuildContext context) {
    return SizedBox(
      width: 420.w,
      child: Text(
        S.current.delete_description,
        style: TextStyle(
          color: Theme.of(context).colorScheme.tertiary,
          fontSize: 20.sp,
          fontFamily: 'CustomFont',
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return SizedBox(
      width: 70.w,
      height: 70.h,
      child: FloatingActionButton(
        onPressed: _deleteAccount,
        backgroundColor: AppColors.errorColor,
        shape: const CircleBorder(),
        child: Icon(
          MingCuteIcons.mgc_delete_2_fill,
          size: 32.sp,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildDeleteLoading(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.7),
      child: Center(
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.5).animate(
            CurvedAnimation(
              parent: _loadingController,
              curve: Curves.easeInOut,
            ),
          ),
          child: Icon(
            MingCuteIcons.mgc_eraser_fill,
            size: 50.sp,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
