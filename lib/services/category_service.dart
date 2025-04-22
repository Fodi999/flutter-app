import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import 'api_constants.dart';
import 'http_helper.dart';
import 'package:sushi_app/utils/log_helper.dart'; // ✅ логгер

class CategoryService {
  // Получить все категории
  static Future<List<Category>> getCategories(String token) async {
    final url = '$baseUrl/categories';
    final headers = authorizedHeaders(token);

    logInfo('📥 [GET CATEGORIES] GET $url');
    logDebug('📨 Headers: $headers');

    final response = await http.get(Uri.parse(url), headers: headers);

    logInfo('✅ Status: ${response.statusCode}');
    if (response.statusCode != 200) {
      logError('❌ Response Body: ${utf8.decode(response.bodyBytes)}');
    }

    return handleResponseList<Category>(
      response,
      (data) => Category.fromJson(data),
      errorMessage: 'Ошибка загрузки категорий',
    );
  }

  // Создать категорию
  static Future<Category> createCategory(String name, String token) async {
    final url = '$baseUrl/categories';
    final headers = authorizedHeaders(token);
    final body = jsonEncode({'name': name});

    logInfo('📤 [CREATE CATEGORY] POST $url');
    logDebug('📨 Headers: $headers');
    logDebug('📨 Body: $body');

    final response = await http.post(Uri.parse(url), headers: headers, body: body);

    logInfo('✅ Status: ${response.statusCode}');
    if (response.statusCode != 201) {
      logError('❌ Response Body: ${utf8.decode(response.bodyBytes)}');
    }

    return handleResponseObject<Category>(
      response,
      (data) => Category.fromJson(data),
      successCode: 201,
      errorMessage: 'Ошибка создания категории',
    );
  }

  // Обновить категорию
  static Future<void> updateCategory(String id, String name, String token) async {
    final url = '$baseUrl/categories/$id';
    final headers = authorizedHeaders(token);
    final body = jsonEncode({'name': name});

    logInfo('🛠️ [UPDATE CATEGORY] PUT $url');
    logDebug('📨 Headers: $headers');
    logDebug('📨 Body: $body');

    final response = await http.put(Uri.parse(url), headers: headers, body: body);

    logInfo('✅ Status: ${response.statusCode}');
    if (response.statusCode != 200) {
      logError('❌ Response Body: ${utf8.decode(response.bodyBytes)}');
    }

    handleEmptyResponse(response, errorMessage: 'Ошибка обновления категории');
  }

  // Удалить категорию
  static Future<void> deleteCategory(String id, String token) async {
    final url = '$baseUrl/categories/$id';
    final headers = authOnlyHeaders(token);

    logInfo('🗑️ [DELETE CATEGORY] DELETE $url');
    logDebug('📨 Headers: $headers');

    final response = await http.delete(Uri.parse(url), headers: headers);

    logInfo('✅ Status: ${response.statusCode}');
    if (response.statusCode != 200) {
      logError('❌ Response Body: ${utf8.decode(response.bodyBytes)}');
    }

    handleEmptyResponse(response, errorMessage: 'Ошибка удаления категории');
  }
}


