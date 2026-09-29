import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color? iconColor;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    required this.message,
    required this.icon,
    this.iconColor,
    this.actionLabel,
    this.onAction,
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
            SizedBox(height: 16.h),
            Text(
              message,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: 12.h),
              TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  minimumSize: Size(0, 48.h),
                  foregroundColor: Theme.of(context).colorScheme.secondary,
                ),
                child: Text(
                  actionLabel!,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
