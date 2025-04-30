import 'package:flutter/material.dart';
import 'theme_constants.dart';

/// Глобальные текстовые стили без привязки к цвету
class AppTextStyles {
  static const TextStyle displayLarge = TextStyle(
    fontFamily: kFontFamilyDisplay,
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: kFontFamilyDisplay,
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: kFontFamilyBody,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: kFontFamilyBody,
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: kFontFamilyBody,
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: kFontFamilyBody,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: kFontFamilyBody,
    fontSize: 12,
    fontWeight: FontWeight.w300,
  );
}



