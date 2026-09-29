import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shox/theme/app_colors.dart';
import 'package:shox/theme/app_radius.dart';

const String _fontFamily = 'CustomFont';
const String _fontFamilyBold = 'CustomFontBold';

class AppTheme {
  static ThemeData lightTheme() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors.whiteSmoke,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return _baseTheme(
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
      bodyColor: AppColors.darkGray,
      hintColor: AppColors.darkPeach,
      borderColor: AppColors.darkPeach,
      cardColor: AppColors.valspar,
      selectionColor: AppColors.champagne,
      shadowColor: AppColors.darkGray,
    );
  }

  static ThemeData darkTheme() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors.darkGray,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
    return _baseTheme(
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkGray,
        onPrimary: AppColors.darkGray,
        secondary: AppColors.champagne,
        onSecondary: AppColors.darkGray,
        tertiary: AppColors.darkSalamon,
        onTertiary: AppColors.champagne,
        surface: AppColors.valsparDark,
        onSurface: AppColors.champagne,
        onError: AppColors.errorColor,
        tertiaryFixed: AppColors.darkPeach,
      ),
      bodyColor: AppColors.champagne,
      hintColor: AppColors.champagne,
      borderColor: AppColors.champagne,
      cardColor: AppColors.valsparDark,
      selectionColor: AppColors.darkSalamon,
      shadowColor: Colors.black,
    );
  }

  static ThemeData _baseTheme({
    required ColorScheme colorScheme,
    required Color bodyColor,
    required Color hintColor,
    required Color borderColor,
    required Color cardColor,
    required Color selectionColor,
    required Color shadowColor,
  }) {
    final textTheme = _textTheme(bodyColor);
    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.large),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.primary,
      splashFactory: InkSparkle.splashFactory,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.secondary,
        elevation: 0,
        scrolledUnderElevation: 3,
        shadowColor: shadowColor,
        surfaceTintColor: colorScheme.secondary,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontFamily: _fontFamilyBold,
          color: colorScheme.secondary,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 1,
        surfaceTintColor: Colors.transparent,
        shadowColor: shadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.extraLarge),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 1,
          shadowColor: shadowColor,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          shape: buttonShape,
          textStyle: const TextStyle(fontFamily: _fontFamilyBold),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          shape: buttonShape,
          textStyle: const TextStyle(fontFamily: _fontFamilyBold),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          shape: buttonShape,
          textStyle: const TextStyle(fontFamily: _fontFamilyBold),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: buttonShape,
          textStyle: const TextStyle(fontFamily: _fontFamilyBold),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          shape: const CircleBorder(),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.primary,
        surfaceTintColor: Colors.transparent,
        elevation: 4,
        shadowColor: shadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.dialog),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(fontFamily: _fontFamily, color: bodyColor),
        hintStyle: TextStyle(fontFamily: _fontFamily, color: hintColor),
        errorStyle: const TextStyle(
          fontFamily: _fontFamilyBold,
          color: AppColors.errorColor,
        ),
        counterStyle: TextStyle(fontFamily: _fontFamily, color: bodyColor),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.errorColor),
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.errorColor, width: 2),
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: selectionColor,
        selectionHandleColor: selectionColor,
      ),
      dividerTheme: DividerThemeData(
        color: borderColor,
        thickness: 1,
        space: 32,
      ),
    );
  }

  static TextTheme _textTheme(Color bodyColor) {
    return TextTheme(
      displayLarge: TextStyle(
          fontFamily: _fontFamilyBold, fontSize: 57, color: bodyColor),
      displayMedium: TextStyle(
          fontFamily: _fontFamilyBold, fontSize: 45, color: bodyColor),
      displaySmall: TextStyle(
          fontFamily: _fontFamilyBold, fontSize: 36, color: bodyColor),
      headlineLarge: TextStyle(
          fontFamily: _fontFamilyBold, fontSize: 32, color: bodyColor),
      headlineMedium: TextStyle(
          fontFamily: _fontFamilyBold, fontSize: 28, color: bodyColor),
      headlineSmall: TextStyle(
          fontFamily: _fontFamilyBold, fontSize: 24, color: bodyColor),
      titleLarge: TextStyle(
          fontFamily: _fontFamilyBold, fontSize: 22, color: bodyColor),
      titleMedium: TextStyle(
          fontFamily: _fontFamilyBold, fontSize: 16, color: bodyColor),
      titleSmall: TextStyle(
          fontFamily: _fontFamilyBold, fontSize: 14, color: bodyColor),
      bodyLarge: TextStyle(
          fontFamily: _fontFamily, fontSize: 16, color: bodyColor, height: 1.4),
      bodyMedium: TextStyle(
          fontFamily: _fontFamily, fontSize: 14, color: bodyColor, height: 1.4),
      bodySmall: TextStyle(
          fontFamily: _fontFamily, fontSize: 12, color: bodyColor, height: 1.4),
      labelLarge: TextStyle(
          fontFamily: _fontFamilyBold, fontSize: 14, color: bodyColor),
      labelMedium:
          TextStyle(fontFamily: _fontFamily, fontSize: 12, color: bodyColor),
      labelSmall:
          TextStyle(fontFamily: _fontFamily, fontSize: 11, color: bodyColor),
    );
  }
}
