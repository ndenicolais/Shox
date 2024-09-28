import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:shox/models/shoes_model.dart';
import 'package:shox/services/shoes_service.dart';

class DatabaseService {
  var logger = Logger();
  final ShoesService _shoesService;

  DatabaseService(this._shoesService);

  // This function retrieves a list of shoes asynchronously and returns the total count of shoes in the list.
  Future<int> getTotalShoesCount() async {
    List<Shoes> shoesList = await _shoesService.getShoes();
    return shoesList.length;
  }

  // This function retrieves a list of shoes asynchronously and returns a map containing the count of shoes for each color.
  Future<Map<String, int>> getShoesCountByColor() async {
    List<Shoes> shoesList = await _shoesService.getShoes();
    Map<String, int> colorCounts = {};

    for (var shoes in shoesList) {
      String colorHex = shoes.color.value.toRadixString(16);
      if (colorCounts.containsKey(colorHex)) {
        colorCounts[colorHex] = colorCounts[colorHex]! + 1;
      } else {
        colorCounts[colorHex] = 1;
      }
    }

    return colorCounts;
  }

  // This function retrieves a list of shoes asynchronously and returns a map containing the count of shoes for each brand.
  Future<Map<String, int>> getShoesCountByBrand() async {
    List<Shoes> shoesList = await _shoesService.getShoes();
    Map<String, int> brandCounts = {};

    for (var shoes in shoesList) {
      if (brandCounts.containsKey(shoes.brand)) {
        brandCounts[shoes.brand] = brandCounts[shoes.brand]! + 1;
      } else {
        brandCounts[shoes.brand] = 1;
      }
    }

    return brandCounts;
  }

  // This function retrieves a list of shoes asynchronously and returns a map containing the count of shoes for each category.
  Future<Map<String, int>> getShoesCountByCategory() async {
    List<Shoes> shoesList = await _shoesService.getShoes();
    Map<String, int> categoryCounts = {};

    for (var shoes in shoesList) {
      if (categoryCounts.containsKey(shoes.category)) {
        categoryCounts[shoes.category] = categoryCounts[shoes.category]! + 1;
      } else {
        categoryCounts[shoes.category] = 1;
      }
    }

    return categoryCounts;
  }

  // This function retrieves a list of shoes asynchronously and returns a map containing the count of shoes for each type.
  Future<Map<String, int>> getShoesCountByType() async {
    List<Shoes> shoesList = await _shoesService.getShoes();
    Map<String, int> typeCounts = {};

    for (var shoes in shoesList) {
      if (typeCounts.containsKey(shoes.type)) {
        typeCounts[shoes.type] = typeCounts[shoes.type]! + 1;
      } else {
        typeCounts[shoes.type] = 1;
      }
    }

    return typeCounts;
  }

  Future<Map<String, dynamic>> getCurrentUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    String userName = 'User';
    String userEmail = user.email ?? 'Email';
    String userId = user.uid;

    if (user.providerData.isNotEmpty &&
        user.providerData[0].providerId == 'google.com') {
      // If the user is logged in through Google, get the name from the Google account
      String? googleUserName = user.displayName;
      if (googleUserName != null) {
        List<String> nameParts = googleUserName.split(" ");
        userName = nameParts.isNotEmpty ? nameParts[0] : 'User';
      }
    } else {
      // Log in to Firestore to retrieve user data
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (docSnapshot.exists) {
        final userData = docSnapshot.data();
        userName = userData?['name'] ?? 'User';
      }
    }

    // Return user data as Map
    return {
      'userId': userId,
      'name': userName,
      'email': userEmail,
    };
  }

  Future<DateTime> getUserCreationDate(String userId) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    // Check if the user ID matches
    if (user.uid == userId) {
      DateTime creationDate = user.metadata.creationTime!;
      return creationDate;
    } else {
      throw Exception('User ID mismatch');
    }
  }
}
