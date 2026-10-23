import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shox/core/utils/app_exceptions.dart';
import 'package:shox/features/auth/services/auth_service.dart';
import 'package:shox/features/auth/services/google_sign_in_service.dart';
import 'package:shox/features/users/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class UserRepository {
  final Logger _logger = Logger();
  firebase_auth.User? get currentUser => _auth.currentUser;
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final AuthService _authService = AuthService();

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
      await _authService.clearSession();
    } catch (e) {
      throw Exception('Error during logout.');
    }
  }

  Future<void> googleSignOut() async {
    await (await GoogleSignInService.instance()).signOut();
    await firebase_auth.FirebaseAuth.instance.signOut();
  }

  /// Firebase refuses `user.delete()` without a recent sign-in, so the user
  /// signs in again before anything is deleted: otherwise the data could be
  /// gone while the account survives. [password] is required for
  /// email/password accounts; Google accounts go through the Google picker.
  ///
  /// Throws [AuthException] `invalid_credentials` or `reauth_cancelled`.
  Future<void> reauthenticate({String? password}) async {
    final firebase_auth.User? user = currentUser;
    if (user == null) throw Exception("No user logged in.");

    try {
      final firebase_auth.AuthCredential credential;
      if (user.providerData.any((info) => info.providerId == 'google.com')) {
        final googleUser =
            await (await GoogleSignInService.instance()).authenticate();
        credential = firebase_auth.GoogleAuthProvider.credential(
          idToken: googleUser.authentication.idToken,
        );
      } else {
        if (password == null || password.isEmpty || user.email == null) {
          throw const AuthException('invalid_credentials');
        }
        credential = firebase_auth.EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );
      }
      await user.reauthenticateWithCredential(credential);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw const AuthException('reauth_cancelled');
      }
      throw AuthException('reauth_failed', e.code.name);
    } on firebase_auth.FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'wrong-password':
        case 'invalid-credential':
        case 'user-mismatch':
          throw const AuthException('invalid_credentials');
        default:
          throw AuthException('reauth_failed', e.code);
      }
    }
  }

  /// Call [reauthenticate] first.
  Future<void> deleteAccount() async {
    firebase_auth.User? user = _auth.currentUser;
    if (user == null) throw Exception("No user logged in.");

    try {
      await deleteEntireUserCollection(user.uid);
      await deleteUserFolder(user.uid);
      await user.delete();
      await _auth.signOut();
      await (await GoogleSignInService.instance()).signOut();
      await _authService.clearSession();
    } catch (e) {
      throw Exception("Error while deleting: $e");
    }
  }

  /// Firestore batches are limited to 500 writes.
  static const int _batchLimit = 500;

  Future<void> deleteEntireUserCollection(String userId) async {
    try {
      final userDoc = _firestore.collection('users').doc(userId);
      for (final String collection in ['shoes', 'history']) {
        final snapshot = await userDoc.collection(collection).get();
        final docs = snapshot.docs;
        for (int i = 0; i < docs.length; i += _batchLimit) {
          final batch = _firestore.batch();
          for (final doc in docs.skip(i).take(_batchLimit)) {
            batch.delete(doc.reference);
          }
          await batch.commit();
        }
      }
      await userDoc.delete();
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
          'All files successfully deleted from Firebase Storage folder: $userId/$folder',
        );
      } catch (e) {
        _logger.e('Error in deleting user folder from Firebase Storage: $e');
      }
    }
  }
}
