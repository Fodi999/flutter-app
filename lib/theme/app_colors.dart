import 'package:flutter/material.dart';

class AppColors {
  // Основные цвета бренда
  static const Color primary = Color(0xFF4CAF50);        // зелёный
  static const Color secondary = Color(0xFFFFC107);      // жёлтый

  // Фон и поверхность
  static const Color backgroundLight = Color(0xFFF7FAF7);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color cardBackground = Colors.white70; // ✅ Добавлено
  
  // Текст
  static const Color textPrimaryLight = Colors.black87;
  static const Color textSecondaryLight = Color(0xFF616161);
  static const Color textPrimaryDark = Colors.white;
  static const Color textSecondaryDark = Color(0xFFBDBDBD);

  // Прозрачность и эффекты
  static const Color glassLight = Colors.white70;
  static const Color glassDark = Colors.black54;

  // Ошибки / состояния
  static const Color error = Colors.redAccent;
  static const Color success = Colors.green;
  static const Color warning = Colors.orange;
}
