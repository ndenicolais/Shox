import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shox/theme/app_font_sizes.dart';

class ColorChip extends StatelessWidget {
  final Color color;
  final bool isPrimary;
  final String label;
  final double? size;
  final VoidCallback? onTap;

  const ColorChip({
    super.key,
    required this.color,
    this.isPrimary = false,
    required this.label,
    this.size,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 30.w,
            height: 30.h,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isPrimary
                  ? Border.all(
                      color: Theme.of(context).colorScheme.onSurface,
                      width: 1,
                    )
                  : null,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'CustomFont',
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: AppFontSizes.regular,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
