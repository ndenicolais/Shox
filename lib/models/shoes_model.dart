import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Shoes {
  String? id;
  bool isFavorite;
  String imageUrl;
  Color color;
  IconData? seasonIcon;
  static List<IconData> seasonOptions = [
    Icons.sunny,
    Icons.ac_unit,
    Icons.star
  ];
  String brand;
  String size;
  String category;
  static List<String> categoryOptions = [
    'Trainers',
    'Casual',
    'Classic',
    'Work',
    'Other'
  ];
  String type;
  static List<String> typeOptions = [
    'Sneakers',
    'Sandals',
    'Flat Sandals',
    'Heeled Sandals',
    'Boots',
    'Hogan',
    'Other'
  ];
  String? notes;
  DateTime dateAdded;

  Shoes({
    this.id,
    this.isFavorite = false,
    required this.imageUrl,
    required this.color,
    this.seasonIcon,
    required this.brand,
    required this.size,
    required this.category,
    required this.type,
    this.notes,
    DateTime? dateAdded,
  }) : dateAdded = dateAdded ?? DateTime.now();

  // Convert Shoes object to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isFavorite': isFavorite,
      'imageUrl': imageUrl,
      'color': color.value,
      'seasonIcon':
          seasonIcon != null ? seasonIcon!.codePoint : Icons.star.codePoint,
      'brand': brand,
      'size': size,
      'category': category,
      'type': type,
      'notes': notes,
      'dateAdded': dateAdded,
    };
  }

  // Create Shoes object from Map
  factory Shoes.fromMap(Map<String, dynamic> map, String documentId) {
    return Shoes(
      id: documentId,
      isFavorite: map['isFavorite'],
      imageUrl: map['imageUrl'],
      color: Color(map['color']),
      seasonIcon: map['seasonIcon'] != null
          ? IconData(map['seasonIcon'], fontFamily: 'MaterialIcons')
          : Icons.star,
      brand: map['brand'],
      size: map['size'],
      category: map['category'],
      type: map['type'],
      notes: map['notes'],
      dateAdded: (map['dateAdded'] as Timestamp).toDate(),
    );
  }
}
