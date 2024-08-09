import 'package:flutter/material.dart';
import 'package:shox/generated/l10n.dart';

class DbLocalizedValues {
  static String getColorName(Color color) {
    final colorHex = color.value
        .toRadixString(16)
        .padLeft(8, '0')
        .toUpperCase()
        .substring(2);

    switch (colorHex) {
      case 'FFFFFF':
        return S.current.color_white;
      case '000000':
        return S.current.color_black;
      case 'BFBFBF':
        return S.current.color_light_grey;
      case '757575':
        return S.current.color_dark_grey;
      case 'FF962E':
        return S.current.color_orange;
      case 'FFDAE3':
        return S.current.color_pink;
      case 'FF2810':
        return S.current.color_red;
      case '760000':
        return S.current.color_bordeaux;
      case 'B37B4E':
        return S.current.color_camel;
      case 'D9D0B5':
        return S.current.color_beige;
      case '927D67':
        return S.current.color_light_brown;
      case '654321':
        return S.current.color_dark_brown;
      case 'FFE79E':
        return S.current.color_yellow;
      case '91AA80':
        return S.current.color_green;
      case '425797':
        return S.current.color_light_blue;
      case '05003E':
        return S.current.color_dark_blue;
      default:
        return S.current.color_white;
    }
  }

  static String getCategoryName(String category) {
    switch (category) {
      case 'Trainers':
        return S.current.category_trainers;
      case 'Casual':
        return S.current.category_casual;
      case 'Classic':
        return S.current.category_classic;
      case 'Work':
        return S.current.category_work;
      case 'Other':
        return S.current.category_other;
      default:
        return S.current.category_other;
    }
  }

  static String getTypeName(String type) {
    switch (type) {
      case 'Sneakers':
        return S.current.type_sneakers;
      case 'Sandals':
        return S.current.type_sandals;
      case 'Flat Sandals':
        return S.current.type_flat_sandals;
      case 'Heeled Sandals':
        return S.current.type_heeled_sandals;
      case 'Boots':
        return S.current.type_boots;
      case 'Hogan':
        return S.current.type_hogan;
      case 'Other':
        return S.current.type_other;
      default:
        return S.current.type_other;
    }
  }
}
