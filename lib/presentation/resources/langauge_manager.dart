import 'package:flutter/cupertino.dart';

enum LanguageType { ENGLISH, ARABIC }

const String arabic = "ar";
const String english = "en";

const String assetsLangPath = "assets/lang";


const Locale arabicLocale = Locale("ar", 'SA');
const Locale englishLocale = Locale("en", 'US');

extension LanguageTypeExtension on LanguageType {
  String getLanguageValue() {
    switch (this) {
      case LanguageType.ENGLISH:
        return english;
      case LanguageType.ARABIC:
        return arabic;
    }
  }
}
