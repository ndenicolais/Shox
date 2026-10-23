import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';

/// Repository that handles all database operations with Firestore
class DatabaseRepository {
  final Logger _logger = Logger();
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  DatabaseRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get current authenticated user
  User? get currentUser => _auth.currentUser;

  /// Get shoes collection reference for current user
  CollectionReference getShoesCollection() {
    if (currentUser == null) {
      throw Exception('User is not authenticated');
    }
    return _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('shoes');
  }

  /// Fetch all shoes for the current user
  Future<List<ShoesModel>> fetchShoes() async {
    try {
      _logger.d('Fetching shoes from Firestore...');
      CollectionReference shoesCollection = getShoesCollection();
      QuerySnapshot querySnapshot = await shoesCollection.get();

      final shoes = querySnapshot.docs
          .map(
            (doc) => ShoesModel.fromFirestore(
              doc.id,
              doc.data() as Map<String, dynamic>,
            ),
          )
          .toList();

      _logger.i('Successfully fetched ${shoes.length} shoes');
      return shoes;
    } catch (e) {
      _logger.e('Error fetching shoes: $e');
      throw Exception('Failed to fetch shoes: $e');
    }
  }

  /// Fetch current user data from Firebase Auth and Firestore
  Future<Map<String, dynamic>> fetchCurrentUserData() async {
    try {
      User? user = currentUser;

      if (user == null) {
        throw Exception('User is not logged in');
      }

      String userName = 'User';
      String userEmail = user.email ?? 'Email';
      String userId = user.uid;

      // Check if user logged in with Google
      if (user.providerData.isNotEmpty &&
          user.providerData[0].providerId == 'google.com') {
        String? googleUserName = user.displayName;
        if (googleUserName != null) {
          List<String> nameParts = googleUserName.split(" ");
          userName = nameParts.isNotEmpty ? nameParts[0] : 'User';
        }
      } else {
        // Fetch user data from Firestore
        final docSnapshot =
            await _firestore.collection('users').doc(user.uid).get();

        if (docSnapshot.exists) {
          final userData = docSnapshot.data();
          userName = userData?['userName'] ?? 'User';
        }
      }

      _logger.i('Successfully fetched user data for: $userName');
      return {'userId': userId, 'name': userName, 'email': userEmail};
    } catch (e) {
      _logger.e('Error fetching user data: $e');
      throw Exception('Failed to fetch user data: $e');
    }
  }
}
