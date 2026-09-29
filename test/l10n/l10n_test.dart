import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:shox/l10n/l10n.dart';

void main() {
  group('L10n.parseLocale', () {
    test('returns null when nothing was saved', () {
      expect(L10n.parseLocale(null), isNull);
    });

    test('returns null for an empty or blank code', () {
      expect(L10n.parseLocale(''), isNull);
      expect(L10n.parseLocale('   '), isNull);
    });

    test('returns null for an unsupported language', () {
      expect(L10n.parseLocale('pt'), isNull);
    });

    test('resolves every supported language', () {
      for (final locale in L10n.all) {
        expect(L10n.parseLocale(locale.languageCode), locale);
      }
    });

    test('ignores surrounding whitespace', () {
      expect(L10n.parseLocale('  it  '), const Locale('it'));
    });
  });
}
