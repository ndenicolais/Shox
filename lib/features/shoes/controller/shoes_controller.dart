import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shox/features/shoes/models/brand_suggestions.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';
import 'package:shox/features/shoes/repository/shoes_repository.dart';

/// Controller per la gestione della logica di business delle scarpe
/// Coordina le operazioni tra UI e Repository
class ShoesController extends GetxController {
  final Logger _logger = Logger();
  final ShoesRepository _repository;
  final firebase_auth.FirebaseAuth _auth;

  /// Dependencies default to the real instances; tests can pass fakes.
  ShoesController({
    ShoesRepository? repository,
    firebase_auth.FirebaseAuth? auth,
  })  : _repository = repository ?? ShoesRepository(),
        _auth = auth ?? firebase_auth.FirebaseAuth.instance;

  firebase_auth.User? get currentUser => _auth.currentUser;

  // ========== SHOES CRUD OPERATIONS ==========

  /// Aggiunge una nuova scarpa con la sua immagine
  /// L'immagine viene caricata prima di creare il documento: se l'upload
  /// fallisce non resta una scarpa senza foto, se la scrittura fallisce
  /// l'immagine appena caricata viene rimossa
  Future<void> addShoes(ShoesModel shoes, File imageFile) async {
    try {
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final String shoesId = _repository.newShoesId();
      final String imageUrl = await _repository.uploadImage(
        userId: currentUser!.uid,
        shoesId: shoesId,
        imageFile: imageFile,
      );

      try {
        await _repository.addShoes(
          shoes.copyWith(
            id: shoesId,
            imageUrl: imageUrl,
            dateUpdated: DateTime.now(),
          ),
        );
      } catch (_) {
        await _deleteImageQuietly(imageUrl);
        rethrow;
      }

      _logger.i("Shoes added successfully with image");
    } catch (e) {
      _logger.e("Error in addShoes: $e");
      rethrow;
    }
  }

  /// Aggiorna una scarpa esistente
  /// Se viene fornita una nuova immagine, la carica e aggiorna l'URL
  /// Le immagini rimosse vengono eliminate solo dopo che il documento è stato
  /// aggiornato, così un errore non lascia la scarpa senza foto
  Future<void> updateShoes(
    ShoesModel shoes, {
    File? newImage,
    List<String>? removedImages,
  }) async {
    try {
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      if (shoes.id == null || shoes.id!.isEmpty) {
        throw Exception('Shoes ID is required for update');
      }

      final bool hasRemovedImages =
          removedImages != null && removedImages.isNotEmpty;
      String finalImageUrl = hasRemovedImages ? '' : shoes.imageUrl;

      String? uploadedUrl;
      if (newImage != null) {
        uploadedUrl = await _repository.uploadImage(
          userId: currentUser!.uid,
          shoesId: shoes.id!,
          imageFile: newImage,
        );
        finalImageUrl = uploadedUrl;
      }

      try {
        await _repository.updateShoes(
          shoes.copyWith(imageUrl: finalImageUrl, dateUpdated: DateTime.now()),
        );
      } catch (_) {
        if (uploadedUrl != null) await _deleteImageQuietly(uploadedUrl);
        rethrow;
      }

      if (hasRemovedImages) {
        for (final String imageUrl in removedImages) {
          await _deleteImageQuietly(imageUrl);
        }
      }

      _logger.i("Shoes updated successfully");
    } catch (e) {
      _logger.e("Error in updateShoes: $e");
      rethrow;
    }
  }

  /// Elimina una scarpa e la sua immagine
  Future<void> deleteShoes(ShoesModel shoes) async {
    try {
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      if (shoes.id == null || shoes.id!.isEmpty) {
        throw Exception('Shoes ID is required for deletion');
      }

      // Prima il documento: un'immagine orfana su Storage è invisibile,
      // un documento che punta a un'immagine cancellata no
      await _repository.deleteShoes(shoes.id!);

      if (shoes.imageUrl.isNotEmpty) {
        await _deleteImageQuietly(shoes.imageUrl);
      }

      _logger.i("Shoes deleted successfully with image");
    } catch (e) {
      _logger.e("Error in deleteShoes: $e");
      rethrow;
    }
  }

  /// Pulizia best-effort: un'immagine non eliminata non deve far fallire
  /// un'operazione già riuscita su Firestore
  Future<void> _deleteImageQuietly(String imageUrl) async {
    try {
      await _repository.deleteImage(imageUrl);
    } catch (e) {
      _logger.w("Could not delete image $imageUrl: $e");
    }
  }

  /// Ottiene la lista di tutte le scarpe dell'utente come Stream
  Stream<List<ShoesModel>> getShoesList() {
    return _repository.getShoesList();
  }

  /// Brands already used by the user, for the brand field autocomplete.
  /// Returns no suggestions on failure: they are only a typing shortcut.
  Future<BrandSuggestions> getBrandSuggestions() async {
    try {
      return BrandSuggestions.fromShoes(await _repository.getAllShoes());
    } catch (e) {
      _logger.w("Error loading brand suggestions: $e");
      return const BrandSuggestions([]);
    }
  }

  /// Ottiene una scarpa specifica per ID come Stream
  Stream<ShoesModel> getShoesById(String shoesId) {
    return _repository.getShoesById(shoesId);
  }

  /// Cambia lo stato preferito di una scarpa
  Future<void> toggleFavoriteStatus(String shoesId, bool isFavorite) async {
    try {
      await _repository.toggleFavoriteStatus(shoesId, isFavorite);
      _logger.i("Favorite status toggled successfully");
    } catch (e) {
      _logger.e("Error toggling favorite status: $e");
      rethrow;
    }
  }
}
