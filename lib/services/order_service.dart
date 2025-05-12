// lib/services/order_service.dart

import 'package:sushi_app/models/order.dart';
import 'package:sushi_app/services/http_helper.dart';
import 'package:sushi_app/services/api_constants.dart';
import 'package:sushi_app/utils/log_helper.dart';

class OrderService {
  static final _baseUrl = baseUrl;

  /// 📦 Создаёт новый заказ на сервере.
  static Future<void> createOrder({
    required String token,
    required String userId,
    required String name,
    required String phone,
    required String address,
    required List<Map<String, dynamic>> items,
    String? comment,
  }) async {
    final url = '$_baseUrl/users/$userId/order';
    final body = <String, dynamic>{
      'userId': userId,
      'name': name,
      'phone': phone,
      'address': address,
      'items': items,
      if (comment != null && comment.trim().isNotEmpty)
        'comment': comment.trim(),
    };

    logInfo('📦 Создание заказа', tag: 'OrderService');
    logDebug('➡️ URL: $url', tag: 'OrderService');
    logDebug('➡️ Body: $body', tag: 'OrderService');
    logDebug('➡️ Headers: ${authorizedHeaders(token)}', tag: 'OrderService');

    final response = await postRequest(
      url,
      body,
      headers: authorizedHeaders(token),
    );

    if (response.statusCode == 201) {
      logInfo('✅ Заказ успешно создан!', tag: 'OrderService');
    } else {
      logError(
        '❌ Ошибка создания заказа: ${response.statusCode} ${response.reasonPhrase}',
        tag: 'OrderService',
      );
      logDebug('📦 Ответ: ${response.body}', tag: 'OrderService');
    }

    handleEmptyResponse(
      response,
      successCode: 201,
      errorMessage: 'Не удалось создать заказ',
    );
  }

  /// 📥 Получить список заказов пользователя.
  static Future<List<Order>> fetchOrders({
    required String token,
    required String userId,
  }) async {
    final url = '$_baseUrl/users/$userId/orders';

    logInfo('📥 Получение заказов пользователя $userId', tag: 'OrderService');
    final response = await getRequest(
      url,
      headers: authorizedHeaders(token),
    );

    return handleResponseList(response, (data) => Order.fromJson(data));
  }

  /// 📥 Получить список всех заказов (для админа).
  static Future<List<Order>> fetchAllOrders(String token) async {
    final url = '$_baseUrl/orders';

    logInfo('📥 Получение всех заказов (админ)', tag: 'OrderService');
    final response = await getRequest(
      url,
      headers: authorizedHeaders(token),
    );

    return handleResponseList(response, (data) => Order.fromJson(data));
  }

  /// 🔁 Повторить заказ: добавить все товары из прошлого заказа в корзину
  static Future<void> repeatOrderToCart({
    required String token,
    required String userId,
    required int orderId,
  }) async {
    final url = '$_baseUrl/users/$userId/order/$orderId/repeat';

    logInfo('🔁 Повторение заказа #$orderId', tag: 'OrderService');
    final response = await postRequest(
      url,
      {}, // тело пустое, сервер сам повторяет
      headers: authorizedHeaders(token),
    );

    handleEmptyResponse(
      response,
      successCode: 200,
      errorMessage: 'Не удалось повторить заказ',
    );
  }
}









