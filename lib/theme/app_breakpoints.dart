import 'package:flutter/material.dart';

class AppBreakpoints {
  static const double tablet = 600;
  static const double desktop = 900;
  static const double maxContentWidth = 720;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).shortestSide >= tablet;

  static bool isWide(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= desktop;

  static int gridColumnsForWidth(double width, {int minColumns = 1}) {
    if (width >= desktop) return 4;
    if (width >= tablet) return 3;
    if (width >= 400) return 2;
    return minColumns;
  }
}
