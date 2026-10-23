import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';
import 'package:uuid/uuid.dart';

/// Firestore and Storage access needed to back up and restore the shoes of
/// the signed-in user.
class BackupRepository {
  final Logger _logger = Logger();
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  /// Photos larger than this are skipped instead of loaded in memory.
  static const int _maxImageBytes = 20 * 1024 * 1024;

  /// Firestore batches are limited to 500 writes.
  static const int _batchLimit = 500;

  BackupRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  String get userId => _uid;

  String get _uid {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');
    return user.uid;
  }

  CollectionReference<Map<String, dynamic>> get _shoes =>
      _firestore.collection('users').doc(_uid).collection('shoes');

  Future<List<ShoesModel>> fetchShoes() async {
    final snapshot = await _shoes.get();
    return snapshot.docs
        .map((doc) => ShoesModel.fromFirestore(doc.id, doc.data()))
        .toList();
  }

  /// Downloads a photo through the Storage SDK. Only Firebase Storage URLs
  /// are accepted, so a backup file cannot make the app fetch arbitrary
  /// hosts. Null when the photo is missing or cannot be read.
  Future<Uint8List?> downloadImage(String url) async {
    final host = Uri.tryParse(url)?.host;
    if (host != 'firebasestorage.googleapis.com') {
      _logger.w('Skipping photo outside Firebase Storage: $url');
      return null;
    }
    try {
      return await _storage.refFromURL(url).getData(_maxImageBytes);
    } catch (e) {
      _logger.w('Could not download photo $url: $e');
      return null;
    }
  }

  /// A new document ID; nothing is written.
  String newShoesId() => _shoes.doc().id;

  /// Uploads [bytes] to `<uid>/shoes/<shoesId>/<uuid><extension>` and
  /// returns its download URL.
  Future<String> uploadImage({
    required String shoesId,
    required Uint8List bytes,
    required String extension,
  }) async {
    final ref = _storage.ref(
      '$_uid/shoes/$shoesId/${const Uuid().v4()}$extension',
    );
    await ref.putData(
      bytes,
      SettableMetadata(contentType: _contentType(extension)),
    );
    return ref.getDownloadURL();
  }

  /// Writes every shoe under its own [ShoesModel.id] in batches.
  Future<void> writeShoes(List<ShoesModel> shoes) async {
    for (var i = 0; i < shoes.length; i += _batchLimit) {
      final batch = _firestore.batch();
      for (final shoe in shoes.skip(i).take(_batchLimit)) {
        batch.set(_shoes.doc(shoe.id), shoe.toFirestore());
      }
      await batch.commit();
    }
  }

  Future<void> deleteShoes(List<String> ids) async {
    for (var i = 0; i < ids.length; i += _batchLimit) {
      final batch = _firestore.batch();
      for (final id in ids.skip(i).take(_batchLimit)) {
        batch.delete(_shoes.doc(id));
      }
      await batch.commit();
    }
  }

  /// Best-effort: a photo left behind in Storage is invisible to the user.
  Future<void> deleteImage(String url) async {
    try {
      await _storage.refFromURL(url).delete();
    } catch (e) {
      _logger.w('Could not delete photo $url: $e');
    }
  }

  static String _contentType(String extension) {
    switch (extension) {
      case '.png':
        return 'image/png';
      case '.webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }
}
