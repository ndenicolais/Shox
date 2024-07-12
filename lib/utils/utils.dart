import 'package:flutter/material.dart';

enum GridColumns { gOne, gTwo, gThree }

List<Color> colorList = [
  const Color(0xFFFFFFFF), // White
  const Color(0xFF000000), // Black
  const Color(0xFFBFBFBF), // Light Grey
  const Color(0xFF757575), // Dark Grey
  const Color(0xFFFF962E), // Orange
  const Color(0xFFFFDAE3), // Pink
  const Color(0xFFFF2810), // Red
  const Color(0xFF760000), // Bordeaux
  const Color(0xFFB37B4E), // Camel
  const Color(0xFFD9D0B5), // Beige
  const Color(0xFF927D67), // Light Brown
  const Color(0xFF654321), // Dark Brown
  const Color(0xFFFFE79E), // Yellow
  const Color(0xFF91AA80), // Green
  const Color(0xFF425797), // Light Blue
  const Color(0xFF05003E), // Dark Blue
];

Map<String, String> colorNames = {
  'FFFFFFFF': 'White',
  'FF000000': 'Black',
  'FFBFBFBF': 'Light Grey',
  'FF757575': 'Dark Grey',
  'FFFF962E': 'Orange',
  'FFFFDAE3': 'Pink',
  'FFFF2810': 'Red',
  'FF760000': 'Bordeaux',
  'FFB37B4E': 'Camel',
  'FFD9D0B5': 'Beige',
  'FF927D67': 'Light Brown',
  'FF654321': 'Dark Brown',
  'FFFFE79E': 'Yellow',
  'FF91AA80': 'Green',
  'FF425797': 'Light Blue',
  'FF05003E': 'Dark Blue',
};
