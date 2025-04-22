// lib/services/menu_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sushi_app/models/menu_item.dart';
import 'api_constants.dart';
import 'http_helper.dart';
import 'package:sushi_app/utils/log_helper.dart';

class MenuService {
  /// Получить все блюда без категорий
  static Future<List<MenuItem>> getMenuItems() async {
    final url = '$baseUrl/menu';
    logInfo('📥 [GET MENU ITEMS] GET $url');

    final response = await http.get(Uri.parse(url));

    logInfo('✅ Status: ${response.statusCode}');
    if (response.statusCode != 200) {
      logError('❌ Response Body: ${utf8.decode(response.bodyBytes)}');
    }

    return handleResponseList<MenuItem>(
      response,
      (data) => MenuItem.fromJson(data),
      errorMessage: 'Ошибка загрузки меню',
    );
  }

  /// Получить блюда с привязкой к категориям
  static Future<List<MenuItem>> getMenuWithCategory() async {
    final url = '$baseUrl/menu/with-category';
    logInfo('📥 [GET MENU WITH CATEGORY] GET $url');

    final response = await http.get(Uri.parse(url));

    logInfo('✅ Status: ${response.statusCode}');
    if (response.statusCode != 200) {
      logError('❌ Response Body: ${utf8.decode(response.bodyBytes)}');
    }

    return handleResponseList<MenuItem>(
      response,
      (data) => MenuItem.fromJson(data),
      errorMessage: 'Ошибка загрузки меню с категориями',
    );
  }

  /// Получить опубликованные блюда с категориями (для профиля пользователя)
  static Future<List<MenuItem>> getPublishedMenuWithCategory(String token) async {
    final url = '$baseUrl/published-with-category';
    final headers = authorizedHeaders(token);

    logInfo('📥 [GET PUBLISHED MENU WITH CATEGORY] GET $url');
    logDebug('📨 Headers: $headers');

    final response = await http.get(Uri.parse(url), headers: headers);

    logInfo('✅ Status: ${response.statusCode}');
    if (response.statusCode != 200) {
      logError('❌ Response Body: ${utf8.decode(response.bodyBytes)}');
    }

    return handleResponseList<MenuItem>(
      response,
      (data) => MenuItem.fromJson(data),
      errorMessage: 'Ошибка загрузки опубликованных блюд с категориями',
    );
  }

  /// Создание блюда
  static Future<void> createMenuItem(MenuItem item, String token) async {
    final url = '$baseUrl/menu';
    final headers = authorizedHeaders(token);
    final body = jsonEncode(item.toJson(forUpdate: false));

    logInfo('📤 [CREATE MENU ITEM] POST $url');
    logDebug('📨 Headers: $headers');
    logDebug('📨 Body: $body');

    final response = await http.post(Uri.parse(url), headers: headers, body: body);

    logInfo('✅ Status: ${response.statusCode}');
    if (response.statusCode != 201) {
      logError('❌ Response Body: ${utf8.decode(response.bodyBytes)}');
    }

    handleEmptyResponse(
      response,
      successCode: 201,
      errorMessage: 'Ошибка создания блюда',
    );
  }

  /// Обновление блюда
  static Future<void> updateMenuItem(String id, MenuItem item, String token) async {
    final url = '$baseUrl/menu/$id';
    final headers = authorizedHeaders(token);
    final body = jsonEncode(item.toJson(forUpdate: true));

    logInfo('🛠️ [UPDATE MENU ITEM] PUT $url');
    logDebug('📨 Headers: $headers');
    logDebug('📨 Body: $body');

    final response = await http.put(Uri.parse(url), headers: headers, body: body);

    logInfo('✅ Status: ${response.statusCode}');
    if (response.statusCode != 200) {
      logError('❌ Response Body: ${utf8.decode(response.bodyBytes)}');
    }

    handleEmptyResponse(
      response,
      errorMessage: 'Ошибка обновления блюда',
    );
  }

  /// Удаление блюда
  static Future<void> deleteMenuItem(String id, String token) async {
    final url = '$baseUrl/menu/$id';
    final headers = authOnlyHeaders(token);

    logInfo('🗑️ [DELETE MENU ITEM] DELETE $url');
    logDebug('📨 Headers: $headers');

    final response = await http.delete(Uri.parse(url), headers: headers);

    logInfo('✅ Status: ${response.statusCode}');
    if (response.statusCode != 200) {
      logError('❌ Response Body: ${utf8.decode(response.bodyBytes)}');
    }

    handleEmptyResponse(
      response,
      errorMessage: 'Ошибка удаления блюда',
    );
  }

  /// Публикация / снятие публикации блюда
  static Future<void> publishMenuItem(String id, String token) async {
    final url = '$baseUrl/menu/$id/publish';
    final headers = authorizedHeaders(token);

    logInfo('🔄 [PUBLISH MENU ITEM] POST $url');
    logDebug('📨 Headers: $headers');

    final response = await http.post(Uri.parse(url), headers: headers);

    logInfo('✅ Status: ${response.statusCode}');
    if (response.statusCode != 200) {
      logError('❌ Response Body: ${utf8.decode(response.bodyBytes)}');
    }

    handleEmptyResponse(
      response,
      errorMessage: 'Ошибка публикации блюда',
    );
  }

  /// Получить все опубликованные блюда
  static Future<List<MenuItem>> getPublishedMenuItems(String token) async {
    final url = '$baseUrl/menu/published';
    final headers = authorizedHeaders(token);

    logInfo('📥 [GET PUBLISHED MENU ITEMS] GET $url');
    logDebug('📨 Headers: $headers');

    final response = await http.get(Uri.parse(url), headers: headers);

    logInfo('✅ Status: ${response.statusCode}');
    if (response.statusCode != 200) {
      logError('❌ Response Body: ${utf8.decode(response.bodyBytes)}');
    }

    return handleResponseList<MenuItem>(
      response,
      (data) => MenuItem.fromJson(data),
      errorMessage: 'Ошибка загрузки опубликованных блюд',
    );
  }
}




