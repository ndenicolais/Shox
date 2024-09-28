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
      case 'Sneakers':
        return S.current.category_sneakers;
      case 'Sandals':
        return S.current.category_sandals;
      case 'Boots':
        return S.current.category_boots;
      case 'Loafers':
        return S.current.category_loafers;
      case 'Ballets':
        return S.current.category_ballets;
      case 'Other':
        return S.current.category_other;
      default:
        return S.current.category_other;
    }
  }

  static String getTypeName(String type) {
    switch (type) {
      case 'Sport':
        return S.current.type_sport;
      case 'Casual':
        return S.current.type_casual;
      case 'Lifestyle':
        return S.current.type_lifestyle;
      case 'Running':
        return S.current.type_running;
      case 'Flat':
        return S.current.type_flat;
      case 'Heeled':
        return S.current.type_heeled;
      case 'Flip-Flops':
        return S.current.type_flip_flops;
      case 'Dressy':
        return S.current.type_dressy;
      case 'Ankle Boots':
        return S.current.type_ankle_boots;
      case 'High Boots':
        return S.current.type_high_boots;
      case 'Work Boots':
        return S.current.type_work_boots;
      case 'Knee-High':
        return S.current.type_knee_high;
      case 'Classic':
        return S.current.type_classic;
      case 'Other':
        return S.current.type_other;
      default:
        return S.current.type_other;
    }
  }
}
