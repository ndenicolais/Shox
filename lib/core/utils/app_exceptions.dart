/// Custom exception used for authentication-related errors.
///
/// Using a typed exception with a stable [code] avoids matching on
/// exception message strings (e.g. `e.toString().contains("...")`),
/// which is fragile and easy to break during refactors.
class AuthException implements Exception {
  final String code;
  final String? message;

  const AuthException(this.code, [this.message]);

  @override
  String toString() =>
      'AuthException($code)${message != null ? ': $message' : ''}';
}
