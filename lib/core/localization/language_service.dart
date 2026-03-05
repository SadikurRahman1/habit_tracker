import 'package:flutter/material.dart';
import '../services/storage_services/st_service.dart';

class LanguageService {
  LanguageService._internal();

  static const String languageCodeKey = "language_code_key";
  static const String languageCountryCodeKey = "language_country_code_key";

  /// Save entire locale
  static Future<void> saveLocale(Locale locale) async {
    await STService().saveData(languageCodeKey, locale.languageCode);
    await STService().saveData(languageCountryCodeKey, locale.countryCode ?? '');
  }

  /// Get saved locale
  // static Locale getSavedLocale() {
  //   final code = STService().getData(languageCodeKey) ?? 'en';
  //   final country = STService().getData(languageCountryCodeKey) ?? 'US';
  //   return Locale(code, country);
  // }
  static Locale getSavedLocale() {
    final code = STService().getData(languageCodeKey) ?? 'it';
    final country = STService().getData(languageCountryCodeKey) ?? 'IT';
    return Locale(code, country);
  }

  /// Save only language code
  static Future<void> saveLanguageCode({required String langKey}) async {
    await STService().saveData(languageCodeKey, langKey);
  }

  /// Save only country code
  static Future<void> saveLanguageCountryCode({required String countryKey}) async {
    await STService().saveData(languageCountryCodeKey, countryKey);
  }

  /// Get language code
  static String? getLanguageCode() {
    return STService().getData(languageCodeKey);
  }

  /// Get country code
  static String? getLanguageCountryCode() {
    return STService().getData(languageCountryCodeKey);
  }
}
