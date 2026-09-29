import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shox/core/utils/constants.dart';
import 'package:shox/features/users/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class UserRepository {
  final Logger _logger = Logger();
  firebase_auth.User? get currentUser => _auth.currentUser;
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseStorage _storage = FirebaseStorage.instance;

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
  /// Returns Google profile image URL if available, otherwise Firebase Storage image URL
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

    // Get image from Firestore
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;
        UserModel userModel = UserModel.fromFirestore(data);
        if (userModel.userImage != null && userModel.userImage!.isNotEmpty) {
          return userModel.userImage;
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
      await prefs.remove(AppConstants.prefsRememberMe);
      await prefs.remove(AppConstants.prefsUserId);
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
        await deleteUserFolder(user.uid);
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

  // ==================== FIREBASE STORAGE OPERATIONS ====================

  /// Add user image to Firebase Storage
  /// Returns the download URL of the uploaded image
  Future<String> addUserImage(String userId, File imageFile) async {
    var uuid = const Uuid();
    String uniqueId = uuid.v4();
    String fileExtension = extension(imageFile.path);
    final path = '$userId/users/$uniqueId$fileExtension';

    final ref = _storage.ref(path);
    await ref.putFile(imageFile);
    final downloadUrl = await ref.getDownloadURL();
    _logger.i('User image uploaded to Firebase Storage: $path');

    return downloadUrl;
  }

  /// Delete user image from Firebase Storage via its download URL
  Future<void> deleteUserImage(String imageUrl) async {
    _logger.i('Deleting image from Firebase Storage: $imageUrl');

    try {
      await _storage.refFromURL(imageUrl).delete();
      _logger.i("Image successfully deleted from Firebase Storage");
    } catch (e) {
      _logger.e("Error in deleting image from Firebase Storage: $e");
      rethrow;
    }
  }

  /// Delete all user folders in Firebase Storage
  /// Removes both 'users' and 'shoes' folders for the given userId
  Future<void> deleteUserFolder(String userId) async {
    final folders = ['users', 'shoes'];

    for (final folder in folders) {
      final ref = _storage.ref('$userId/$folder');
      _logger
          .i('Deleting all files in Firebase Storage folder: $userId/$folder');

      try {
        final result = await ref.listAll();

        for (final item in result.items) {
          await item.delete();
        }

        for (final prefix in result.prefixes) {
          final nestedResult = await prefix.listAll();
          for (final item in nestedResult.items) {
            await item.delete();
          }
          _logger.i('All files deleted from nested folder: ${prefix.fullPath}');
        }

        _logger.i(
            'All files successfully deleted from Firebase Storage folder: $userId/$folder');
      } catch (e) {
        _logger.e('Error in deleting user folder from Firebase Storage: $e');
      }
    }
  }
}
