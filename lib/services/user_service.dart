import 'dart:convert';
import 'package:sushi_app/models/user.dart';
import 'package:sushi_app/services/api_constants.dart';
import 'package:sushi_app/services/http_helper.dart';
import 'package:sushi_app/utils/log_helper.dart';

class UserService {
  /// Получение всех пользователей
  static Future<List<User>> getAllUsers(String token) async {
    final url = '$baseUrl/users';
    final headers = authorizedHeaders(token);

    logInfo('📥 [GET ALL USERS] GET $url');
    logDebug('📨 Headers: $headers');

    final res = await getRequest(url, headers: headers);

    logInfo('✅ Status: ${res.statusCode}');
    logDebug('📦 Response: ${utf8.decode(res.bodyBytes)}');

    if (res.statusCode == 200) {
      final data = json.decode(utf8.decode(res.bodyBytes)) as List;
      return data.map((u) => User.fromJson(u as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Ошибка загрузки пользователей: ${utf8.decode(res.bodyBytes)}');
    }
  }

  /// Получение пользователя по ID
  static Future<User> getUserById(String id, String token) async {
    final url = '$baseUrl/users/$id';
    final headers = authorizedHeaders(token);

    logInfo('📥 [GET USER] GET $url');
    logDebug('📨 Headers: $headers');

    final res = await getRequest(url, headers: headers);

    logInfo('✅ Status: ${res.statusCode}');
    logDebug('📦 Response: ${utf8.decode(res.bodyBytes)}');

    if (res.statusCode == 200) {
      return User.fromJson(json.decode(utf8.decode(res.bodyBytes)));
    } else {
      throw Exception('Ошибка загрузки профиля: ${utf8.decode(res.bodyBytes)}');
    }
  }

  /// Обновление пользователя по ID
  static Future<User> updateUserById(
    String id,
    Map<String, dynamic> data,
    String token,
  ) async {
    data.removeWhere((key, value) => value == null);

    final url = '$baseUrl/users/$id';
    final headers = authorizedHeaders(token);

    logInfo('🛠️ [UPDATE USER] PUT $url');
    logDebug('📨 Headers: $headers');
    logDebug('📨 Body: $data');

    final res = await putRequest(url, data, headers: headers);

    logInfo('✅ Status: ${res.statusCode}');
    logDebug('📦 Response: ${utf8.decode(res.bodyBytes)}');

    if (res.statusCode == 200) {
      return User.fromJson(json.decode(utf8.decode(res.bodyBytes)));
    } else {
      throw Exception('Ошибка обновления профиля: ${utf8.decode(res.bodyBytes)}');
    }
  }

  /// Удаление пользователя
  static Future<void> deleteUser(String id, String token) async {
    final url = '$baseUrl/users/$id';
    final headers = authOnlyHeaders(token);

    logInfo('🗑️ [DELETE USER] DELETE $url');
    logDebug('📨 Headers: $headers');

    final res = await deleteRequest(url, headers: headers);

    logInfo('✅ Status: ${res.statusCode}');
    if (res.statusCode != 204) {
      logError('❌ Response Body: ${utf8.decode(res.bodyBytes)}');
      throw Exception('Ошибка удаления: ${utf8.decode(res.bodyBytes)}');
    }
  }

  /// Обновление роли пользователя
  static Future<void> updateUserRole(
    String id,
    String role,
    String token,
  ) async {
    final url = '$baseUrl/users/$id/role';
    final headers = authorizedHeaders(token);
    final body = {'role': role};

    logInfo('🔁 [UPDATE ROLE] PUT $url');
    logDebug('📨 Headers: $headers');
    logDebug('📨 Body: $body');

    final res = await putRequest(url, body, headers: headers);

    logInfo('✅ Status: ${res.statusCode}');
    if (res.statusCode != 200) {
      logError('❌ Response Body: ${utf8.decode(res.bodyBytes)}');
      throw Exception('Ошибка обновления роли: ${utf8.decode(res.bodyBytes)}');
    }
  }
}





