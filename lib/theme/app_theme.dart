import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: GoogleFonts.montserrat(
          color: AppColors.smoothBlack,
        ),
        hintStyle: GoogleFonts.montserrat(
          color: AppColors.darkPeach,
        ),
        errorStyle: GoogleFonts.montserrat(
          color: AppColors.errorColor,
          fontWeight: FontWeight.w600,
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.errorColor,
          ),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.darkPeach,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.darkPeach,
          ),
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        selectionColor: AppColors.darkGold,
        selectionHandleColor: AppColors.darkGold,
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      colorScheme: const ColorScheme.dark(
        primary: AppColors.smoothBlack,
        onPrimary: AppColors.smoothBlack,
        secondary: AppColors.darkGold,
        onSecondary: AppColors.smoothBlack,
        tertiary: AppColors.lightYellow,
        onTertiary: AppColors.darkGold,
        surface: AppColors.lightGrey,
        onSurface: AppColors.smoothBlack,
        onError: AppColors.errorColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: GoogleFonts.montserrat(
          color: AppColors.lightYellow,
        ),
        hintStyle: GoogleFonts.montserrat(
          color: AppColors.darkGold,
        ),
        errorStyle: GoogleFonts.montserrat(
          color: AppColors.errorColor,
          fontWeight: FontWeight.w600,
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.errorColor,
          ),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.darkGold,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.darkGold,
          ),
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        selectionColor: AppColors.lightPeach,
        selectionHandleColor: AppColors.lightPeach,
      ),
    );
  }
}
