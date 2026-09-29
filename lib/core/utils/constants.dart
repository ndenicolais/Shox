class AppConstants {
  static final Uri uriMail = Uri(
    scheme: 'mailto',
    path: 'ndn21dev@gmail.com',
  );
  static final Uri uriGithubProfile =
      Uri.parse('https://ndenicolais.github.io/');
  static final Uri uriGithubLink =
      Uri.parse('https://github.com/ndenicolais/Shox/');
  static final Uri uriGithubDocumentation =
      Uri.parse('https://github.com/ndenicolais/Shox/blob/master/README.md');
  static final Uri uriPrivacyPolicy = Uri.parse(
      "https://www.freeprivacypolicy.com/live/95cdedf9-518b-416e-a016-b6dbc404463c");

  // SharedPreferences keys
  static const String prefsRememberMe = 'remember_me';
  static const String prefsUserId = 'user_id';
  static const String prefsLastSeenChangelogVersion =
      'last_seen_changelog_version';
}
