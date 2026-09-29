import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shox/theme/app_spacing.dart';

/// App-wide text button, filled or outlined.
///
/// Colors default to the theme (`primary` background with `onPrimary` text
/// when filled, `onSurface` text with an `outline` border when outlined);
/// shape (stadium) and label style come from the theme's button themes.
/// A null [onPressed] renders the button disabled, [isLoading] swaps the
/// label for a spinner while keeping the button size.
class ButtonWidget extends StatelessWidget {
  /// Material minimum touch target.
  static const double minTouchTarget = 48;

  final double? width;
  final double? height;
  final Color? backgroundColor;
  final String text;
  final Color? textColor;
  final double? fontSize;
  final VoidCallback? onPressed;
  final bool isOutline;
  final bool isLoading;
  final IconData? icon;
  final double? iconSize;

  const ButtonWidget({
    super.key,
    this.width,
    this.height,
    this.backgroundColor,
    required this.text,
    this.textColor,
    this.fontSize,
    required this.onPressed,
    this.isOutline = false,
    this.isLoading = false,
    this.icon,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final Color foreground = textColor ??
        (isOutline ? colorScheme.onSurface : colorScheme.onPrimary);
    final Color background = backgroundColor ?? colorScheme.primary;
    final VoidCallback? action = isLoading ? null : onPressed;
    final bool isDisabled = onPressed == null;

    final label = Theme.of(context).textTheme.labelLarge!.copyWith(
          color: isDisabled ? foreground.withValues(alpha: 0.6) : foreground,
          fontSize: fontSize,
        );
    // Labels shrink instead of overflowing when a fixed-width button meets a
    // long translation or a large OS text size.
    final Widget content = Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs.w),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: isLoading
            ? Semantics(
                label: text,
                child: SizedBox.square(
                  dimension: 20.r,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: foreground,
                  ),
                ),
              )
            : icon != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, color: foreground, size: iconSize ?? 24.sp),
                      SizedBox(width: 8.w),
                      Text(text, style: label),
                    ],
                  )
                : Text(text, style: label),
      ),
    );

    final Widget button = isOutline
        ? OutlinedButton(
            onPressed: action,
            style: OutlinedButton.styleFrom(
              foregroundColor: foreground,
              side: BorderSide(
                color: colorScheme.outline
                    .withValues(alpha: action == null ? 0.4 : 1),
              ),
              backgroundColor: Colors.transparent,
              padding: EdgeInsets.zero,
            ),
            child: content,
          )
        : ElevatedButton(
            onPressed: action,
            style: ElevatedButton.styleFrom(
              backgroundColor: background,
              foregroundColor: foreground,
              // While loading keep the enabled look; otherwise fade it out.
              disabledBackgroundColor:
                  background.withValues(alpha: isLoading ? 1 : 0.4),
              disabledForegroundColor: foreground,
              padding: EdgeInsets.zero,
            ),
            child: content,
          );

    return SizedBox(
      width: width,
      height: height == null ? null : math.max(height!, minTouchTarget),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: minTouchTarget),
        child: button,
      ),
    );
  }
}
