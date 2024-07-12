import 'package:flutter/material.dart';
import 'package:shox/theme/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightYellow,
        onPrimary: AppColors.lightYellow,
        secondary: AppColors.redPeach,
        onSecondary: AppColors.lightYellow,
        tertiary: AppColors.smoothBlack,
        onTertiary: AppColors.redPeach,
        surface: AppColors.lightYellow,
        onSurface: AppColors.lightYellow,
        onError: AppColors.errorColor,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        selectionHandleColor: AppColors.redPeach,
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      colorScheme: const ColorScheme.dark(
        primary: AppColors.redPeach,
        onPrimary: AppColors.redPeach,
        secondary: AppColors.lightYellow,
        onSecondary: AppColors.redPeach,
        tertiary: AppColors.smoothBlack,
        onTertiary: AppColors.lightYellow,
        surface: AppColors.redPeach,
        onSurface: AppColors.redPeach,
        onError: AppColors.errorColor,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        selectionHandleColor: AppColors.lightYellow,
      ),
    );
  }
}
