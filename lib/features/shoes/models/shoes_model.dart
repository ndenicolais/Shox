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

  Map<String, dynamic> toFirestore() {
    return {
      'imageUrl': imageUrl,
      'colorPrimary': colorPrimary.value,
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

  factory ShoesModel.fromFirestore(String id, Map<String, dynamic> data) {
    return ShoesModel(
      id: id,
      imageUrl: data['imageUrl'],
      colorPrimary: Color(data['colorPrimary']),
      colorExtra: List<int>.from(data['colorExtra'] ?? []),
      brand: data['brand'],
      size: data['size'],
      category: data['category'],
      type: data['type'],
      season: data['season'],
      notes: data['notes'],
      isFavorite: data['isFavorite'],
      dateAdded: (data['dateAdded'] as Timestamp).toDate(),
      dateUpdated: (data['dateUpdated'] as Timestamp).toDate(),
    );
  }

  factory ShoesModel.fromJson(String id, Map<String, dynamic> data) {
    // Handle dates that can be either String (from JSON import) or Timestamp (from Firestore)
    DateTime parseDateAddedFromJson(dynamic value) {
      if (value is Timestamp) {
        return value.toDate();
      } else if (value is String) {
        return DateTime.parse(value);
      }
      return DateTime.now();
    }

    DateTime parseDateUpdatedFromJson(dynamic value) {
      if (value is Timestamp) {
        return value.toDate();
      } else if (value is String) {
        return DateTime.parse(value);
      }
      return DateTime.now();
    }

    return ShoesModel(
      id: id,
      imageUrl: data['imageUrl'],
      colorPrimary: Color(data['colorPrimary']),
      colorExtra: List<int>.from(data['colorExtra'] ?? []),
      brand: data['brand'],
      size: data['size'],
      category: data['category'],
      type: data['type'],
      season: data['season'],
      notes: data['notes'],
      isFavorite: data['isFavorite'] ?? false,
      dateAdded: parseDateAddedFromJson(data['dateAdded']),
      dateUpdated: parseDateUpdatedFromJson(data['dateUpdated']),
    );
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
