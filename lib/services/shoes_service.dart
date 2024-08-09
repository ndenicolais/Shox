import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shox/models/shoes_model.dart';

class ShoesService {
  var logger = Logger();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Get the UID of the current user
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  // Get Shoes collection reference for current user
  CollectionReference getShoesCollection() {
    String? userId = getCurrentUserId();
    return _firestore.collection('users').doc(userId).collection('shoes');
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

  // Add a Shoes object to Firestore and upload the image to Storage.
  Future<void> addShoes(Shoes shoes, XFile? imageFile) async {
    try {
      // Add Shoes object to Firestore collection
      CollectionReference shoesCollection = getShoesCollection();
      DocumentReference docRef = await shoesCollection.add(shoes.toMap());

      // Assign Firestore generated ID to Shoes item
      shoes.id = docRef.id;

      // Check if imageFile is not null and upload it to Firebase Storage
      if (imageFile != null) {
        // Get current user's ID
        String? userId = getCurrentUserId();

        // Create a Reference to the file in Firebase Storage with a unique name based on the shoes id
        String fileName = '${shoes.id}.png';
        Reference ref = _storage.ref().child('shoes_images/$userId/$fileName');

        // Upload file to Firebase Storage
        await ref.putFile(File(imageFile.path));

        // Get the download URL for the image
        String imageUrl = await ref.getDownloadURL();

        // Update the Shoes object with the imageUrl field
        shoes.imageUrl = imageUrl;

        // Update the document in Firestore with the imageUrl field
        await docRef.update({'imageUrl': shoes.imageUrl});
      }

      // Also update the ID in the Firestore document
      await docRef.update({'id': shoes.id});
    } catch (e) {
      logger.e('Error adding shoes: $e');
      throw Exception('Failed to add shoes: $e');
    }
  }

  // Update a Shoes object to Firestore and also the image to Storage.
  Future<void> updateShoes(
      String shoesId, Shoes updatedShoes, XFile? newImageFile) async {
    try {
      // Reference to the Shoes document in Firestore
      CollectionReference shoesCollection = getShoesCollection();
      DocumentReference docRef = shoesCollection.doc(shoesId);

      // Check if a new image file is provided
      if (newImageFile != null) {
        // Get current user's ID
        String? userId = getCurrentUserId();

        // Delete existing image if it exists
        // Construct the reference to the old image
        String oldFileName = '$shoesId.png';
        Reference oldRef =
            _storage.ref().child('shoes_images/$userId/$oldFileName');

        // Delete the old image
        await oldRef.delete();

        // Upload new image to Firebase Storage
        // Use existing shoes ID for filename
        String newFileName = '$shoesId.png';
        Reference newRef =
            _storage.ref().child('shoes_images/$userId/$newFileName');
        await newRef.putFile(File(newImageFile.path));

        // Get the download URL for the new image
        String imageUrl = await newRef.getDownloadURL();

        // Update the Shoes object with the new imageUrl field
        updatedShoes.imageUrl = imageUrl;

        // Update the document in Firestore with the new imageUrl field
        await docRef.update({'imageUrl': updatedShoes.imageUrl});
        await docRef.update(updatedShoes.toMap());
      } else {
        // If no new image is provided, just update other fields in Firestore
        await docRef.update(updatedShoes.toMap());
      }
    } catch (e) {
      logger.e('Error updating shoes: $e');
      throw Exception('Failed to update shoes: $e');
    }
  }

  // Deletes a Shoes object from Firestore and also the image from Storage
  Future<void> deleteShoes(String id, String imageUrl) async {
    try {
      // Delete shoes from Firestore
      CollectionReference shoesCollection = getShoesCollection();
      await shoesCollection.doc(id).delete();
      logger.i('Shoes deleted successfully.');

      // Delete image from Storage
      Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
      logger.i('Image deleted successfully.');
    } catch (e) {
      logger.e('Error deleting shoes and image: $e');
      throw Exception('Failed to delete shoes and image: $e');
    }
  }
}
