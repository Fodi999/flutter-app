import 'dart:convert';
import 'package:sushi_app/services/api_constants.dart';
import 'package:sushi_app/services/http_helper.dart';
import 'package:sushi_app/utils/log_helper.dart'; // ✅ импорт логгера

class AuthService {
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final url = '$baseUrl/login';
    final body = {'email': email, 'password': password};

    logInfo('📤 [LOGIN] POST $url');
    logDebug('📨 Body: $body');

    final res = await postRequest(url, body);

    logInfo('✅ Status: ${res.statusCode}');
    logDebug('📦 Response: ${utf8.decode(res.bodyBytes)}');

    if (res.statusCode == 200) {
      return json.decode(utf8.decode(res.bodyBytes));
    } else {
      throw Exception('Ошибка входа: ${utf8.decode(res.bodyBytes)}');
    }
  }

  static Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final url = '$baseUrl/register';
    final body = {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
    };

    logInfo('📤 [REGISTER] POST $url');
    logDebug('📨 Body: $body');

    final res = await postRequest(url, body);

    logInfo('✅ Status: ${res.statusCode}');
    logDebug('📦 Response: ${utf8.decode(res.bodyBytes)}');

    if (res.statusCode != 200) {
      throw Exception('Ошибка регистрации: ${utf8.decode(res.bodyBytes)}');
    }
  }
}



