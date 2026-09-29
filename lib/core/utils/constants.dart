class AppConstants {
  static const String developerName = 'Nicola De Nicolais';
  static const String developerEmail = 'ndn21dev@gmail.com';

  /// Date shown as "last updated" in the privacy policy (in-app and
  /// PRIVACY.md must stay in sync).
  static final DateTime privacyPolicyUpdatedAt = DateTime(2026, 9, 29);

  static final Uri uriMail = Uri(
    scheme: 'mailto',
    path: developerEmail,
  );
  static final Uri uriGithubProfile =
      Uri.parse('https://ndenicolais.github.io/');
  static final Uri uriGithubLink =
      Uri.parse('https://github.com/ndenicolais/Shox/');
  static final Uri uriGithubDocumentation =
      Uri.parse('https://github.com/ndenicolais/Shox/blob/master/README.md');
  static final Uri uriPrivacyPolicy =
      Uri.parse('https://github.com/ndenicolais/Shox/blob/master/PRIVACY.md');

  // SharedPreferences keys
  static const String prefsRememberMe = 'remember_me';
  static const String prefsUserId = 'user_id';
  static const String prefsLastSeenChangelogVersion =
      'last_seen_changelog_version';
}
