import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shox/theme/app_radius.dart';

class ButtonWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final Color backgroundColor;
  final String text;
  final Color textColor;
  final double? fontSize;
  final VoidCallback onPressed;
  final bool isOutline;
  final IconData? icon;
  final double? iconSize;

  const ButtonWidget({
    super.key,
    this.width,
    this.height,
    required this.backgroundColor,
    required this.text,
    required this.textColor,
    this.fontSize,
    required this.onPressed,
    this.isOutline = false,
    this.icon,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.large),
    );
    final label = TextStyle(
      fontFamily: 'CustomFont',
      color: textColor,
      fontSize: fontSize,
    );
    final content = Center(
      child: icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: textColor, size: iconSize ?? 24.sp),
                SizedBox(width: 8.w),
                Text(text, style: label),
              ],
            )
          : Text(text, style: label),
    );

    if (isOutline) {
      return SizedBox(
        width: width,
        height: height,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: textColor,
            side: BorderSide(color: textColor),
            shape: shape,
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
          ),
          child: content,
        ),
      );
    }
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 1,
          shape: shape,
          padding: EdgeInsets.zero,
        ),
        child: content,
      ),
    );
  }
}
