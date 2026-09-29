import 'package:flutter/material.dart';

class AppColors {
  // Base palette
  static const Color whiteSmoke = Color(0xFFF6EFE5);
  static const Color darkGray = Color(0xFF342E25);
  static const Color darkPeach = Color(0xFFDA7C72);
  static const Color champagne = Color(0xFFF0D8B6);
  static const Color darkSalamon = Color(0xFFE09F7A);
  static const Color valspar = Color(0xFFE7D8C4);
  static const Color valsparDark = Color(0xFF463E30);
  static const Color confirmColor = Color(0xFF449777);
  static const Color errorColor = Color(0xFFD80032);
  static const Color toastLightGreen = Color(0xFFEAF8EA);
  static const Color toastDarkGreen = Color(0xFF449777);
  static const Color toastLightRed = Color(0xFFFFEBEA);
  static const Color toastDarkRed = Color(0xFFD80032);

  // Redesign (direction A): muted text, hairline outlines, raised cards
  static const Color mutedText = Color(0xFF6B6158);
  static const Color mutedTextDark = Color(0xFFCDBFAF);
  static const Color outline = Color(0xFFD9CBB8);
  static const Color outlineDark = Color(0xFF6A5F52);
  static const Color cardLight = Color(0xFFFFFFFF);

  // Semantic aliases
  static const Color background = whiteSmoke;
  static const Color backgroundDark = darkGray;
  static const Color accent = darkPeach;
  static const Color accentDark = champagne;
  static const Color surfaceLight = valspar;
  static const Color textPrimary = darkGray;
  static const Color textAccent = darkSalamon;
  static const Color success = confirmColor;
  static const Color error = errorColor;
}
