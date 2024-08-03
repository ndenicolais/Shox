class ShoesLanguages {
  static const Map<String, Map<String, String>> categoryTranslations = {
    'en': {
      'Trainers': 'Trainers',
      'Classic': 'Classic',
      'Work': 'Work',
      'Sport': 'Sport',
      'Other': 'Other'
    },
    'it': {
      'Trainers': 'Scarpe da ginnastica',
      'Classic': 'Classico',
      'Work': 'Lavoro',
      'Sport': 'Sport',
      'Other': 'Altro'
    },
    'es': {
      'Trainers': 'Zapatillas',
      'Classic': 'Clásico',
      'Work': 'Trabajo',
      'Sport': 'Deporte',
      'Other': 'Otro'
    }
  };

  static const Map<String, Map<String, String>> typeTranslations = {
    'en': {
      'Sneakers': 'Sneakers',
      'Heels': 'Heels',
      'Flat Sandals': 'Flat Sandals',
      'Heeled Sandals': 'Heeled Sandals',
      'Boots': 'Boots',
      'Hogan': 'Hogan',
      'Other': 'Other'
    },
    'it': {
      'Sneakers': 'Sneakers',
      'Heels': 'Tacchi',
      'Flat Sandals': 'Sandali piatti',
      'Heeled Sandals': 'Sandali con tacco',
      'Boots': 'Stivali',
      'Hogan': 'Hogan',
      'Other': 'Altro'
    },
    'es': {
      'Sneakers': 'Zapatillas',
      'Heels': 'Tacones',
      'Flat Sandals': 'Sandalias planas',
      'Heeled Sandals': 'Sandalias con tacón',
      'Boots': 'Botas',
      'Hogan': 'Hogan',
      'Other': 'Otro'
    }
  };

  static String translateCategory(String category, String languageCode) {
    return categoryTranslations[languageCode]?[category] ?? category;
  }

  static String translateType(String type, String languageCode) {
    return typeTranslations[languageCode]?[type] ?? type;
  }
}
