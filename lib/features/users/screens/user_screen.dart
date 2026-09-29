import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/common/widgets/app_bar_widget.dart';
import 'package:shox/core/routes/app_routes.dart';
import 'package:shox/core/utils/db_localized_values.dart';
import 'package:shox/features/database/controller/database_controller.dart';
import 'package:shox/features/users/controller/user_controller.dart';
import 'package:shox/common/widgets/responsive_center_widget.dart';
import 'package:shox/theme/app_radius.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  UserScreenState createState() => UserScreenState();
}

class UserScreenState extends State<UserScreen> {
  final Logger _logger = Logger();
  final UserController userController = Get.find<UserController>();
  final DatabaseController _databaseController = Get.find<DatabaseController>();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  bool _hasUpdated = false;
  int _totalShoes = 0;
  int _favoritesCount = 0;
  String? _favoriteBrand;
  String? _mostUsedCategory;
  String? _mostUsedType;
  String? _mostUsedColor;
  String? _lastAddedDate;
  bool _isLoadingStats = true;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    try {
      final totalShoes = await _databaseController.getTotalShoesCount();
      final favoritesCount = await _databaseController.getFavoriteShoesCount();
      final favoriteBrand = await _databaseController.getFavoriteBrand();
      final mostUsedCategory = await _databaseController.getMostUsedCategory();
      final mostUsedType = await _databaseController.getMostUsedType();
      final mostUsedColorObj =
          await _databaseController.getMostUsedColorAsColor();
      if (!mounted) return;
      final mostUsedColor = mostUsedColorObj != null
          ? DbLocalizedValues.getColorName(context, mostUsedColorObj)
          : null;
      final lastShoe = await _databaseController.getLastShoeAdded();

      setState(() {
        _totalShoes = totalShoes;
        _favoritesCount = favoritesCount;
        _favoriteBrand = favoriteBrand;
        _mostUsedCategory = mostUsedCategory;
        _mostUsedType = mostUsedType;
        _mostUsedColor = mostUsedColor;
        _lastAddedDate = lastShoe != null
            ? '${lastShoe.dateAdded.day}/${lastShoe.dateAdded.month}/${lastShoe.dateAdded.year}'
            : null;
        _isLoadingStats = false;
      });
    } catch (e) {
      _logger.e('Error loading statistics: $e');
      setState(() {
        _isLoadingStats = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEmailPasswordUser = userController.isEmailPasswordUser();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Get.back(result: _hasUpdated);
        }
      },
      child: Scaffold(
        appBar: AppBarWidget(
          title: AppLocalizations.of(context)!.user_screen_title,
          onBackPressed: () {
            Get.back(result: _hasUpdated);
          },
          actions: isEmailPasswordUser
              ? [
                  IconButton(
                    tooltip: AppLocalizations.of(context)!.a11y_edit_profile,
                    icon: const Icon(MingCuteIcons.mgc_edit_2_line),
                    onPressed: () async {
                      bool? result = await Get.toNamed(AppRoutes.userUpdate);
                      if (result == true) {
                        setState(() {
                          _hasUpdated = true;
                        });
                        _logger.i('UserScreen: _hasUpdated = $_hasUpdated');
                      }
                    },
                  ),
                ]
              : null,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 24.h),
          child: ResponsiveCenterWidget(
            child: Column(
              spacing: 20.h,
              children: [
                _buildUserHeader(context),
                _buildStatsCard(context),
                _buildDeleteAccountButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.r, 28.r, 20.r, 28.r),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withAlpha(25),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.extraLarge),
          bottomRight: Radius.circular(AppRadius.extraLarge),
        ),
      ),
      child: Column(
        children: [
          Center(child: _buildProfileImage(context)),
          SizedBox(height: 16.h),
          Obx(() => Text(
                userController.userName.value,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              )),
          SizedBox(height: 4.h),
          Obx(() => Text(
                userController.userEmail.value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                textAlign: TextAlign.center,
              )),
        ],
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.r),
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    MingCuteIcons.mgc_calendar_line,
                    AppLocalizations.of(context)!.user_screen_member_since,
                    _getMemberSince(),
                  ),
                ),
                Container(
                  width: 1,
                  height: 40.h,
                  color: Theme.of(context).colorScheme.tertiary.withAlpha(25),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    MingCuteIcons.mgc_box_2_line,
                    AppLocalizations.of(context)!.user_screen_total_shoes,
                    _isLoadingStats ? '...' : '$_totalShoes',
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Divider(
              color: Theme.of(context).colorScheme.tertiary.withAlpha(25),
              thickness: 1,
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    MingCuteIcons.mgc_time_line,
                    AppLocalizations.of(context)!.user_screen_last_added,
                    _isLoadingStats ? '...' : (_lastAddedDate ?? '-'),
                  ),
                ),
                Container(
                  width: 1,
                  height: 40.h,
                  color: Theme.of(context).colorScheme.tertiary.withAlpha(25),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    MingCuteIcons.mgc_heart_line,
                    AppLocalizations.of(context)!.user_screen_favorites_count,
                    _isLoadingStats ? '...' : '$_favoritesCount',
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Divider(
              color: Theme.of(context).colorScheme.tertiary.withAlpha(25),
              thickness: 1,
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    MingCuteIcons.mgc_tag_line,
                    AppLocalizations.of(context)!.user_screen_favorite_brand,
                    _isLoadingStats ? '...' : (_favoriteBrand ?? '-'),
                  ),
                ),
                Container(
                  width: 1,
                  height: 40.h,
                  color: Theme.of(context).colorScheme.tertiary.withAlpha(25),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    MingCuteIcons.mgc_palette_line,
                    AppLocalizations.of(context)!.user_screen_most_used_color,
                    _isLoadingStats ? '...' : (_mostUsedColor ?? '-'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Divider(
              color: Theme.of(context).colorScheme.tertiary.withAlpha(25),
              thickness: 1,
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    MingCuteIcons.mgc_grid_line,
                    AppLocalizations.of(context)!
                        .user_screen_most_used_category,
                    _isLoadingStats ? '...' : (_mostUsedCategory ?? '-'),
                  ),
                ),
                Container(
                  width: 1,
                  height: 40.h,
                  color: Theme.of(context).colorScheme.tertiary.withAlpha(25),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    MingCuteIcons.mgc_shoe_line,
                    AppLocalizations.of(context)!.user_screen_most_used_type,
                    _isLoadingStats ? '...' : (_mostUsedType ?? '-'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
      BuildContext context, IconData icon, String label, String value) {
    return Column(
      spacing: 6.h,
      children: [
        Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary.withAlpha(25),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.secondary,
            size: 22.sp,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.tertiary,
              ),
          textAlign: TextAlign.center,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildProfileImage(BuildContext context) {
    return Obx(
      () => Container(
        padding: EdgeInsets.all(4.r),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.primary,
          boxShadow: [
            BoxShadow(
              color: const Color(0x33000000),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: CircleAvatar(
          radius: 56.r,
          backgroundColor:
              Theme.of(context).colorScheme.secondary.withAlpha(25),
          backgroundImage: userController.userProfileImage.value.isNotEmpty
              ? NetworkImage(userController.userProfileImage.value)
              : null,
          child: userController.userProfileImage.value.isEmpty
              ? Image.asset(
                  'assets/images/img_profile.png',
                  width: 112.w,
                  height: 112.h,
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildDeleteAccountButton(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.r),
      child: ListTile(
        leading: Icon(
          MingCuteIcons.mgc_delete_2_line,
          color: Theme.of(context).colorScheme.error,
        ),
        title: Text(
          AppLocalizations.of(context)!.user_screen_button_delete,
          style: TextStyle(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        onTap: () {
          Get.toNamed(AppRoutes.userDelete);
        },
      ),
    );
  }

  String _getMemberSince() {
    if (currentUser?.metadata.creationTime != null) {
      final date = currentUser!.metadata.creationTime!;
      return '${date.year}';
    }
    return 'N/A';
  }
}
