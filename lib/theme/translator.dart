// lib/theme/translator.dart
import '../i18n/translations.dart';

/// Текущий язык приложения ('en' или 'ru')
String currentLanguage = 'ru';

/// Получить список доступных языков
List<String> get supportedLanguages => translations.keys.toList();

/// Перевод текста по ключу
String t(String key) {
  return translations[currentLanguage]?[key] ?? key;
}

/// Установить язык ('en' или 'ru')
void setLanguage(String langCode) {
  if (supportedLanguages.contains(langCode)) {
    currentLanguage = langCode;
  }
}

/// Проверить текущий язык
bool isRussian() => currentLanguage == 'ru';
bool isEnglish() => currentLanguage == 'en';






