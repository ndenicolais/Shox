import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shox/theme/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors.lightYellow,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
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
        counterStyle: GoogleFonts.montserrat(
          color: AppColors.smoothBlack,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.errorColor,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.darkPeach,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.darkPeach,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        selectionColor: AppColors.darkGold,
        selectionHandleColor: AppColors.darkGold,
      ),
    );
  }

  static ThemeData darkTheme() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors.smoothBlack,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
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
        counterStyle: GoogleFonts.montserrat(
          color: AppColors.lightYellow,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.errorColor,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.darkGold,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.darkGold,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        selectionColor: AppColors.lightPeach,
        selectionHandleColor: AppColors.lightPeach,
      ),
    );
  }
}
