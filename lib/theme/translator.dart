// lib/theme/translator.dart
import 'package:shared_preferences/shared_preferences.dart';
import '../i18n/translations.dart';

/// Ключ для хранения языка
const String _languageKey = 'app_language';

/// Текущий язык приложения
String currentLanguage = 'pl';

/// Получить список доступных языков
List<String> get supportedLanguages => translations.keys.toList();

/// Перевод текста по ключу
String t(String key) {
  return translations[currentLanguage]?[key] ?? key;
}

/// Установить язык вручную ('en', 'ru', 'pl')
Future<void> setLanguage(String langCode) async {
  if (supportedLanguages.contains(langCode)) {
    currentLanguage = langCode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, langCode);
  }
}

/// Загрузить язык из памяти при старте приложения
Future<void> loadSavedLanguage() async {
  final prefs = await SharedPreferences.getInstance();
  final savedLang = prefs.getString(_languageKey);
  if (savedLang != null && supportedLanguages.contains(savedLang)) {
    currentLanguage = savedLang;
  }
}

/// Проверка текущего языка
bool isRussian() => currentLanguage == 'ru';
bool isEnglish() => currentLanguage == 'en';
bool isPolish() => currentLanguage == 'pl';








