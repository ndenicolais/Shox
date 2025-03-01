import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:path/path.dart' as path;
import 'package:shox/models/shoes_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class ShoesService {
  final Logger _logger = Logger();
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  firebase_auth.User? get currentUser => _auth.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SupabaseClient _client = Supabase.instance.client;

  // Function that get Shoes collection reference for current user
  CollectionReference getShoesCollection() {
    return _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('shoes');
  }

  // Function that adds a new Shoes to Firestore
  Future<String> addShoes(ShoesModel shoes) async {
    try {
      CollectionReference shoesCollection = getShoesCollection();
      DocumentReference docRef = await shoesCollection.add(shoes.toFirestore());
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
      CollectionReference shoesCollection = getShoesCollection();
      await shoesCollection.doc(shoes.id).update(shoes.toFirestore());
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
      CollectionReference shoesCollection = getShoesCollection();
      await shoesCollection.doc(shoes.id).update(shoes.toFirestore());
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
      CollectionReference shoesCollection = getShoesCollection();
      await shoesCollection.doc(shoesId).delete();
      await historyEvents('Deleted', shoesId, shoesId);
      _logger.i("Shoes with ID $shoesId successfully deleted");
    } catch (e) {
      _logger.e("Error in deleting the Shoes: $e");
      rethrow;
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
    String operationType,
    String shoesId,
    String? imageUrl,
  ) async {
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
    String userId,
    String shoesId,
    File imageFile,
  ) async {
    var uuid = const Uuid();
    String uniqueId = uuid.v4();
    String fileExtension = extension(imageFile.path);
    final path = '$userId/shoes/$shoesId/$uniqueId$fileExtension';

    await _client.storage.from('images').upload(path, imageFile);

    return path;
  }

  // Function to delete an image from Supabase
  Future<void> deleteShoesImageSupabase(
    String userId,
    String shoesId,
    String fileName,
  ) async {
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
    String userId,
    String shoesId,
    String fileName,
  ) {
    return _client.storage
        .from('images')
        .getPublicUrl('$userId/shoes/$shoesId/$fileName');
  }

  // Converts Timestamp objects in the map to ISO 8601 string representations
  Map<String, dynamic> _convertTimestamps(Map<String, dynamic> data) {
    data.forEach((key, value) {
      if (value is Timestamp) {
        data[key] = value.toDate().toIso8601String();
      }
    });
    return data;
  }

  // Export all shoes to JSON
  Future<String> exportCodesToJson() async {
    try {
      CollectionReference shoesCollection = getShoesCollection();
      QuerySnapshot querySnapshot = await shoesCollection.get();
      List<Map<String, dynamic>> shoesList = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return _convertTimestamps(data);
      }).toList();
      String jsonShoes = jsonEncode(shoesList);
      _logger.i('Shoes exported successfully.');
      return jsonShoes;
    } catch (e) {
      _logger.e('Error exporting shoes to JSON: $e');
      throw Exception('Failed to export shoes to JSON: $e');
    }
  }

  // Converts string representations of dates in the map to Timestamp objects
  Map<String, dynamic> _convertStringsToTimestamps(Map<String, dynamic> data) {
    data.forEach((key, value) {
      if (key == 'dateAdded' || key == 'dateUpdated') {
        data[key] = Timestamp.fromDate(DateTime.parse(value));
      }
    });
    return data;
  }

  // Import shoes from JSON
  Future<void> importCodesFromJson(String jsonCodes, String userId) async {
    try {
      List<dynamic> shoesList = jsonDecode(jsonCodes);
      for (var shoesMap in shoesList) {
        Map<String, dynamic> shoesData = shoesMap as Map<String, dynamic>;
        shoesData = _convertStringsToTimestamps(shoesData);

        ShoesModel shoes = ShoesModel.fromFirestore('', shoesData);
        String shoesId = await addShoes(shoes);
        String? imageUrl = shoesData['imageUrl'];

        if (imageUrl != null && imageUrl.isNotEmpty) {
          Uri imageUri = Uri.parse(imageUrl);
          http.Response response = await http.get(imageUri);
          if (response.statusCode == 200) {
            File imageFile = File(
                '${Directory.systemTemp.path}/${path.basename(imageUri.path)}');
            await imageFile.writeAsBytes(response.bodyBytes);
            String uploadedImagePath =
                await addShoesImageSupabase(userId, shoesId, imageFile);
            shoesData['imageUrl'] = uploadedImagePath;
            final fileName = uploadedImagePath.split('/').last;
            imageUrl =
                getShoesImageUrlSupabase(currentUser!.uid, shoesId, fileName);
            shoesData['imageUrl'] = imageUrl;
          } else {
            _logger.e('Failed to download image from $imageUrl');
          }
        }

        ShoesModel confirmShoes = ShoesModel.fromFirestore(shoesId, shoesData);
        await confirmAddShoes(confirmShoes);
      }
      _logger.i('Shoes imported successfully.');
    } catch (e) {
      _logger.e('Error importing shoes from JSON: $e');
      throw Exception('Failed to import shoes from JSON: $e');
    }
  }
}
