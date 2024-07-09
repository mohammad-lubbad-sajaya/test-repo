// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../local_repo/local_repository.dart';
import '../routing/navigation_service.dart';
import '../service_locator/dependency_injection.dart';
import 'language_model.dart';

class AppTranslations {
  late Locale locale;
  static late Map<dynamic, dynamic> _localisedValues;

  static AppTranslations? of({BuildContext? context}) {
    return Localizations.of<AppTranslations>(
      context ?? sl<NavigationService>().getContext(),
      AppTranslations,
    );
  }

  static Future<AppTranslations> load(Locale locale) async {
    AppTranslations appTranslations = AppTranslations();
    String jsonContent = await rootBundle
        .loadString("assets/locale/localization_${locale.languageCode}.json");
    _localisedValues = json.decode(jsonContent);
    return appTranslations;
  }

  get currentLanguage => locale.languageCode;

  String text(String key) {
    return _localisedValues[key] ?? key;
  }
}

class AppTranslationsDelegate extends LocalizationsDelegate<AppTranslations> {
  final Locale? locale;

  const AppTranslationsDelegate({required this.locale});

  @override
  bool isSupported(Locale locale) {
    return application.supportedLanguages
        .contains(LanguageModel(languageCode: locale.languageCode));
  }

  @override
  Future<AppTranslations> load(Locale locale) {
    return AppTranslations.load(this.locale ?? locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppTranslations> old) {
    return true;
  }

  String? getLanguageCode() {
    return locale?.languageCode ?? Platform.localeName.split('_')[0];
  }
}

class Application {
  static final Application _application = Application._internal();

  factory Application() {
    return _application;
  }

  Application._internal();

  final List<LanguageModel> supportedLanguages = [
    LanguageModel(language: "English", languageCode: 'en'),
    LanguageModel(language: "Arabic", languageCode: 'ar'),
  ];

  Map<String, dynamic>? _languagesMap;

  Map<String, dynamic>? getLanguagesMap() {
    if (_languagesMap != null) return _languagesMap!;

    _languagesMap = {};

    for (LanguageModel language in supportedLanguages) {
      _languagesMap![language.language!] = language.languageCode;
    }

    return _languagesMap;
  }

  Iterable<Locale> supportedLocales() {
    return supportedLanguages
        .map<Locale>((language) => Locale(language.languageCode, ""));
  }

  LocaleChangeCallback? onLocaleChanged;
}

Application application = Application();

typedef LocaleChangeCallback = void Function(Locale locale);

bool isEnglish() {
  if (sl<LocalRepo>().getLanguage() == null) {
    return Platform.localeName.split('_')[0] == 'en';
  }

  return sl<LocalRepo>().getLanguage() == 'en';
}
