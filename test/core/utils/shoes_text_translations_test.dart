import 'package:flutter_test/flutter_test.dart';
import 'package:shox/core/utils/shoes_text_translations.dart';

void main() {
  group('ShoesTextTranslations.categoryOptionsFor', () {
    test('returns every category when the gender is not known yet', () {
      final options = ShoesTextTranslations.categoryOptionsFor(
        languageCode: 'en',
        categoryToTypes: const {},
      );

      expect(options, ShoesTextTranslations.categoryTranslations['en']);
    });

    test('keeps only the categories available for the gender', () {
      final options = ShoesTextTranslations.categoryOptionsFor(
        languageCode: 'en',
        categoryToTypes: const {
          'Sneakers': ['Running'],
          'Boots': ['Chelsea'],
        },
      );

      expect(options.keys, containsAll(<String>['Sneakers', 'Boots']));
      expect(options.keys, hasLength(2));
    });

    test('returns the labels of the requested language', () {
      final options = ShoesTextTranslations.categoryOptionsFor(
        languageCode: 'it',
        categoryToTypes: const {
          'Elegant': ['Oxford'],
        },
      );

      expect(options['Elegant'], 'Eleganti');
    });

    test('falls back to an empty map for an unknown language', () {
      final options = ShoesTextTranslations.categoryOptionsFor(
        languageCode: 'zz',
        categoryToTypes: const {},
      );

      expect(options, isEmpty);
    });

    test('ignores categories that have no translation', () {
      final options = ShoesTextTranslations.categoryOptionsFor(
        languageCode: 'en',
        categoryToTypes: const {
          'Sneakers': ['Running'],
          'NotACategory': ['Nope'],
        },
      );

      expect(options.keys, ['Sneakers']);
    });
  });
}
