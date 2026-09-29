import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/core/routes/app_routes.dart';
import 'package:shox/features/users/controller/user_controller.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:shox/theme/app_spacing.dart';

/// Home header: profile avatar, greeting, screen title and settings.
class TopBar extends StatelessWidget {
  final UserController userController;

  const TopBar({super.key, required this.userController});

  static const double _avatarSize = 44;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Obx(
      () => Row(
        children: [
          Tooltip(
            message: l10n.a11y_profile,
            child: Semantics(
              button: true,
              label: l10n.a11y_profile,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {
                  HapticFeedback.lightImpact();
                  Get.toNamed(AppRoutes.user);
                },
                child: _buildAvatar(
                  context,
                  userController.userProfileImage.value,
                  userController.userName.value,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${l10n.home_screen_welcome_text}, ${userController.userName.value}',
                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  l10n.home_screen_title,
                  style: theme.textTheme.headlineSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton.filled(
            tooltip: l10n.a11y_settings,
            style: IconButton.styleFrom(
              backgroundColor: theme.colorScheme.surfaceContainerLowest,
              foregroundColor: theme.colorScheme.onSurface,
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              Get.toNamed(AppRoutes.dashboard);
            },
            icon: const Icon(MingCuteIcons.mgc_settings_3_line),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, String imageUrl, String name) {
    final colors = Theme.of(context).colorScheme;
    final Widget fallback = Container(
      width: _avatarSize,
      height: _avatarSize,
      alignment: Alignment.center,
      color: colors.tertiaryFixed,
      child: name.trim().isNotEmpty
          ? Text(
              name.trim().characters.first.toUpperCase(),
              style: Theme.of(context).textTheme.titleMedium,
            )
          : Icon(MingCuteIcons.mgc_user_3_line, color: colors.onSurface),
    );

    Widget image = fallback;
    if (imageUrl.startsWith('http')) {
      image = CachedNetworkImage(
        imageUrl: imageUrl,
        width: _avatarSize,
        height: _avatarSize,
        fit: BoxFit.cover,
        placeholder: (context, url) => fallback,
        errorWidget: (context, url, error) => fallback,
      );
    } else if (imageUrl.isNotEmpty) {
      image = Image.file(
        File(imageUrl),
        width: _avatarSize,
        height: _avatarSize,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => fallback,
      );
    }
    return ClipOval(child: image);
  }
}
