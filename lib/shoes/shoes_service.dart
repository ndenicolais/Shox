import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shox/shoes/shoes_model.dart';

class ShoesService {
  var logger = Logger();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get the UID of the current user
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  // Get Shoes collection reference for current user
  CollectionReference getShoesCollection() {
    String? userId = getCurrentUserId();
    return _firestore.collection('users').doc(userId).collection('shoes');
  }

  // Adds a new Shoes object to Firestore collection and updates its ID based on Firestore generated ID
  Future<void> addShoes(Shoes shoes) async {
    try {
      CollectionReference shoesCollection = getShoesCollection();
      DocumentReference docRef = await shoesCollection.add(shoes.toMap());
      // Assign Firestore generated ID to Shoes item
      shoes.id = docRef.id;
      // Also update the ID in the Firestore document
      await docRef.update({'id': shoes.id});
    } catch (e) {
      logger.e('Error adding shoes: $e');
      throw Exception('Failed to add shoes: $e');
    }
  }

  // Retrieves a list of Shoes objects from Firestore collection
  Future<List<Shoes>> getShoes({bool onlyFavorites = false}) async {
    try {
      CollectionReference shoesCollection = getShoesCollection();
      QuerySnapshot querySnapshot = await shoesCollection.get();
      return querySnapshot.docs
          .map((doc) =>
              Shoes.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      logger.e('Error getting shoes: $e');
      throw Exception('Failed to get shoes: $e');
    }
  }

  // Updates an existing Shoes object in Firestore collection
  Future<void> updateShoes(Shoes shoes) async {
    try {
      CollectionReference shoesCollection = getShoesCollection();
      // Using the shoe ID to get the reference to the corresponding document
      DocumentReference docRef = shoesCollection.doc(shoes.id);
      // Document update using shoe data converted to map
      await docRef.update(shoes.toMap());
    } catch (e) {
      logger.e('Error updating shoes: $e');
      throw Exception('Failed to update shoes: $e');
    }
  }

  // Deletes a Shoes object from Firestore collection by its ID
  Future<void> deleteShoes(String id) async {
    try {
      CollectionReference shoesCollection = getShoesCollection();
      await shoesCollection.doc(id).delete();
    } catch (e) {
      logger.e('Error deleting shoes: $e');
      throw Exception('Failed to delete shoes: $e');
    }
  }

  // This function retrieves a list of shoes asynchronously and returns the total count of shoes in the list.
  Future<int> getTotalShoesCount() async {
    List<Shoes> shoesList = await getShoes();
    return shoesList.length;
  }

  // This function retrieves a list of shoes asynchronously and returns a map containing the count of shoes for each color.
  Future<Map<String, int>> getShoesCountByColor() async {
    List<Shoes> shoesList = await getShoes();
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
    List<Shoes> shoesList = await getShoes();
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
    List<Shoes> shoesList = await getShoes();
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
    List<Shoes> shoesList = await getShoes();
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
}
