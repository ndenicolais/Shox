import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

/// Repository per la gestione dei dati delle scarpe
/// Gestisce tutte le operazioni CRUD su Firestore e Supabase Storage
class ShoesRepository {
  final Logger _logger = Logger();
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  firebase_auth.User? get currentUser => _auth.currentUser;

  // ========== FIRESTORE OPERATIONS ==========

  /// Ottiene il riferimento alla collection "shoes" dell'utente corrente
  CollectionReference _getShoesCollection() {
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }
    return _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('shoes');
  }

  /// Aggiunge una nuova scarpa a Firestore
  /// Restituisce l'ID del documento creato
  Future<String> addShoes(ShoesModel shoes) async {
    try {
      CollectionReference shoesCollection = _getShoesCollection();
      DocumentReference docRef = await shoesCollection.add(shoes.toFirestore());
      _logger.i("Shoes added successfully with ID: ${docRef.id}");
      return docRef.id;
    } catch (e) {
      _logger.e("Error adding shoes: $e");
      rethrow;
    }
  }

  /// Aggiorna una scarpa esistente su Firestore
  Future<void> updateShoes(ShoesModel shoes) async {
    try {
      CollectionReference shoesCollection = _getShoesCollection();
      await shoesCollection.doc(shoes.id).update(shoes.toFirestore());
      _logger.i("Shoes with ID ${shoes.id} successfully updated");
    } catch (e) {
      _logger.e("Error updating shoes: $e");
      rethrow;
    }
  }

  /// Elimina una scarpa da Firestore
  Future<void> deleteShoes(String shoesId) async {
    try {
      CollectionReference shoesCollection = _getShoesCollection();
      await shoesCollection.doc(shoesId).delete();
      _logger.i("Shoes with ID $shoesId successfully deleted");
    } catch (e) {
      _logger.e("Error deleting shoes: $e");
      rethrow;
    }
  }

  /// Ottiene la lista di tutte le scarpe dell'utente come Stream
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

  /// Ottiene una scarpa specifica per ID come Stream
  Stream<ShoesModel> getShoesById(String shoesId) {
    try {
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      return _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('shoes')
          .doc(shoesId)
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
      _logger.e("Error getting shoes by ID: $e");
      rethrow;
    }
  }

  /// Aggiorna lo stato preferito di una scarpa
  Future<void> toggleFavoriteStatus(String shoesId, bool isFavorite) async {
    try {
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('shoes')
          .doc(shoesId)
          .update({'isFavorite': isFavorite});

      _logger.i("Favorite status of shoes $shoesId successfully updated");
    } catch (e) {
      _logger.e("Error toggling favorite status: $e");
      rethrow;
    }
  }

  // ========== SUPABASE STORAGE OPERATIONS ==========

  /// Carica un'immagine su Supabase Storage
  /// Restituisce il path dell'immagine caricata
  Future<String> uploadImage({
    required String userId,
    required String shoesId,
    required File imageFile,
  }) async {
    try {
      var uuid = const Uuid();
      String uniqueId = uuid.v4();
      String fileExtension = extension(imageFile.path);
      final path = '$userId/shoes/$shoesId/$uniqueId$fileExtension';

      await _supabaseClient.storage.from('images').upload(path, imageFile);
      _logger.i("Image uploaded successfully to: $path");

      return path;
    } catch (e) {
      _logger.e("Error uploading image: $e");
      rethrow;
    }
  }

  /// Elimina un'immagine da Supabase Storage
  Future<void> deleteImage({
    required String userId,
    required String shoesId,
    required String fileName,
  }) async {
    final path = '$userId/shoes/$shoesId/$fileName';
    _logger.i('Deleting image from Supabase with path: $path');

    try {
      await _supabaseClient.storage.from('images').remove([path]);
      _logger.i("Image successfully deleted from Supabase");
    } catch (e) {
      _logger.e("Error deleting image from Supabase: $e");
      rethrow;
    }
  }

  /// Ottiene l'URL pubblico di un'immagine da Supabase
  String getImageUrl({
    required String userId,
    required String shoesId,
    required String fileName,
  }) {
    return _supabaseClient.storage
        .from('images')
        .getPublicUrl('$userId/shoes/$shoesId/$fileName');
  }

  // ========== UTILITY METHODS ==========

  /// Converte i Timestamp in stringhe ISO 8601 per l'export
  Map<String, dynamic> convertTimestampsToStrings(Map<String, dynamic> data) {
    data.forEach((key, value) {
      if (value is Timestamp) {
        data[key] = value.toDate().toIso8601String();
      }
    });
    return data;
  }

  /// Converte le stringhe ISO 8601 in Timestamp per l'import
  Map<String, dynamic> convertStringsToTimestamps(Map<String, dynamic> data) {
    data.forEach((key, value) {
      if ((key == 'createdAt' || key == 'updatedAt') && value is String) {
        data[key] = Timestamp.fromDate(DateTime.parse(value));
      }
    });
    return data;
  }

  /// Ottiene tutte le scarpe dell'utente (snapshot singolo, non stream)
  Future<List<ShoesModel>> getAllShoes() async {
    try {
      CollectionReference shoesCollection = _getShoesCollection();
      QuerySnapshot querySnapshot = await shoesCollection.get();

      return querySnapshot.docs
          .map((doc) => ShoesModel.fromFirestore(
                doc.id,
                doc.data() as Map<String, dynamic>,
              ))
          .toList();
    } catch (e) {
      _logger.e("Error getting all shoes: $e");
      rethrow;
    }
  }
}
