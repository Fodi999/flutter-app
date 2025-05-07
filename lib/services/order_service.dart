// lib/services/order_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sushi_app/services/http_helper.dart';

class OrderService {
  static const _baseUrl = 'https://api.yourdomain.com';

  /// Создаёт новый заказ на сервере.
  ///
  /// Если [comment] передан и не пуст, он будет добавлен в тело запроса.
  static Future<void> createOrder({
    required String token,
    required String userId,
    required String name,
    required String phone,
    required String address,
    required List<Map<String, dynamic>> items,
    String? comment,                                // ← комментарий (необяз.)
  }) async {
    final url  = '$_baseUrl/orders';

    final body = <String, dynamic>{
      'userId' : userId,
      'name'   : name,
      'phone'  : phone,
      'address': address,
      'items'  : items,
      if (comment != null && comment.trim().isNotEmpty)
        'comment': comment.trim(),
    };

    final http.Response response = await postRequest(
      url,
      body,
      headers: authorizedHeaders(token),
    );

    if (response.statusCode != 201) {
      throw Exception(
        'Не удалось создать заказ: '
        '${response.statusCode} ${response.reasonPhrase}',
      );
    }
  }

  /// Получить список заказов пользователя.
  static Future<List<Map<String, dynamic>>> fetchOrders({
    required String token,
    required String userId,
  }) async {
    final url = '$_baseUrl/users/$userId/orders';

    final http.Response response = await getRequest(
      url,
      headers: authorizedHeaders(token),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(
        json.decode(utf8.decode(response.bodyBytes)) as List,
      );
    } else {
      throw Exception(
        'Не удалось загрузить заказы: '
        '${response.statusCode} ${response.reasonPhrase}',
      );
    }
  }
}



