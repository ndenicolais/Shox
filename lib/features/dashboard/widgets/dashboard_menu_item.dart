import 'package:flutter/material.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/theme/app_radius.dart';
import 'package:shox/theme/app_spacing.dart';

/// Settings row: icon in a soft square, label and a trailing widget
/// (chevron by default, or a switch when [switchValue] is given).
class DashboardMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? textColor;
  final Widget? trailing;
  final bool? switchValue;
  final ValueChanged<bool>? onChanged;

  const DashboardMenuItem({
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
    final colors = Theme.of(context).colorScheme;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
        child: Icon(icon, size: 20, color: iconColor ?? colors.onSurface),
      ),
      title: Text(
        text,
        style: textColor != null ? TextStyle(color: textColor) : null,
      ),
      trailing: trailing ??
          (switchValue != null && onChanged != null
              ? Switch(value: switchValue!, onChanged: onChanged)
              : onTap != null
                  ? Icon(
                      MingCuteIcons.mgc_right_line,
                      color: colors.onSurfaceVariant,
                    )
                  : null),
    );
  }
}
