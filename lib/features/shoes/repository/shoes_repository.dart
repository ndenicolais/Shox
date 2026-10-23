import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

/// Repository per la gestione dei dati delle scarpe
/// Gestisce tutte le operazioni CRUD su Firestore e Firebase Storage
class ShoesRepository {
  final Logger _logger = Logger();
  final firebase_auth.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  /// Dependencies default to the real instances; tests can pass fakes.
  ShoesRepository({
    firebase_auth.FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _auth = auth ?? firebase_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  firebase_auth.User? get currentUser => _auth.currentUser;

  // ========== FIRESTORE OPERATIONS ==========

  /// Ottiene il riferimento alla collection "shoes" dell'utente corrente
  CollectionReference<Map<String, dynamic>> _getShoesCollection() {
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }
    return _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('shoes');
  }

  /// Genera un ID per un nuovo documento senza scrivere nulla, così
  /// l'immagine può essere caricata prima di creare il documento
  String newShoesId() => _getShoesCollection().doc().id;

  /// Aggiunge una nuova scarpa a Firestore, usando [ShoesModel.id] se presente
  /// Restituisce l'ID del documento creato
  Future<String> addShoes(ShoesModel shoes) async {
    try {
      final shoesCollection = _getShoesCollection();
      String? id = shoes.id;
      if (id == null || id.isEmpty) {
        id = (await shoesCollection.add(shoes.toFirestore())).id;
      } else {
        await shoesCollection.doc(id).set(shoes.toFirestore());
      }
      _logger.i("Shoes added successfully with ID: $id");
      return id;
    } catch (e) {
      _logger.e("Error adding shoes: $e");
      rethrow;
    }
  }

  /// Aggiorna una scarpa esistente su Firestore
  Future<void> updateShoes(ShoesModel shoes) async {
    try {
      await _getShoesCollection().doc(shoes.id).update(shoes.toFirestore());
      _logger.i("Shoes with ID ${shoes.id} successfully updated");
    } catch (e) {
      _logger.e("Error updating shoes: $e");
      rethrow;
    }
  }

  /// Elimina una scarpa da Firestore
  Future<void> deleteShoes(String shoesId) async {
    try {
      await _getShoesCollection().doc(shoesId).delete();
      _logger.i("Shoes with ID $shoesId successfully deleted");
    } catch (e) {
      _logger.e("Error deleting shoes: $e");
      rethrow;
    }
  }

  /// Ottiene la lista di tutte le scarpe dell'utente corrente come Stream
  Stream<List<ShoesModel>> getShoesList() {
    return _getShoesCollection().snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => ShoesModel.fromFirestore(doc.id, doc.data()))
              .toList(),
        );
  }

  /// Ottiene una scarpa specifica per ID come Stream
  Stream<ShoesModel> getShoesById(String shoesId) {
    try {
      return _getShoesCollection()
          .doc(shoesId)
          .snapshots(includeMetadataChanges: false)
          .map((docSnapshot) {
        final data = docSnapshot.data();
        if (data == null) {
          throw Exception("Shoes not found");
        }
        return ShoesModel.fromFirestore(docSnapshot.id, data);
      });
    } catch (e) {
      _logger.e("Error getting shoes by ID: $e");
      rethrow;
    }
  }

  /// Aggiorna lo stato preferito di una scarpa
  Future<void> toggleFavoriteStatus(String shoesId, bool isFavorite) async {
    try {
      await _getShoesCollection()
          .doc(shoesId)
          .update({'isFavorite': isFavorite});

      _logger.i("Favorite status of shoes $shoesId successfully updated");
    } catch (e) {
      _logger.e("Error toggling favorite status: $e");
      rethrow;
    }
  }

  // ========== FIREBASE STORAGE OPERATIONS ==========

  /// Carica un'immagine su Firebase Storage
  /// Restituisce il download URL dell'immagine caricata
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

      final ref = _storage.ref(path);
      await ref.putFile(imageFile);
      final downloadUrl = await ref.getDownloadURL();
      _logger.i("Image uploaded successfully to: $path");

      return downloadUrl;
    } catch (e) {
      _logger.e("Error uploading image: $e");
      rethrow;
    }
  }

  /// Elimina un'immagine da Firebase Storage tramite il suo download URL
  Future<void> deleteImage(String imageUrl) async {
    _logger.i('Deleting image from Firebase Storage: $imageUrl');

    try {
      await _storage.refFromURL(imageUrl).delete();
      _logger.i("Image successfully deleted from Firebase Storage");
    } catch (e) {
      _logger.e("Error deleting image from Firebase Storage: $e");
      rethrow;
    }
  }

  /// Ottiene tutte le scarpe dell'utente (snapshot singolo, non stream)
  Future<List<ShoesModel>> getAllShoes() async {
    try {
      final snapshot = await _getShoesCollection().get();
      return snapshot.docs
          .map((doc) => ShoesModel.fromFirestore(doc.id, doc.data()))
          .toList();
    } catch (e) {
      _logger.e("Error getting all shoes: $e");
      rethrow;
    }
  }
}
