import 'package:flutter/material.dart';

/// Цвета бренда и интерфейса приложения в стиле Tailwind Green
class AppColors {
  // Брендовые зелёные оттенки
  static const Color green50 = Color(0xFFE8F5E9);
  static const Color green100 = Color(0xFFC8E6C9);
  static const Color green200 = Color(0xFFA5D6A7);
  static const Color green300 = Color(0xFF81C784);
  static const Color green400 = Color(0xFF66BB6A);
  static const Color green500 = Color(0xFF4CAF50); // Основной зелёный
  static const Color green600 = Color(0xFF43A047);
  static const Color green700 = Color(0xFF388E3C);
  static const Color green800 = Color(0xFF2E7D32);
  static const Color green900 = Color(0xFF1B5E20); // Самый тёмный

  // Основные цвета бренда
  static const Color primary = green500; // Основной зелёный
  static const Color secondary = green300; // Мягкий салатовый акцент

  // Светлая тема
  static const Color backgroundLight = green50;
  static const Color surfaceLight = Color(0xFFFFFFFF); // Белая карточка
  static const Color textPrimaryLight = green900;
  static const Color textSecondaryLight = green600;

  // Тёмная тема
  static const Color backgroundDark = green900;
  static const Color surfaceDark = Color(0xFF1B1B1B); // Очень тёмная поверхность
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = green200;

  // Стеклоэффекты
  static const Color glassLight = Colors.white70;
  static const Color glassDark = Colors.black54;

  // Статусы
  static const Color error = Colors.redAccent;
  static const Color success = Color(0xFF00E676); // Лаймовый успех
  static const Color warning = Colors.orangeAccent;
}



