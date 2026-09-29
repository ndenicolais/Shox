import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shox/theme/app_colors.dart';
import 'package:shox/theme/app_radius.dart';

/// Montserrat registered with its real weights (400, 700) in pubspec.yaml.
const String _fontFamily = 'Montserrat';

class AppTheme {
  /// System bars style matching the active theme. Applied through an
  /// `AnnotatedRegion` in `main.dart`, so building a theme has no side effects.
  static SystemUiOverlayStyle overlayStyle({required bool isDark}) {
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      systemNavigationBarColor:
          isDark ? AppColors.darkGray : AppColors.whiteSmoke,
      systemNavigationBarIconBrightness:
          isDark ? Brightness.light : Brightness.dark,
    );
  }

  static ThemeData lightTheme() {
    return _baseTheme(
      // Semantic roles: surface = page background, onSurface = main text,
      // secondary = warm accent, primary = main actions (filled buttons,
      // selected chips), surfaceContainerLowest = raised cards.
      colorScheme: const ColorScheme.light(
        primary: AppColors.darkGray,
        onPrimary: AppColors.whiteSmoke,
        secondary: AppColors.darkPeach,
        onSecondary: AppColors.darkGray,
        tertiary: AppColors.champagne,
        onTertiary: AppColors.darkGray,
        surface: AppColors.whiteSmoke,
        onSurface: AppColors.darkGray,
        onSurfaceVariant: AppColors.mutedText,
        surfaceContainerLowest: AppColors.cardLight,
        outline: AppColors.outline,
        outlineVariant: AppColors.outline,
        error: AppColors.errorColor,
        onError: AppColors.whiteSmoke,
        tertiaryFixed: AppColors.valspar,
      ),
      cardColor: AppColors.cardLight,
      selectionColor: AppColors.champagne,
      shadowColor: AppColors.darkGray,
    );
  }

  static ThemeData darkTheme() {
    return _baseTheme(
      colorScheme: const ColorScheme.dark(
        primary: AppColors.champagne,
        onPrimary: AppColors.darkGray,
        secondary: AppColors.champagne,
        onSecondary: AppColors.darkGray,
        tertiary: AppColors.darkPeach,
        onTertiary: AppColors.darkGray,
        surface: AppColors.darkGray,
        onSurface: AppColors.darkSalamon,
        onSurfaceVariant: AppColors.mutedTextDark,
        surfaceContainerLowest: AppColors.valsparDark,
        outline: AppColors.outlineDark,
        outlineVariant: AppColors.outlineDark,
        error: AppColors.errorColor,
        onError: AppColors.whiteSmoke,
        tertiaryFixed: AppColors.darkPeach,
      ),
      cardColor: AppColors.valsparDark,
      selectionColor: AppColors.darkSalamon,
      shadowColor: Colors.black,
    );
  }

  static ThemeData _baseTheme({
    required ColorScheme colorScheme,
    required Color cardColor,
    required Color selectionColor,
    required Color shadowColor,
  }) {
    final textTheme = _textTheme(colorScheme);
    const stadium = StadiumBorder();
    const buttonMinSize = Size(64, 52);
    final fieldRadius = BorderRadius.circular(AppRadius.large);

    return ThemeData(
      useMaterial3: true,
      fontFamily: _fontFamily,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      splashFactory: InkSparkle.splashFactory,
      textTheme: textTheme,
      cardColor: cardColor,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        titleTextStyle: textTheme.titleMedium,
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          minimumSize: buttonMinSize,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shape: stadium,
          textStyle: textTheme.labelLarge,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: buttonMinSize,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shape: stadium,
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          side: BorderSide(color: colorScheme.outline),
          minimumSize: buttonMinSize,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shape: stadium,
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          shape: stadium,
          textStyle: textTheme.labelLarge,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          shape: const CircleBorder(),
          minimumSize: const Size(44, 44),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.secondary,
        foregroundColor: colorScheme.onSecondary,
        elevation: 4,
        highlightElevation: 6,
        shape: stadium,
        extendedTextStyle: textTheme.labelLarge,
      ),
      chipTheme: ChipThemeData(
        shape: stadium,
        side: BorderSide(color: colorScheme.outline),
        backgroundColor: Colors.transparent,
        selectedColor: colorScheme.primary,
        showCheckmark: false,
        labelStyle: textTheme.labelMedium,
        secondaryLabelStyle:
            textTheme.labelMedium?.copyWith(color: colorScheme.onPrimary),
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: colorScheme.primary,
          selectedForegroundColor: colorScheme.onPrimary,
          foregroundColor: colorScheme.onSurface,
          side: BorderSide(color: colorScheme.outline),
          textStyle: textTheme.labelMedium,
          minimumSize: const Size(0, 44),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 4,
        shadowColor: shadowColor,
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.dialog),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: colorScheme.outline,
        shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppRadius.dialog)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerLowest,
        labelStyle:
            textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
        floatingLabelStyle:
            textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
        hintStyle:
            textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
        errorStyle: textTheme.bodySmall?.copyWith(color: colorScheme.error),
        prefixIconColor: colorScheme.onSurfaceVariant,
        suffixIconColor: colorScheme.onSurfaceVariant,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: fieldRadius,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: fieldRadius,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
          borderRadius: fieldRadius,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.error),
          borderRadius: fieldRadius,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
          borderRadius: fieldRadius,
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colorScheme.onSurface,
        selectionColor: selectionColor,
        selectionHandleColor: selectionColor,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.secondary,
      ),
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colorScheme.secondary
              : null,
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colorScheme.onSurface,
        textColor: colorScheme.onSurface,
        titleTextStyle: textTheme.bodyLarge,
        subtitleTextStyle:
            textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outline,
        thickness: 1,
        space: 32,
      ),
    );
  }

  /// One type scale for the whole app (redesign direction A).
  static TextTheme _textTheme(ColorScheme colors) {
    final ink = colors.onSurface;
    final muted = colors.onSurfaceVariant;
    TextStyle style(
      double size,
      FontWeight weight,
      Color color, {
      double? letterSpacing,
      double? height,
    }) =>
        TextStyle(
          fontFamily: _fontFamily,
          fontSize: size,
          fontWeight: weight,
          color: color,
          letterSpacing: letterSpacing,
          height: height,
        );

    return TextTheme(
      displayLarge: style(57, FontWeight.w700, ink, letterSpacing: -1),
      displayMedium: style(45, FontWeight.w700, ink, letterSpacing: -0.8),
      displaySmall: style(36, FontWeight.w700, ink, letterSpacing: -0.6),
      headlineLarge: style(32, FontWeight.w700, ink, letterSpacing: -0.5),
      // Detail titles (shoe brand).
      headlineMedium: style(28, FontWeight.w700, ink, letterSpacing: -0.4),
      // Screen titles ("La tua collezione").
      headlineSmall: style(22, FontWeight.w700, ink, letterSpacing: -0.3),
      titleLarge: style(18, FontWeight.w700, ink),
      // App bar titles.
      titleMedium: style(16, FontWeight.w700, ink),
      // Card titles (brand in the grid).
      titleSmall: style(15, FontWeight.w700, ink),
      bodyLarge: style(16, FontWeight.w400, ink, height: 1.45),
      bodyMedium: style(14, FontWeight.w400, ink, height: 1.45),
      bodySmall: style(12, FontWeight.w400, muted, height: 1.4),
      // Buttons.
      labelLarge: style(15, FontWeight.w700, ink),
      // Chips.
      labelMedium: style(13, FontWeight.w400, ink),
      // Uppercase eyebrows ("TAGLIA", "NOTE").
      labelSmall: style(11, FontWeight.w700, muted, letterSpacing: 0.6),
    );
  }
}
