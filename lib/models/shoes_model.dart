import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShoesModel {
  String? id;
  String imageUrl;
  Color colorPrimary;
  Color? colorSecondary;
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
    this.colorSecondary,
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
      'colorSecondary': colorSecondary!.value,
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
      colorSecondary: Color(data['colorSecondary']),
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

  static Map<String, List<String>> categoryToTypes = {
    'Sneakers': ['Sport', 'Casual', 'Lifestyle', 'Running'],
    'Elegant': ['Dressy', 'Loafers'],
    'Heeled': ['Decollete', 'Spuntas', 'Wedge', 'Lace-Up'],
    'Sandals': ['Flat', 'Heeled'],
    'Boots': ['Ankle Boots', 'High Boots', 'Work Boots', 'Knee-High'],
    'Mules': ['Flat', 'Heeled'],
    'Other': ['Other'],
  };

  static List<String> seasonOptions = [
    'All',
    'Summer',
    'Autumn',
    'Winter',
    'Spring',
  ];
}
