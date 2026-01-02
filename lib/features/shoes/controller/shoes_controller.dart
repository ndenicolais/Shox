import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;
import 'package:shox/features/shoes/models/shoes_model.dart';
import 'package:shox/features/shoes/repository/shoes_repository.dart';

/// Controller per la gestione della logica di business delle scarpe
/// Coordina le operazioni tra UI e Repository
class ShoesController {
  final Logger _logger = Logger();
  final ShoesRepository _repository = ShoesRepository();
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

  firebase_auth.User? get currentUser => _auth.currentUser;

  // ========== SHOES CRUD OPERATIONS ==========

  /// Aggiunge una nuova scarpa con la sua immagine
  Future<void> addShoes(ShoesModel shoes, File imageFile) async {
    try {
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Step 1: Aggiungi la scarpa a Firestore (senza imageUrl)
      String shoesId = await _repository.addShoes(shoes);

      // Step 2: Carica l'immagine su Supabase
      String imagePath = await _repository.uploadImage(
        userId: currentUser!.uid,
        shoesId: shoesId,
        imageFile: imageFile,
      );

      // Step 3: Ottieni l'URL pubblico dell'immagine
      final fileName = imagePath.split('/').last;
      String imageUrl = _repository.getImageUrl(
        userId: currentUser!.uid,
        shoesId: shoesId,
        fileName: fileName,
      );

      // Step 4: Aggiorna la scarpa con l'imageUrl
      final updatedShoes = ShoesModel(
        id: shoesId,
        imageUrl: imageUrl,
        colorPrimary: shoes.colorPrimary,
        colorExtra: shoes.colorExtra,
        brand: shoes.brand,
        size: shoes.size,
        category: shoes.category,
        type: shoes.type,
        season: shoes.season,
        notes: shoes.notes,
        isFavorite: shoes.isFavorite,
        dateAdded: shoes.dateAdded,
        dateUpdated: DateTime.now(),
      );

      await _repository.updateShoes(updatedShoes);

      _logger.i("Shoes added successfully with image");
    } catch (e) {
      _logger.e("Error in addShoes: $e");
      rethrow;
    }
  }

  /// Aggiorna una scarpa esistente
  /// Se viene fornita una nuova immagine, la carica e aggiorna l'URL
  /// Se ci sono immagini da rimuovere, le elimina
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

      String? finalImageUrl = shoes.imageUrl;

      // Elimina le immagini rimosse
      if (removedImages != null && removedImages.isNotEmpty) {
        for (String imageUrl in removedImages) {
          final fileName = imageUrl.split('/').last;
          await _repository.deleteImage(
            userId: currentUser!.uid,
            shoesId: shoes.id!,
            fileName: fileName,
          );
        }
        finalImageUrl = null;
      }

      // Carica la nuova immagine se presente
      if (newImage != null) {
        String imagePath = await _repository.uploadImage(
          userId: currentUser!.uid,
          shoesId: shoes.id!,
          imageFile: newImage,
        );

        final fileName = imagePath.split('/').last;
        finalImageUrl = _repository.getImageUrl(
          userId: currentUser!.uid,
          shoesId: shoes.id!,
          fileName: fileName,
        );
      }

      // Aggiorna la scarpa con il nuovo imageUrl
      final updatedShoes = ShoesModel(
        id: shoes.id,
        imageUrl: finalImageUrl ?? '',
        colorPrimary: shoes.colorPrimary,
        colorExtra: shoes.colorExtra,
        brand: shoes.brand,
        size: shoes.size,
        category: shoes.category,
        type: shoes.type,
        season: shoes.season,
        notes: shoes.notes,
        isFavorite: shoes.isFavorite,
        dateAdded: shoes.dateAdded,
        dateUpdated: DateTime.now(),
      );

      await _repository.updateShoes(updatedShoes);

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

      // Elimina l'immagine se presente
      if (shoes.imageUrl.isNotEmpty) {
        final fileName = shoes.imageUrl.split('/').last;
        await _repository.deleteImage(
          userId: currentUser!.uid,
          shoesId: shoes.id!,
          fileName: fileName,
        );
      }

      // Elimina la scarpa da Firestore
      await _repository.deleteShoes(shoes.id!);

      _logger.i("Shoes deleted successfully with image");
    } catch (e) {
      _logger.e("Error in deleteShoes: $e");
      rethrow;
    }
  }

  /// Ottiene la lista di tutte le scarpe dell'utente come Stream
  Stream<List<ShoesModel>> getShoesList(String userId) {
    return _repository.getShoesList(userId);
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

  // ========== IMPORT/EXPORT OPERATIONS ==========

  /// Esporta tutte le scarpe in formato JSON
  Future<String> exportShoesToJson() async {
    try {
      // Ottieni tutte le scarpe
      List<ShoesModel> shoesList = await _repository.getAllShoes();

      // Converti in map e poi in JSON
      List<Map<String, dynamic>> shoesMapList = shoesList.map((shoes) {
        Map<String, dynamic> data = shoes.toFirestore();
        return _repository.convertTimestampsToStrings(data);
      }).toList();

      String jsonShoes = jsonEncode(shoesMapList);
      _logger.i('Shoes exported successfully. Total: ${shoesList.length}');

      return jsonShoes;
    } catch (e) {
      _logger.e('Error exporting shoes to JSON: $e');
      throw Exception('Failed to export shoes to JSON: $e');
    }
  }

  /// Importa scarpe da JSON
  Future<void> importShoesFromJson(String jsonData,
      {Function(double)? onProgress}) async {
    try {
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      List<dynamic> shoesList = jsonDecode(jsonData);
      int totalShoes = shoesList.length;

      for (int index = 0; index < shoesList.length; index++) {
        var shoesMap = shoesList[index];
        Map<String, dynamic> shoesData = shoesMap as Map<String, dynamic>;

        // Crea il modello usando fromJson per gestire correttamente le date
        ShoesModel shoes = ShoesModel.fromJson('', shoesData);

        // Aggiungi la scarpa a Firestore
        String shoesId = await _repository.addShoes(shoes);

        // Gestisci l'immagine se presente
        String? imageUrl = shoesData['imageUrl'];
        if (imageUrl != null && imageUrl.isNotEmpty) {
          try {
            // Scarica l'immagine dall'URL
            Uri imageUri = Uri.parse(imageUrl);
            http.Response response = await http.get(imageUri);

            if (response.statusCode == 200) {
              // Salva temporaneamente l'immagine
              File imageFile = File(
                '${Directory.systemTemp.path}/${path.basename(imageUri.path)}',
              );
              await imageFile.writeAsBytes(response.bodyBytes);

              // Carica su Supabase
              String uploadedImagePath = await _repository.uploadImage(
                userId: currentUser!.uid,
                shoesId: shoesId,
                imageFile: imageFile,
              );

              // Ottieni l'URL pubblico
              final fileName = uploadedImagePath.split('/').last;
              String newImageUrl = _repository.getImageUrl(
                userId: currentUser!.uid,
                shoesId: shoesId,
                fileName: fileName,
              );

              // Aggiorna la scarpa con il nuovo URL
              shoesData['imageUrl'] = newImageUrl;
            } else {
              _logger.w('Failed to download image from $imageUrl');
              shoesData['imageUrl'] = '';
            }
          } catch (imageError) {
            _logger.e('Error processing image during import: $imageError');
            shoesData['imageUrl'] = '';
          }
        }

        // Aggiorna la scarpa con l'imageUrl corretto
        ShoesModel finalShoes = ShoesModel.fromJson(shoesId, shoesData);
        await _repository.updateShoes(finalShoes);

        // Aggiorna il progresso
        if (onProgress != null) {
          double progress = (index + 1) / totalShoes;
          onProgress(progress);
        }
      }

      _logger.i('Shoes imported successfully. Total: ${shoesList.length}');
    } catch (e) {
      _logger.e('Error importing shoes from JSON: $e');
      throw Exception('Failed to import shoes from JSON: $e');
    }
  }
}
