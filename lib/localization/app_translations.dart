import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class AppTranslations {
  Locale locale;
  bool isTest = false;
  static Map<dynamic, dynamic> _localisedValues;

  AppTranslations(Locale locale) {
    this.locale = locale;
  }

  static AppTranslations of(BuildContext context) {
    return Localizations.of<AppTranslations>(context, AppTranslations);
  }

  static Future<AppTranslations> load(Locale locale, bool isTest) async {
    AppTranslations appTranslations = AppTranslations(locale);

    if (!isTest) {
      String jsonContent = await rootBundle.loadString(
          "assets/languages/localization_${locale.languageCode}.json");
      _localisedValues = json.decode(jsonContent);
    } else {
      appTranslations.isTest = true;
    }

    return appTranslations;
  }

  get currentLanguage => locale.languageCode;

  String text(String key) {
    if (isTest) {
      return key;
    } else {
      return _localisedValues[key] ?? key;
    }
  }
}
