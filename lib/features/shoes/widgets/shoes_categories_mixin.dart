import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shox/core/utils/shoes_text_translations.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';
import 'package:shox/features/users/controller/user_controller.dart';

/// Shared state for the screens that show category/type/season options:
/// the option lists depend both on the user's gender and on the active locale.
///
/// Mix it into a [State] and call [loadUserGender] from `initState` and
/// [refreshTranslations] from `didChangeDependencies`.
mixin ShoesCategoriesMixin<T extends StatefulWidget> on State<T> {
  final UserController userController = Get.find<UserController>();

  String? userGender;
  Map<String, List<String>> categoryToTypes = {};
  Map<String, String> translatedCategoryOptions = {};
  Map<String, String> translatedTypeOptions = {};
  Map<String, String> translatedSeasonOptions = {};
  String languageCode = 'en';

  /// Loads the user's gender and narrows the available categories to it.
  Future<void> loadUserGender(String? uid) async {
    if (uid == null) return;

    final userModel = await userController.getUserDetails(uid);
    if (!mounted || userModel == null) return;

    setState(() {
      userGender = userModel.gender;
      categoryToTypes = ShoesModel.getCategoryToTypesByGender(userGender);
      _updateTranslatedCategories();
    });
  }

  /// Re-reads the locale and rebuilds every translated option list.
  void refreshTranslations() {
    languageCode = Localizations.localeOf(context).languageCode;
    translatedTypeOptions =
        ShoesTextTranslations.typeTranslations[languageCode] ?? {};
    translatedSeasonOptions =
        ShoesTextTranslations.seasonTranslations[languageCode] ?? {};
    _updateTranslatedCategories();
  }

  void _updateTranslatedCategories() {
    translatedCategoryOptions = ShoesTextTranslations.categoryOptionsFor(
      languageCode: languageCode,
      categoryToTypes: categoryToTypes,
    );
  }
}
