// lib/services/api_constants.dart

import 'package:flutter/foundation.dart';

/// Локальный сервер для разработки (на своём компьютере)
const String baseUrlLocal = 'http://localhost:8000/api';

/// Публичный сервер в интернете (на Koyeb)
const String baseUrlProduction =
    'https://sorry-kelly-fodi999-c00c247b.koyeb.app/api';

/// Автоматический выбор:
/// - Если мы на вебе и хост is "localhost" — работаем локально.
/// - Во всех остальных случаях — продакшн.
String get baseUrl {
  // проверяем только на web-платформе
  if (kIsWeb && Uri.base.host == 'localhost') {
    return baseUrlLocal;
  }
  return baseUrlProduction;
}






