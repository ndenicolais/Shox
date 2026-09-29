import 'package:flutter/material.dart';
import 'package:shox/theme/app_breakpoints.dart';

class ResponsiveCenterWidget extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ResponsiveCenterWidget({
    required this.child,
    this.maxWidth = AppBreakpoints.maxContentWidth,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
