import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lynou/localization/app_translations.dart';
import 'package:lynou/localization/application.dart';

class AppTranslationsDelegate extends LocalizationsDelegate<AppTranslations> {
  final Locale newLocale;
  bool isTest = false;

  AppTranslationsDelegate({this.newLocale, this.isTest});

  @override
  bool isSupported(Locale locale) {
    return application.supportedLanguagesCodes.contains(locale.languageCode);
  }

  @override
  Future<AppTranslations> load(Locale locale) {
    return AppTranslations.load(newLocale ?? locale, isTest);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppTranslations> old) {
    return true;
  }
}
