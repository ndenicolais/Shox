import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/theme/app_font_sizes.dart';

class MenuItemWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? textColor;
  final Widget? trailing;
  final bool? switchValue;
  final ValueChanged<bool>? onChanged;

  const MenuItemWidget({
    required this.icon,
    required this.text,
    this.onTap,
    this.iconColor,
    this.textColor,
    this.trailing,
    this.switchValue,
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.secondary,
      ),
      title: Text(
        text,
        style: GoogleFonts.poppins(
          color: Theme.of(context).colorScheme.tertiary,
          fontSize: AppFontSizes.small,
        ),
      ),
      trailing: trailing ??
          (switchValue != null && onChanged != null
              ? Switch(
                  value: switchValue!,
                  onChanged: onChanged,
                  activeColor: Theme.of(context).colorScheme.tertiary,
                )
              : Icon(
                  MingCuteIcons.mgc_right_line,
                  color: Theme.of(context).colorScheme.tertiary,
                )),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 0.r),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      hoverColor: Theme.of(context).colorScheme.secondary,
    );
  }
}
