import 'dart:async';

import 'package:flutter/material.dart';

import '../../services/app_translations/app_translations.dart';
import '../../services/app_translations/language_model.dart';
import '../../services/local_repo/local_repository.dart';
import '../../services/routing/navigation_service.dart';
import '../../services/service_locator/dependency_injection.dart';


class ChangeLanguageState {
  final List<LanguageModel> languagesList = application.supportedLanguages;

  Map<String, dynamic> languagesMap = {};

  int? currentLocale;

  init() {
    for (LanguageModel langModel in languagesList) {
      languagesMap[langModel.language!] = langModel.languageCode;
    }

    if (isEnglish()) {
      currentLocale = 0;
    } else {
      currentLocale = 1;
    }
  }

  changeLang({required int langNumber}) {
    application.onLocaleChanged!(
      Locale(languagesMap[languagesList[langNumber].language]),
    );
    sl<LocalRepo>()
        .setLanguage(languagesMap[languagesList[langNumber].language]);

    currentLocale = langNumber;

    Timer(
      const Duration(milliseconds: 30),
      () {
        var parent = sl<NavigationService>().getParentName(isParent: false);
        sl<NavigationService>().navigateToAndRemove(parent);
      },
    );
   
  }
}
