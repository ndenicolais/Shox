import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shox/theme/app_font_sizes.dart';

class FormFieldCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget child;

  const FormFieldCard({
    super.key,
    required this.icon,
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: colorScheme.tertiary, size: 20.sp),
                SizedBox(width: 4.w),
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'CustomFontBold',
                    color: colorScheme.tertiary,
                    fontSize: AppFontSizes.small,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            child,
          ],
        ),
      ),
    );
  }
}
