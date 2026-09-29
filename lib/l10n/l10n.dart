import 'dart:ui';

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('it'),
    const Locale('es'),
    const Locale('de'),
    const Locale('fr'),
  ];

  /// Parses a language code saved in the preferences into a supported
  /// [Locale], or null when it is missing, malformed or unsupported
  /// (the caller then falls back to the device locale).
  ///
  /// Pure function: easy to unit test.
  static Locale? parseLocale(String? languageCode) {
    if (languageCode == null) return null;

    final code = languageCode.trim();
    if (code.isEmpty) return null;

    for (final locale in all) {
      if (locale.languageCode == code) return locale;
    }
    return null;
  }
}
