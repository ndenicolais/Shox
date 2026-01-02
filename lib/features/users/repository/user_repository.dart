import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shox/features/users/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class UserRepository {
  final Logger _logger = Logger();
  firebase_auth.User? get currentUser => _auth.currentUser;
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<String> loadUserName() async {
    final user = _auth.currentUser;
    if (user == null) return 'User';
    try {
      final userDetails = await getUserDetails(user.uid);
      final name = userDetails?.userName ?? 'User';
      final firstName = name.split(' ').first;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', firstName);
      return firstName;
    } catch (e) {
      return 'User';
    }
  }

  Future<UserModel?> getUserDetails(String uid) async {
    final userDoc = await _firestore.collection('users').doc(uid).get();
    if (userDoc.exists) {
      return UserModel.fromFirestore(userDoc.data()!);
    } else {
      throw Exception("User not founded on Firestore.");
    }
  }

  /// Check if current user is using email/password authentication
  bool isEmailPasswordUser() {
    return currentUser != null &&
        currentUser!.providerData.isNotEmpty &&
        currentUser!.providerData[0].providerId == 'password';
  }

  /// Get user profile image URL
  /// Returns Google profile image URL if available, otherwise Supabase image URL
  Future<String?> getUserProfileImageUrl(String userId) async {
    final user = currentUser;
    if (user != null &&
        user.providerData.isNotEmpty &&
        user.providerData[0].providerId == 'google.com') {
      String? photoUrl = user.photoURL;
      if (photoUrl != null) {
        // Increase image quality for Google photos
        return photoUrl.replaceAll('s96', 's1024');
      }
    }

    // Get image from Firestore/Supabase
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;
        UserModel userModel = UserModel.fromFirestore(data);
        if (userModel.userImage != null) {
          final imageUrl = userModel.userImage!;
          final fileName = imageUrl.split('/').last;
          return getUserImageUrlSupabase(userId, fileName);
        }
      }
    } catch (e) {
      _logger.e('Error loading profile image: $e');
    }

    return null;
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      await googleSignOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('remember_me');
      await prefs.remove('user_id');
    } catch (e) {
      throw Exception('Error during logout.');
    }
  }

  Future<void> googleSignOut() async {
    await _googleSignIn.signOut();
    await firebase_auth.FirebaseAuth.instance.signOut();
  }

  Future<void> deleteAccount() async {
    firebase_auth.User? user = _auth.currentUser;
    if (user != null) {
      if (user.providerData
          .any((userInfo) => userInfo.providerId == 'google.com')) {
        await _googleSignIn.signOut();
      }
      try {
        await deleteEntireUserCollection(user.uid);
        await deleteUserFolderSupabase(user.uid);
        await user.delete();
        await _auth.signOut();
        await _googleSignIn.signOut();
      } catch (e) {
        throw Exception("Error while deleting: $e");
      }
    } else {
      throw Exception("No user logged in.");
    }
  }

  Future<void> deleteEntireUserCollection(String userId) async {
    try {
      List<String> subCollections = ['shoes', 'history'];
      for (String collection in subCollections) {
        QuerySnapshot subCollectionSnapshot = await _firestore
            .collection('users')
            .doc(userId)
            .collection(collection)
            .get();
        for (DocumentSnapshot doc in subCollectionSnapshot.docs) {
          await doc.reference.delete();
        }
        await _firestore.collection('users').doc(userId).delete();
      }
    } catch (e) {
      throw Exception("Error during user document deletion: $e");
    }
  }

  // ==================== SUPABASE STORAGE OPERATIONS ====================

  /// Add user image to Supabase Storage
  /// Returns the storage path of the uploaded image
  Future<String> addUserImageSupabase(String userId, File imageFile) async {
    var uuid = const Uuid();
    String uniqueId = uuid.v4();
    String fileExtension = extension(imageFile.path);
    final path = '$userId/users/$uniqueId$fileExtension';

    await _supabaseClient.storage.from('images').upload(path, imageFile);
    _logger.i('User image uploaded to Supabase: $path');

    return path;
  }

  /// Delete user image from Supabase Storage
  Future<void> deleteUserImageSupabase(String userId, String fileName) async {
    final path = '$userId/users/$fileName';
    _logger.i('Deleting image from Supabase with path: $path');

    try {
      await _supabaseClient.storage.from('images').remove([path]);
      _logger.i("Image successfully deleted from Supabase");
    } catch (e) {
      _logger.e("Error in deleting image from Supabase: $e");
      rethrow;
    }
  }

  /// Get public URL for user image from Supabase Storage
  String getUserImageUrlSupabase(String userId, String fileName) {
    return _supabaseClient.storage
        .from('images')
        .getPublicUrl('$userId/users/$fileName');
  }

  /// Delete all user folders in Supabase Storage
  /// Removes both 'users' and 'shoes' folders for the given userId
  Future<void> deleteUserFolderSupabase(String userId) async {
    final folders = ['users', 'shoes'];

    for (final folder in folders) {
      final pathPrefix = '$userId/$folder/';
      _logger
          .i('Deleting all files in Supabase folder with prefix: $pathPrefix');

      try {
        // List all files in the folder
        final result =
            await _supabaseClient.storage.from('images').list(path: pathPrefix);

        if (result.isEmpty) {
          _logger.i("No files found in Supabase folder: $pathPrefix");
          continue;
        }

        // Handle nested files in the 'shoes' folder
        if (folder == 'shoes') {
          for (final directory in result) {
            final nestedPathPrefix = '$pathPrefix${directory.name}/';
            final nestedResult = await _supabaseClient.storage
                .from('images')
                .list(path: nestedPathPrefix);

            if (nestedResult.isEmpty) {
              _logger.i(
                  "No files found in nested Supabase folder: $nestedPathPrefix");
              continue;
            }

            final nestedFilePaths = nestedResult
                .map((file) => '$nestedPathPrefix${file.name}')
                .toList();
            await _supabaseClient.storage
                .from('images')
                .remove(nestedFilePaths);
            _logger.i(
                "All files successfully deleted from nested Supabase folder: $nestedPathPrefix");
          }
        } else {
          // Handle files in the 'users' folder
          final filePaths =
              result.map((file) => '$pathPrefix${file.name}').toList();
          await _supabaseClient.storage.from('images').remove(filePaths);
          _logger.i(
              "All files successfully deleted from Supabase folder: $pathPrefix");
        }
      } catch (e) {
        _logger.e("Error in deleting user folder from Supabase: $e");
        rethrow;
      }
    }
  }
}
