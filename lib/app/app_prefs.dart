// ignore_for_file: constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../presentation/resources/langauge_manager.dart';

const String PREFS_KEY_LANG = "PREFS_KEY_LANG";
const String ONBOARDING_SCREEN_VIEWED = "ONBOARDING_SCREEN_VIEWED";
const String IS_USER_LOGGED_IN = "IS_USER_LOGGED_IN";

class AppPreferences {
  final SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);

  Future<String> getAppLanguage() async {
    String? language = _sharedPreferences.getString(PREFS_KEY_LANG);
    if (language != null && language.isNotEmpty) {
      return language;
    } else {
      // return default lang
      return LanguageType.ENGLISH.getLanguageValue();
    }
  }

  Future<void> changeAppLanguage() async {
    String currentLang = await getAppLanguage();

    if (currentLang == LanguageType.ARABIC.getLanguageValue()) {
      // set ENGLISH
      _sharedPreferences.setString(
          PREFS_KEY_LANG, LanguageType.ENGLISH.getLanguageValue());
    } else {
      // set ARABIC
      _sharedPreferences.setString(
          PREFS_KEY_LANG, LanguageType.ARABIC.getLanguageValue());
    }
  }

  Future<Locale> getLocal() async {
    String currentLang = await getAppLanguage();

    if (currentLang == LanguageType.ARABIC.getLanguageValue()) {
      return arabicLocale;
    } else {
       return englishLocale;
      
    }
  }
  // on boarding

  Future<void> setOnBoardingScreenViewed() async {
    _sharedPreferences.setBool(ONBOARDING_SCREEN_VIEWED, true);
  }

  Future<bool> isOnBoardingScreenViewed() async {
    return _sharedPreferences.getBool(ONBOARDING_SCREEN_VIEWED) ?? false;
  }

  //login

  Future<void> setUserLoggedIn() async {
    _sharedPreferences.setBool(IS_USER_LOGGED_IN, true);
  }

  Future<bool> isUserLoggedIn() async {
    return _sharedPreferences.getBool(IS_USER_LOGGED_IN) ?? false;
  }

  Future<void> logout() async {
    _sharedPreferences.remove(IS_USER_LOGGED_IN);
  }
}
