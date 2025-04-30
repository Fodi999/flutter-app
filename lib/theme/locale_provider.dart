// lib/theme/locale_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

/// Провайдер, который держит в себе текущий код локали и умеет переключать язык.
class LocaleProvider with ChangeNotifier {
  String _localeCode = 'en';

  /// Текущий код локали: 'en' или 'ru'
  String get localeCode => _localeCode;

  /// Устанавливает [code] как новую локаль и уведомляет слушателей.
  /// [context] нужен для того, чтобы changeLocale нашёл нужный LocalizationDelegate.
  void setLocale(BuildContext context, String code) {
    // Меняем локаль в flutter_translate
    changeLocale(context, code);
    // Сохраняем у себя
    _localeCode = code;
    notifyListeners();
  }

  /// Сбрасывает локаль на английский.
  void clearLocale(BuildContext context) => setLocale(context, 'en');

  /// Переключает между 'en' и 'ru'.
  void toggleLocale(BuildContext context) {
    final newCode = _localeCode == 'en' ? 'ru' : 'en';
    setLocale(context, newCode);
  }
}




