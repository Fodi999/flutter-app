import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/inventory_item.dart';
import 'api_constants.dart';
import 'http_helper.dart';
import 'package:sushi_app/utils/log_helper.dart'; // ✅ логгер

class InventoryService {
  // 📦 Получить все продукты со склада
  static Future<List<InventoryItem>> getInventoryItems(String token) async {
    final url = '$baseUrl/menu/inventory';
    final headers = authorizedHeaders(token); // ✅ добавлен заголовок

    logInfo('📥 [GET INVENTORY] GET $url');
    logDebug('📨 Headers: $headers');

    final response = await http.get(Uri.parse(url), headers: headers);

    logInfo('✅ Status: ${response.statusCode}');
    logDebug('📦 Response: ${utf8.decode(response.bodyBytes)}');

    if (response.statusCode == 200) {
      return handleResponseList<InventoryItem>(
        response,
        (data) => InventoryItem.fromJson(data),
        errorMessage: 'Ошибка загрузки склада',
      );
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('Ошибка загрузки склада: ${utf8.decode(response.bodyBytes)}');
    }
  }

  // ➕ Добавить продукт
  static Future<void> createInventoryItem(InventoryItem item, String token) async {
    final url = '$baseUrl/menu/inventory';
    final headers = authorizedHeaders(token);
    final body = jsonEncode(item.toJson());

    logInfo('📤 [CREATE INVENTORY] POST $url');
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
      errorMessage: 'Ошибка добавления продукта',
    );
  }

  // ✏️ Обновить продукт
  static Future<void> updateInventoryItem(String id, InventoryItem item, String token) async {
    final url = '$baseUrl/menu/inventory/$id';
    final headers = authorizedHeaders(token);
    final body = jsonEncode(item.toJson());

    logInfo('🛠️ [UPDATE INVENTORY] PUT $url');
    logDebug('📨 Headers: $headers');
    logDebug('📨 Body: $body');

    final response = await http.put(Uri.parse(url), headers: headers, body: body);

    logInfo('✅ Status: ${response.statusCode}');
    if (response.statusCode != 200) {
      logError('❌ Response Body: ${utf8.decode(response.bodyBytes)}');
    }

    handleEmptyResponse(
      response,
      errorMessage: 'Ошибка обновления продукта',
    );
  }

  // 🗑 Удалить продукт
  static Future<void> deleteInventoryItem(String id, String token) async {
    final url = '$baseUrl/menu/inventory/$id';
    final headers = authOnlyHeaders(token);

    logInfo('🗑️ [DELETE INVENTORY] DELETE $url');
    logDebug('📨 Headers: $headers');

    final response = await http.delete(Uri.parse(url), headers: headers);

    logInfo('✅ Status: ${response.statusCode}');
    if (response.statusCode != 200) {
      logError('❌ Response Body: ${utf8.decode(response.bodyBytes)}');
    }

    handleEmptyResponse(
      response,
      errorMessage: 'Ошибка удаления продукта',
    );
  }
}





