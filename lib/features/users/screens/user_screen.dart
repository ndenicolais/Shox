import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:shox/theme/app_spacing.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/common/widgets/app_bar_widget.dart';
import 'package:shox/common/widgets/info_tile_widget.dart';
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
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: AppSpacing.xl),
          child: ResponsiveCenterWidget(
            child: Column(
              spacing: AppSpacing.l,
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
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
      child: Column(
        children: [
          _buildProfileImage(context),
          const SizedBox(height: AppSpacing.m),
          Obx(
            () => Text(
              userController.userName.value,
              style: textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Obx(
            () => Text(
              userController.userEmail.value,
              style: textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  /// Two-column grid of profile statistics.
  Widget _buildStatsCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    String stat(String? value) => _isLoadingStats ? '…' : (value ?? '-');
    final tiles = [
      InfoTileWidget(
        icon: MingCuteIcons.mgc_calendar_line,
        label: l10n.user_screen_member_since,
        value: _getMemberSince(),
      ),
      InfoTileWidget(
        icon: MingCuteIcons.mgc_box_2_line,
        label: l10n.user_screen_total_shoes,
        value: stat('$_totalShoes'),
      ),
      InfoTileWidget(
        icon: MingCuteIcons.mgc_time_line,
        label: l10n.user_screen_last_added,
        value: stat(_lastAddedDate),
      ),
      InfoTileWidget(
        icon: MingCuteIcons.mgc_heart_line,
        label: l10n.user_screen_favorites_count,
        value: stat('$_favoritesCount'),
      ),
      InfoTileWidget(
        icon: MingCuteIcons.mgc_tag_line,
        label: l10n.user_screen_favorite_brand,
        value: stat(_favoriteBrand),
      ),
      InfoTileWidget(
        icon: MingCuteIcons.mgc_palette_line,
        label: l10n.user_screen_most_used_color,
        value: stat(_mostUsedColor),
      ),
      InfoTileWidget(
        icon: MingCuteIcons.mgc_grid_line,
        label: l10n.user_screen_most_used_category,
        value: stat(_mostUsedCategory),
      ),
      InfoTileWidget(
        icon: MingCuteIcons.mgc_shoe_line,
        label: l10n.user_screen_most_used_type,
        value: stat(_mostUsedType),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
      child: Column(
        children: [
          for (var i = 0; i < tiles.length; i += 2) ...[
            Row(
              children: [
                Expanded(child: tiles[i]),
                const SizedBox(width: AppSpacing.s),
                Expanded(child: tiles[i + 1]),
              ],
            ),
            if (i + 2 < tiles.length) const SizedBox(height: AppSpacing.s),
          ],
        ],
      ),
    );
  }

  Widget _buildProfileImage(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Obx(
      () => CircleAvatar(
        radius: 48,
        backgroundColor: colors.tertiaryFixed,
        backgroundImage: userController.userProfileImage.value.isNotEmpty
            ? NetworkImage(userController.userProfileImage.value)
            : null,
        child: userController.userProfileImage.value.isEmpty
            ? Image.asset(
                'assets/images/img_profile.png',
                width: 96,
                height: 96,
              )
            : null,
      ),
    );
  }

  Widget _buildDeleteAccountButton(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
      child: Card(
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.large),
          ),
          leading: Icon(MingCuteIcons.mgc_delete_2_line, color: colors.error),
          title: Text(
            AppLocalizations.of(context)!.user_screen_button_delete,
            style: TextStyle(color: colors.error),
          ),
          trailing: Icon(MingCuteIcons.mgc_right_line, color: colors.error),
          onTap: () => Get.toNamed(AppRoutes.userDelete),
        ),
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
