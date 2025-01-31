import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShoesModel {
  String? id;
  String imageUrl;
  Color color;
  Color? detailsColor;
  IconData? seasonIcon;
  static List<IconData> seasonOptions = [
    Icons.sunny,
    Icons.ac_unit,
    Icons.star,
  ];
  String brand;
  String size;
  String category;
  String type;
  String? notes;
  bool isFavorite;
  DateTime dateAdded;
  DateTime dateUpdated;

  ShoesModel({
    this.id,
    required this.imageUrl,
    required this.color,
    this.detailsColor,
    this.seasonIcon,
    required this.brand,
    required this.size,
    required this.category,
    String? type,
    this.notes,
    this.isFavorite = false,
    DateTime? dateAdded,
    DateTime? dateUpdated,
  })  : type = type ?? _determineType(category),
        dateAdded = dateAdded ?? DateTime.now(),
        dateUpdated = dateUpdated ?? DateTime.now();

  static String _determineType(String category) {
    return categoryToTypes[category]?.first ?? 'Other';
  }

  Map<String, dynamic> toFirestore() {
    return {
      'imageUrl': imageUrl,
      'color': color.value,
      'detailsColor': detailsColor!.value,
      'seasonIcon':
          seasonIcon != null ? seasonIcon!.codePoint : Icons.star.codePoint,
      'brand': brand,
      'size': size,
      'category': category,
      'type': type,
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
      color: Color(data['color']),
      detailsColor: Color(data['detailsColor']),
      seasonIcon: data['seasonIcon'] != null
          ? IconData(data['seasonIcon'], fontFamily: 'MaterialIcons')
          : Icons.star,
      brand: data['brand'],
      size: data['size'],
      category: data['category'],
      type: data['type'],
      notes: data['notes'],
      isFavorite: data['isFavorite'],
      dateAdded: (data['dateAdded'] as Timestamp).toDate(),
      dateUpdated: (data['dateUpdated'] as Timestamp).toDate(),
    );
  }

  static Map<String, List<String>> categoryToTypes = {
    'Sneakers': ['Sport', 'Casual', 'Lifestyle', 'Running'],
    'Sandals': ['Flat', 'Heeled', 'Flip-Flops', 'Dressy'],
    'Boots': ['Ankle Boots', 'High Boots', 'Work Boots', 'Knee-High'],
    'Loafers': ['Classic', 'Dressy', 'Casual', 'Moccasins'],
    'Ballets': ['Classic', 'Flat', 'Dressy', 'Casual'],
    'Other': ['Other'],
  };

  static List<String> categoryOptions = [
    'Sneakers',
    'Sandals',
    'Boots',
    'Loafers',
    'Ballets',
    'Other',
  ];
}
