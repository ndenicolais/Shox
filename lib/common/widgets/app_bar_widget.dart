import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';

/// App bar with a back button; colors and title style come from the theme.
class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showLeading;
  final VoidCallback? onBackPressed;

  const AppBarWidget({
    super.key,
    required this.title,
    this.actions,
    this.showLeading = true,
    this.onBackPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showLeading
          ? IconButton(
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              icon: const Icon(MingCuteIcons.mgc_left_line),
              onPressed: onBackPressed ?? () => Get.back(),
            )
          : null,
      automaticallyImplyLeading: showLeading,
      title: Text(title),
      actions: actions,
    );
  }
}
