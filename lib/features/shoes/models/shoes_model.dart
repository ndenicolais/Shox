import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShoesModel {
  String? id;
  String imageUrl;
  Color colorPrimary;
  List<int>? colorExtra;
  String brand;
  String size;
  String category;
  String type;
  String? season;
  String? notes;
  bool isFavorite;
  DateTime dateAdded;
  DateTime dateUpdated;

  ShoesModel({
    this.id,
    required this.imageUrl,
    required this.colorPrimary,
    this.colorExtra,
    required this.brand,
    required this.size,
    required this.category,
    String? type,
    String? season,
    this.notes,
    this.isFavorite = false,
    DateTime? dateAdded,
    DateTime? dateUpdated,
  })  : type = type ?? _determineType(category),
        season = season ?? 'All',
        dateAdded = dateAdded ?? DateTime.now(),
        dateUpdated = dateUpdated ?? DateTime.now();

  static String _determineType(String category) {
    return categoryToTypes[category]?.first ?? 'Other';
  }

  ShoesModel copyWith({
    String? id,
    String? imageUrl,
    DateTime? dateUpdated,
  }) {
    return ShoesModel(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      colorPrimary: colorPrimary,
      colorExtra: colorExtra,
      brand: brand,
      size: size,
      category: category,
      type: type,
      season: season,
      notes: notes,
      isFavorite: isFavorite,
      dateAdded: dateAdded,
      dateUpdated: dateUpdated ?? this.dateUpdated,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'imageUrl': imageUrl,
      'colorPrimary': colorPrimary.toARGB32(),
      'colorExtra': colorExtra,
      'brand': brand,
      'size': size,
      'category': category,
      'type': type,
      'season': season,
      'notes': notes,
      'isFavorite': isFavorite,
      'dateAdded': Timestamp.fromDate(dateAdded),
      'dateUpdated': Timestamp.fromDate(dateUpdated),
    };
  }

  /// Same fields as [toFirestore] with ISO 8601 dates, for backup files.
  Map<String, dynamic> toJson() => {
        ...toFirestore(),
        'dateAdded': dateAdded.toIso8601String(),
        'dateUpdated': dateUpdated.toIso8601String(),
      };

  /// Used for the primary color when the stored value is missing or invalid.
  static const int fallbackColor = 0xFF9E9E9E;

  /// Both factories are lenient: a missing or wrongly typed field falls back
  /// to a default instead of throwing, so one malformed document cannot break
  /// the whole shoes list and the user can still open and fix it.
  factory ShoesModel.fromFirestore(String id, Map<String, dynamic> data) =>
      ShoesModel.fromJson(id, data);

  /// Dates may be a Firestore [Timestamp], a [DateTime], an ISO 8601 string
  /// (JSON backup) or milliseconds since epoch.
  factory ShoesModel.fromJson(String id, Map<String, dynamic> data) {
    final category = _readString(data['category']);
    return ShoesModel(
      id: id,
      imageUrl: _readString(data['imageUrl']) ?? '',
      colorPrimary: Color(_readInt(data['colorPrimary']) ?? fallbackColor),
      colorExtra: _readIntList(data['colorExtra']),
      brand: _readString(data['brand']) ?? '',
      size: _readString(data['size']) ?? '',
      category: (category == null || category.isEmpty) ? 'Other' : category,
      type: _readString(data['type']),
      season: _readString(data['season']),
      notes: _readString(data['notes']),
      isFavorite: data['isFavorite'] is bool ? data['isFavorite'] : false,
      dateAdded: _readDate(data['dateAdded']),
      dateUpdated: _readDate(data['dateUpdated']),
    );
  }

  static String? _readString(dynamic value) {
    if (value is String) return value;
    if (value is num) return value.toString();
    return null;
  }

  static int? _readInt(dynamic value) => value is num ? value.toInt() : null;

  static List<int> _readIntList(dynamic value) {
    if (value is! List) return [];
    return value.whereType<num>().map((n) => n.toInt()).toList();
  }

  static DateTime? _readDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return null;
  }

  static Map<String, List<String>> categoryToTypes = {
    'Sneakers': ['Sport', 'Casual', 'Lifestyle', 'Running'],
    'Elegant': ['Dressy', 'Loafers'],
    'Heeled': ['Decollete', 'Spuntas', 'Wedge', 'Lace-Up'],
    'Sandals': ['Flat', 'Heeled'],
    'Boots': ['Ankle Boots', 'High Boots', 'Work Boots', 'Knee-High'],
    'Mules': ['Flat', 'Heeled'],
    'Other': ['Other'],
  };

  // Categories specific for male users
  static Map<String, List<String>> maleCategoryToTypes = {
    'Sneakers': ['Sport', 'Casual', 'Lifestyle', 'Running'],
    'Elegant': ['Dressy', 'Loafers', 'Oxford', 'Derby'],
    'Sandals': ['Flat', 'Sport'],
    'Loafers': ['Classic', 'Penny', 'Tassel'],
    'Other': ['Other'],
  };

  // Categories specific for female users
  static Map<String, List<String>> femaleCategoryToTypes = {
    'Sneakers': ['Sport', 'Casual', 'Lifestyle', 'Running'],
    'Elegant': ['Dressy', 'Loafers'],
    'Heeled': ['Decollete', 'Spuntas', 'Wedge', 'Lace-Up', 'Platform'],
    'Sandals': ['Flat', 'Heeled', 'Gladiator'],
    'Boots': ['Ankle Boots', 'High Boots', 'Knee-High', 'Over-the-Knee'],
    'Mules': ['Flat', 'Heeled'],
    'Flats': ['Ballet', 'Pointed', 'Loafers'],
    'Other': ['Other'],
  };

  // Get categories based on gender
  static Map<String, List<String>> getCategoryToTypesByGender(String? gender) {
    switch (gender) {
      case 'male':
        return maleCategoryToTypes;
      case 'female':
        return femaleCategoryToTypes;
      default:
        return categoryToTypes; // fallback to all categories
    }
  }

  static List<String> seasonOptions = [
    'All',
    'Summer',
    'Autumn',
    'Winter',
    'Spring',
  ];
}
