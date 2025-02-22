import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DbLocalizedValues {
  static String getColorName(BuildContext context, Color color) {
    final colorHex = color.value
        .toRadixString(16)
        .padLeft(8, '0')
        .toUpperCase()
        .substring(2);

    switch (colorHex) {
      case 'FFFFFF':
        return AppLocalizations.of(context)!.color_white;
      case '000000':
        return AppLocalizations.of(context)!.color_black;
      case 'BFBFBF':
        return AppLocalizations.of(context)!.color_light_grey;
      case '757575':
        return AppLocalizations.of(context)!.color_dark_grey;
      case 'FF962E':
        return AppLocalizations.of(context)!.color_orange;
      case 'FFDAE3':
        return AppLocalizations.of(context)!.color_pink;
      case 'FF2810':
        return AppLocalizations.of(context)!.color_red;
      case '760000':
        return AppLocalizations.of(context)!.color_bordeaux;
      case 'B37B4E':
        return AppLocalizations.of(context)!.color_camel;
      case 'D9D0B5':
        return AppLocalizations.of(context)!.color_beige;
      case '927D67':
        return AppLocalizations.of(context)!.color_light_brown;
      case '654321':
        return AppLocalizations.of(context)!.color_dark_brown;
      case 'FFE79E':
        return AppLocalizations.of(context)!.color_yellow;
      case '91AA80':
        return AppLocalizations.of(context)!.color_green;
      case '425797':
        return AppLocalizations.of(context)!.color_light_blue;
      case '05003E':
        return AppLocalizations.of(context)!.color_dark_blue;
      default:
        return AppLocalizations.of(context)!.color_white;
    }
  }

  static String getCategoryName(BuildContext context, String category) {
    switch (category) {
      case 'Sneakers':
        return AppLocalizations.of(context)!.category_sneakers;
      case 'Elegant':
        return AppLocalizations.of(context)!.category_elegant;
      case 'Heeled':
        return AppLocalizations.of(context)!.category_heeled;
      case 'Sandals':
        return AppLocalizations.of(context)!.category_sandals;
      case 'Boots':
        return AppLocalizations.of(context)!.category_boots;
      case 'Mules':
        return AppLocalizations.of(context)!.category_mules;
      case 'Other':
        return AppLocalizations.of(context)!.category_other;
      default:
        return AppLocalizations.of(context)!.category_other;
    }
  }

  static String getTypeName(BuildContext context, String type) {
    switch (type) {
      case 'Sport':
        return AppLocalizations.of(context)!.type_sport;
      case 'Casual':
        return AppLocalizations.of(context)!.type_casual;
      case 'Lifestyle':
        return AppLocalizations.of(context)!.type_lifestyle;
      case 'Running':
        return AppLocalizations.of(context)!.type_running;
      case 'Dressy':
        return AppLocalizations.of(context)!.type_dressy;
      case 'Loafers':
        return AppLocalizations.of(context)!.type_loafers;
      case 'Decollete':
        return AppLocalizations.of(context)!.type_decollete;
      case 'Spuntas':
        return AppLocalizations.of(context)!.type_spuntas;
      case 'Wedge':
        return AppLocalizations.of(context)!.type_wedge;
      case 'Lace-Up':
        return AppLocalizations.of(context)!.type_lace_up;
      case 'Flat':
        return AppLocalizations.of(context)!.type_flat;
      case 'Heeled':
        return AppLocalizations.of(context)!.type_heeled;
      case 'Ankle Boots':
        return AppLocalizations.of(context)!.type_ankle_boots;
      case 'High Boots':
        return AppLocalizations.of(context)!.type_high_boots;
      case 'Work Boots':
        return AppLocalizations.of(context)!.type_work_boots;
      case 'Knee-High':
        return AppLocalizations.of(context)!.type_knee_high;
      case 'Classic':
        return AppLocalizations.of(context)!.type_classic;
      case 'Other':
        return AppLocalizations.of(context)!.type_other;
      default:
        return AppLocalizations.of(context)!.type_other;
    }
  }
}
