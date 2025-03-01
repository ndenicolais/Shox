import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:shox/models/shoes_model.dart';

class DatabaseService {
  final Logger _logger = Logger();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function that get Shoes collection reference for current user
  CollectionReference getShoesCollection() {
    return _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('shoes');
  }

  // Function that retrieves a list of ShoeModel objects from Firestore collection
  Future<List<ShoesModel>> getShoes() async {
    try {
      CollectionReference shoesCollection = getShoesCollection();
      QuerySnapshot querySnapshot = await shoesCollection.get();
      return querySnapshot.docs
          .map((doc) => ShoesModel.fromFirestore(
              doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _logger.e('Error getting shoes: $e');
      throw Exception('Failed to get shoes: $e');
    }
  }

  // This function retrieves a list of shoes asynchronously and returns the total count of shoes in the list.
  Future<int> getTotalShoesCount() async {
    List<ShoesModel> shoesList = await getShoes();
    return shoesList.length;
  }

  // This function retrieves a list of shoes asynchronously and returns a map containing the count of shoes for each color.
  Future<Map<String, int>> getShoesCountByColor() async {
    List<ShoesModel> shoesList = await getShoes();
    Map<String, int> colorCounts = {};

    for (var shoes in shoesList) {
      String colorHex = shoes.colorPrimary.value.toRadixString(16);
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
    List<ShoesModel> shoesList = await getShoes();
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
    List<ShoesModel> shoesList = await getShoes();
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
    List<ShoesModel> shoesList = await getShoes();
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

  // This function retrieves the current user's data from Firebase Auth and Firestore.
  Future<Map<String, dynamic>> getCurrentUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    String userName = 'User';
    String userEmail = user.email ?? 'Email';
    String userId = user.uid;

    if (user.providerData.isNotEmpty &&
        user.providerData[0].providerId == 'google.com') {
      String? googleUserName = user.displayName;
      if (googleUserName != null) {
        List<String> nameParts = googleUserName.split(" ");
        userName = nameParts.isNotEmpty ? nameParts[0] : 'User';
      }
    } else {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (docSnapshot.exists) {
        final userData = docSnapshot.data();
        userName = userData?['userName'] ?? 'User';
      }
    }

    return {
      'userId': userId,
      'name': userName,
      'email': userEmail,
    };
  }

  // This function retrieves the account creation date of the current user if the provided user ID matches the logged-in user.
  Future<DateTime> getUserCreationDate(String userId) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    if (user.uid == userId) {
      DateTime creationDate = user.metadata.creationTime!;
      return creationDate;
    } else {
      throw Exception('User ID mismatch');
    }
  }
}
