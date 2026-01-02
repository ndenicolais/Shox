import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return SizedBox(
      width: width,
      height: height,
      child: MaterialButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.r),
          side: isOutline ? BorderSide(color: textColor) : BorderSide.none,
        ),
        color: backgroundColor,
        child: Center(
          child: icon != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      color: textColor,
                      size: iconSize ?? 24.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      text,
                      style: GoogleFonts.montserrat(
                        color: textColor,
                        fontSize: fontSize,
                      ),
                    ),
                  ],
                )
              : Text(
                  text,
                  style: GoogleFonts.montserrat(
                    color: textColor,
                    fontSize: fontSize,
                  ),
                ),
        ),
      ),
    );
  }
}
