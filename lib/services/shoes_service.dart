import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:shox/models/shoes_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class ShoesService {
  final Logger _logger = Logger();
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  firebase_auth.User? get currentUser => _auth.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SupabaseClient _client = Supabase.instance.client;

  // Function that adds a new Shoes to Firestore
  Future<String> addShoes(ShoesModel shoes) async {
    try {
      if (currentUser == null) {
        throw "User not logged in";
      }

      DocumentReference docRef = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('shoes')
          .add(shoes.toFirestore());

      _logger.i("Shoes added successfully with ID: ${docRef.id}");
      return docRef.id;
    } catch (e) {
      _logger.e("Error adding the Shoes: $e");
      rethrow;
    }
  }

  // Function that confirm saving a Shoes
  Future<void> confirmAddShoes(ShoesModel shoes) async {
    try {
      if (currentUser == null) {
        throw "User not logged in";
      }
      if (shoes.id == null) {
        throw "ID missing Shoes";
      }

      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('shoes')
          .doc(shoes.id)
          .update(shoes.toFirestore());

      await historyEvents('Added', shoes.id!, shoes.imageUrl);
      _logger.i("Shoes with ID ${shoes.id} successfully added");
    } catch (e) {
      _logger.e("Error updating the Shoes: $e");
      rethrow;
    }
  }

  // Function that updates an existing Shoes
  Future<void> updateShoes(ShoesModel shoes) async {
    try {
      if (currentUser == null) {
        throw "User not logged in";
      }
      if (shoes.id == null) {
        throw "ID missing Shoes";
      }

      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('shoes')
          .doc(shoes.id)
          .update(shoes.toFirestore());

      await historyEvents('Updated', shoes.id!, shoes.imageUrl);
      _logger.i("Shoes with ID ${shoes.id} successfully updated");
    } catch (e) {
      _logger.e("Error updating the Shoes: $e");
      rethrow;
    }
  }

  // Function that deletes an Shoes
  Future<void> deleteShoes(String shoesId) async {
    try {
      if (currentUser == null) {
        throw "User not logged in";
      }

      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('shoes')
          .doc(shoesId)
          .delete();

      await historyEvents('Deleted', shoesId, shoesId);
      _logger.i("Shoes with ID $shoesId successfully deleted");
    } catch (e) {
      _logger.e("Error in deleting the Shoes: $e");
      rethrow;
    }
  }

  // Function that get Shoes collection reference for current user
  CollectionReference getShoesCollection() {
    return _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('shoes');
  }

  // Function that retrieves a list of ShoeModel objects from Firestore collection
  Future<List<ShoesModel>> getShoes({bool onlyFavorites = false}) async {
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

  // Function that gets shoes
  Stream<List<ShoesModel>> getShoesList(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('shoes')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ShoesModel.fromFirestore(doc.id, doc.data()))
          .toList();
    });
  }

  // Function that gets an shoes based on its ID using Stream
  Stream<ShoesModel> getShoesStreamById(String userId) {
    try {
      return _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('shoes')
          .doc(userId)
          .snapshots(includeMetadataChanges: false)
          .map((docSnapshot) {
        if (!docSnapshot.exists) {
          throw Exception("Shoes not found");
        }
        return ShoesModel.fromFirestore(
          docSnapshot.id,
          docSnapshot.data() as Map<String, dynamic>,
        );
      });
    } catch (e) {
      throw Exception('Error in shoes recovery: $e');
    }
  }

  // Function that adds an entry to the user's history in Firestore.
  Future<void> historyEvents(
      String operationType, String shoesId, String? imageUrl) async {
    try {
      if (currentUser == null) {
        throw Exception('User ID is null');
      }

      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('history')
          .add({
        'operationType': operationType,
        'shoesId': shoesId,
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      _logger.e('Error adding history entry: $e');
      throw Exception('Failed to add history entry: $e');
    }
  }

  // Function to update shoes status as favorite
  Future<void> toggleFavoriteStatus(String shoesId, bool isFavorite) async {
    try {
      if (currentUser == null) {
        throw "User not logged in";
      }

      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('shoes')
          .doc(shoesId)
          .update({'isFavorite': isFavorite});

      _logger.i("Favorite state of the shoes $shoesId successfully updated");
    } catch (e) {
      _logger.e("Error updating shoes favorite status: $e");
    }
  }

  // Function to add an image to Supabase under the shoe ID folder
  Future<String> addShoesImageSupabase(
      String userId, String shoesId, File imageFile) async {
    var uuid = const Uuid();
    String uniqueId = uuid.v4();
    String fileExtension = extension(imageFile.path);
    final path = '$userId/shoes/$shoesId/$uniqueId$fileExtension';

    await _client.storage.from('images').upload(path, imageFile);

    return path;
  }

  // Function to delete an image from Supabase
  Future<void> deleteShoesImageSupabase(
      String userId, String shoesId, String fileName) async {
    final path = '$userId/shoes/$shoesId/$fileName';
    _logger.i('Deleting image from Supabase with path: $path');

    try {
      await _client.storage.from('images').remove([path]);
      _logger.i("Image successfully deleted from Supabase");
    } catch (e) {
      _logger.e("Error in deleting image from Supabase: $e");
    }
  }

  // Function to get public url from Supabase
  String getShoesImageUrlSupabase(
      String userId, String shoesId, String fileName) {
    return _client.storage
        .from('images')
        .getPublicUrl('$userId/shoes/$shoesId/$fileName');
  }
}
