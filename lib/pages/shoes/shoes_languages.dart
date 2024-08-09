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
    },
    'fr': {
      'Trainers': 'Chaussures de sport',
      'Classic': 'Classique',
      'Work': 'Travail',
      'Sport': 'Sport',
      'Other': 'Autre'
    },
    'de': {
      'Trainers': 'Turnschuhe',
      'Classic': 'Klassisch',
      'Work': 'Arbeit',
      'Sport': 'Sport',
      'Other': 'Sonstiges'
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
    },
    'fr': {
      'Sneakers': 'Baskets',
      'Heels': 'Talons',
      'Flat Sandals': 'Sandales plates',
      'Heeled Sandals': 'Sandales à talons',
      'Boots': 'Bottes',
      'Hogan': 'Hogan',
      'Other': 'Autre'
    },
    'de': {
      'Sneakers': 'Sneaker',
      'Heels': 'Absätze',
      'Flat Sandals': 'Flache Sandalen',
      'Heeled Sandals': 'Sandalen mit Absatz',
      'Boots': 'Stiefel',
      'Hogan': 'Hogan',
      'Other': 'Sonstiges'
    }
  };

  static String translateCategory(String category, String languageCode) {
    return categoryTranslations[languageCode]?[category] ?? category;
  }

  static String translateType(String type, String languageCode) {
    return typeTranslations[languageCode]?[type] ?? type;
  }
}
