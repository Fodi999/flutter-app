// lib/theme/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Провайдер темы приложения, сохраняет выбор пользователя в SharedPreferences.
class ThemeProvider with ChangeNotifier {
  /* ─── состояние ─── */
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  ThemeMode get themeMode => _themeMode;

  /// 🆕 Геттер, указывающий, активна ли тёмная тема
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /* ─── переключить тему ─── */
  Future<void> toggleTheme() async {
    _themeMode =
        (_themeMode == ThemeMode.dark) ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _themeMode == ThemeMode.dark);
  }

  /* ─── загрузить сохранённый режим ─── */
  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? true;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

/*───────────────────────────────────────────────────────────*/
/*  ГЛОБАЛЬНЫЙ Riverpod-провайдер — импортируйте его где угодно
    и пишите  ref.watch(themeProvider) / ref.read(themeProvider) */
final themeProvider =
    ChangeNotifierProvider<ThemeProvider>((ref) => ThemeProvider());






