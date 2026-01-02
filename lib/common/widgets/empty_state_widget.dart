import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shox/theme/app_font_sizes.dart';

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color? iconColor;

  const EmptyStateWidget({
    super.key,
    required this.message,
    required this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 260.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80.sp,
              color: iconColor ?? Theme.of(context).colorScheme.secondary,
            ),
            Text(
              message,
              style: GoogleFonts.montserrat(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: AppFontSizes.mediumLarge,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
