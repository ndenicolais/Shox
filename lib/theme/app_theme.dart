import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shox/theme/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors.whiteSmoke,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return ThemeData(
      colorScheme: const ColorScheme.light(
        primary: AppColors.whiteSmoke,
        onPrimary: AppColors.whiteSmoke,
        secondary: AppColors.darkPeach,
        onSecondary: AppColors.whiteSmoke,
        tertiary: AppColors.darkGray,
        onTertiary: AppColors.darkPeach,
        surface: AppColors.darkSalamon,
        onSurface: AppColors.darkGray,
        onError: AppColors.errorColor,
        tertiaryFixed: AppColors.valspar,
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: GoogleFonts.montserrat(
          color: AppColors.darkGray,
        ),
        hintStyle: GoogleFonts.montserrat(
          color: AppColors.darkPeach,
        ),
        errorStyle: GoogleFonts.montserrat(
          color: AppColors.errorColor,
          fontWeight: FontWeight.w600,
        ),
        counterStyle: GoogleFonts.montserrat(
          color: AppColors.darkGray,
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
        selectionColor: AppColors.champagne,
        selectionHandleColor: AppColors.champagne,
      ),
    );
  }

  static ThemeData darkTheme() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors.darkGray,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
    return ThemeData(
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkGray,
        onPrimary: AppColors.darkGray,
        secondary: AppColors.champagne,
        onSecondary: AppColors.darkGray,
        tertiary: AppColors.darkSalamon,
        onTertiary: AppColors.champagne,
        surface: AppColors.valspar,
        onSurface: AppColors.darkGray,
        onError: AppColors.errorColor,
        tertiaryFixed: AppColors.darkPeach,
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: GoogleFonts.montserrat(
          color: AppColors.whiteSmoke,
        ),
        hintStyle: GoogleFonts.montserrat(
          color: AppColors.champagne,
        ),
        errorStyle: GoogleFonts.montserrat(
          color: AppColors.errorColor,
          fontWeight: FontWeight.w600,
        ),
        counterStyle: GoogleFonts.montserrat(
          color: AppColors.whiteSmoke,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.errorColor,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.champagne,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.champagne,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        selectionColor: AppColors.darkSalamon,
        selectionHandleColor: AppColors.darkSalamon,
      ),
    );
  }
}
