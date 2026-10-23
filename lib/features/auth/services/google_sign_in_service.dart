import 'package:google_sign_in/google_sign_in.dart';

/// google_sign_in 7 exposes a singleton that must be initialized exactly once
/// before any other call. On Android the server client ID is read from the
/// `default_web_client_id` resource generated from google-services.json.
class GoogleSignInService {
  static Future<void>? _initialization;

  static Future<GoogleSignIn> instance() async {
    final GoogleSignIn googleSignIn = GoogleSignIn.instance;
    try {
      await (_initialization ??= googleSignIn.initialize());
    } catch (_) {
      // Allow a later call to retry instead of caching the failure.
      _initialization = null;
      rethrow;
    }
    return googleSignIn;
  }
}
