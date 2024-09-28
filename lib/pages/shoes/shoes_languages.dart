class ShoesLanguages {
  static const Map<String, Map<String, String>> categoryTranslations = {
    'en': {
      'Sneakers': 'Sneakers',
      'Sandals': 'Sandals',
      'Boots': 'Boots',
      'Loafers': 'Loafers',
      'Ballets': 'Ballets',
      'Other': 'Other',
    },
    'it': {
      'Sneakers': 'Sneakers',
      'Sandals': 'Sandali',
      'Boots': 'Stivali',
      'Loafers': 'Mocassini',
      'Ballets': 'Ballet',
      'Other': 'Altro',
    },
    'es': {
      'Sneakers': 'Zapatillas',
      'Sandals': 'Sandalias',
      'Boots': 'Botas',
      'Loafers': 'Mocasines',
      'Ballets': 'Bailarinas',
      'Other': 'Otro',
    },
    'fr': {
      'Sneakers': 'Baskets',
      'Sandals': 'Sandales',
      'Boots': 'Bottes',
      'Loafers': 'Mocassins',
      'Ballets': 'Ballets',
      'Other': 'Autre',
    },
    'de': {
      'Sneakers': 'Sneaker',
      'Sandals': 'Sandalen',
      'Boots': 'Stiefel',
      'Loafers': 'Loafer',
      'Ballets': 'Ballettschuhe',
      'Other': 'Sonstiges',
    },
  };

  static const Map<String, Map<String, String>> typeTranslations = {
    'en': {
      'Sport': 'Sport',
      'Casual': 'Casual',
      'Lifestyle': 'Lifestyle',
      'Running': 'Running',
      'Flat': 'Flat',
      'Heeled': 'Heeled',
      'Flip-Flops': 'Flip-Flops',
      'Dressy': 'Dressy',
      'Ankle Boots': 'Ankle Boots',
      'High Boots': 'High Boots',
      'Work Boots': 'Work Boots',
      'Knee-High': 'Knee-High',
      'Classic': 'Classic',
      'Other': 'Other',
    },
    'it': {
      'Sport': 'Sport',
      'Casual': 'Casual',
      'Lifestyle': 'Lifestyle',
      'Running': 'Running',
      'Flat': 'Piatte',
      'Heeled': 'Con tacco',
      'Flip-Flops': 'Infradito',
      'Dressy': 'Eleganti',
      'Ankle Boots': 'Stivaletti',
      'High Boots': 'Stivali alti',
      'Work Boots': 'Stivali da lavoro',
      'Knee-High': 'Fino al ginocchio',
      'Classic': 'Classico',
      'Other': 'Altro',
    },
    'es': {
      'Sport': 'Deporte',
      'Casual': 'Casual',
      'Lifestyle': 'Estilo de vida',
      'Running': 'Correr',
      'Flat': 'Plano',
      'Heeled': 'Con tacón',
      'Flip-Flops': 'Chanclas',
      'Dressy': 'Elegante',
      'Ankle Boots': 'Botines',
      'High Boots': 'Botas altas',
      'Work Boots': 'Botas de trabajo',
      'Knee-High': 'Hasta la rodilla',
      'Classic': 'Clásico',
      'Other': 'Otro',
    },
    'fr': {
      'Sport': 'Sport',
      'Casual': 'Décontracté',
      'Lifestyle': 'Style de vie',
      'Running': 'Course',
      'Flat': 'Plat',
      'Heeled': 'À talon',
      'Flip-Flops': 'Tongs',
      'Dressy': 'Habillé',
      'Ankle Boots': 'Bottines',
      'High Boots': 'Bottes hautes',
      'Work Boots': 'Bottes de travail',
      'Knee-High': 'Jusq au genou',
      'Classic': 'Classique',
      'Other': 'Autre',
    },
    'de': {
      'Sport': 'Sport',
      'Casual': 'Lässig',
      'Lifestyle': 'Lebensstil',
      'Running': 'Laufen',
      'Flat': 'Flach',
      'Heeled': 'Mit Absatz',
      'Flip-Flops': 'Flip-Flops',
      'Dressy': 'Schick',
      'Ankle Boots': 'Stiefeletten',
      'High Boots': 'Hohe Stiefel',
      'Work Boots': 'Arbeitsstiefel',
      'Knee-High': 'Knielang',
      'Classic': 'Klassisch',
      'Other': 'Sonstiges',
    },
  };

  static String translateCategory(String category, String languageCode) {
    return categoryTranslations[languageCode]?[category] ?? category;
  }

  static String translateType(String type, String languageCode) {
    return typeTranslations[languageCode]?[type] ?? type;
  }
}
