/// Spacing scale for paddings, margins and gaps.
///
/// Raw values like [AppRadius]: call sites keep choosing the ScreenUtil
/// scaling that fits the axis (`AppSpacing.m.r`, `AppSpacing.xs.h`, ...).
class AppSpacing {
  static const double grid = 2;
  static const double xxs = 4;
  static const double xs = 8;
  static const double s = 12;
  static const double m = 16;
  static const double l = 20;
  static const double xl = 24;
  static const double xxl = 32;

  /// Outer padding of full-page content (auth, welcome, info screens...).
  static const double screen = 30;
}
