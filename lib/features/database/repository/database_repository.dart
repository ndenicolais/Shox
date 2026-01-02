import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';
import 'package:shox/features/shoes/controller/shoes_controller.dart';

/// Repository that handles all database operations with Firestore
class DatabaseRepository {
  final Logger _logger = Logger();
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final ShoesController _shoesController;

  DatabaseRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    ShoesController? shoesController,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _shoesController = shoesController ?? ShoesController();

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
          .map((doc) => ShoesModel.fromFirestore(
              doc.id, doc.data() as Map<String, dynamic>))
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
      return {
        'userId': userId,
        'name': userName,
        'email': userEmail,
      };
    } catch (e) {
      _logger.e('Error fetching user data: $e');
      throw Exception('Failed to fetch user data: $e');
    }
  }

  /// Get user account creation date
  Future<DateTime> fetchUserCreationDate(String userId) async {
    try {
      final user = currentUser;

      if (user == null) {
        throw Exception('User is not logged in');
      }

      if (user.uid != userId) {
        throw Exception('User ID mismatch');
      }

      DateTime creationDate = user.metadata.creationTime!;
      _logger.i('User creation date: $creationDate');
      return creationDate;
    } catch (e) {
      _logger.e('Error fetching user creation date: $e');
      throw Exception('Failed to fetch user creation date: $e');
    }
  }

  // ==================== EXPORT/IMPORT OPERATIONS ====================

  /// Export shoes database to JSON file
  /// Returns the file path of the exported file
  Future<String> exportToJson() async {
    try {
      _logger.i('Starting JSON export...');

      final jsonCodes = await _shoesController.exportShoesToJson();
      final directory = Directory('/storage/emulated/0/Download');
      final now = DateTime.now();
      final dateFormat = DateFormat('yyyyMMdd_HHmmss');
      final formattedDate = dateFormat.format(now);
      final filePath = '${directory.path}/shox_db_$formattedDate.json';
      final file = File(filePath);

      await file.writeAsString(jsonCodes);
      _logger.i('JSON exported successfully to: $filePath');

      return filePath;
    } catch (e) {
      _logger.e('Error exporting to JSON: $e');
      throw Exception('Failed to export database: $e');
    }
  }

  /// Import shoes database from JSON file
  Future<void> importFromJson(String userId,
      {Function(double)? onProgress}) async {
    try {
      _logger.i('Starting JSON import...');

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null) {
        _logger.w('Import cancelled by user');
        throw Exception('Import cancelled');
      }

      File file = File(result.files.single.path!);
      String jsonCodes = await file.readAsString();

      await _shoesController.importShoesFromJson(jsonCodes,
          onProgress: onProgress);
      _logger.i('JSON imported successfully');
    } catch (e) {
      _logger.e('Error importing from JSON: $e');
      throw Exception('Failed to import database: $e');
    }
  }

  /// Share a file using the system share dialog
  Future<void> shareFile(String filePath) async {
    try {
      _logger.i('Sharing file: $filePath');
      final xFile = XFile(filePath);
      await Share.shareXFiles([xFile]);
      _logger.i('File shared successfully');
    } catch (e) {
      _logger.e('Error sharing file: $e');
      throw Exception('Failed to share file: $e');
    }
  }

  /// Check if export directory is accessible
  Future<bool> isExportDirectoryAccessible() async {
    try {
      final directory = Directory('/storage/emulated/0/Download');
      return await directory.exists();
    } catch (e) {
      _logger.e('Error checking export directory: $e');
      return false;
    }
  }

  /// Get the export directory path
  String getExportDirectoryPath() {
    return '/storage/emulated/0/Download';
  }
}
