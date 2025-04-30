// lib/theme/theme_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Провайдер темы приложения, сохраняет выбор пользователя в SharedPreferences.
class ThemeProvider with ChangeNotifier {
  // 1. Поле для хранения текущего режима темы
  ThemeMode _themeMode = ThemeMode.dark;

  // 2. Конструктор — сразу после полей
  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  // 3. Геттер для доступа к текущему режиму темы
  ThemeMode get themeMode => _themeMode;

  // 4. Публичный метод для переключения темы
  Future<void> toggleTheme() async {
    _themeMode = (_themeMode == ThemeMode.dark) ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _themeMode == ThemeMode.dark);
  }

  // 5. Приватный метод для загрузки сохранённого режима темы при старте
  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? true;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}




