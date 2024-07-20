import 'package:flutter/material.dart';
import 'package:shox/theme/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightYellow,
        onPrimary: AppColors.lightYellow,
        secondary: AppColors.darkPeach,
        onSecondary: AppColors.lightYellow,
        tertiary: AppColors.smoothBlack,
        onTertiary: AppColors.darkPeach,
        surface: AppColors.lightPeach,
        onSurface: AppColors.smoothBlack,
        onError: AppColors.errorColor,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        selectionColor: AppColors.lightPeach,
        selectionHandleColor: AppColors.lightPeach,
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      colorScheme: const ColorScheme.dark(
        primary: AppColors.smoothBlack,
        onPrimary: AppColors.smoothBlack,
        secondary: AppColors.lightYellow,
        onSecondary: AppColors.smoothBlack,
        tertiary: AppColors.lightYellow,
        onTertiary: AppColors.lightYellow,
        surface: AppColors.lightYellow,
        onSurface: AppColors.smoothBlack,
        onError: AppColors.errorColor,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        selectionColor: AppColors.lightPeach,
        selectionHandleColor: AppColors.lightPeach,
      ),
    );
  }
}
