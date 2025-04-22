import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sushi_app/utils/log_helper.dart'; // ✅ логгер

// 👉 GET
Future<http.Response> getRequest(String url, {Map<String, String>? headers}) async {
  logInfo('🌐 [GET] $url');
  logDebug('📨 Headers: $headers');

  final response = await http.get(Uri.parse(url), headers: headers);

  logInfo('✅ Status: ${response.statusCode}');
  logDebug('📦 Response: ${utf8.decode(response.bodyBytes)}');
  return response;
}

// 👉 POST
Future<http.Response> postRequest(String url, dynamic body, {Map<String, String>? headers}) async {
  final mergedHeaders = {
    'Content-Type': 'application/json',
    if (headers != null) ...headers,
  };

  logInfo('🌐 [POST] $url');
  logDebug('📨 Headers: $mergedHeaders');
  logDebug('📨 Body: $body');

  final response = await http.post(Uri.parse(url), headers: mergedHeaders, body: jsonEncode(body));

  logInfo('✅ Status: ${response.statusCode}');
  logDebug('📦 Response: ${utf8.decode(response.bodyBytes)}');
  return response;
}

// 👉 PUT
Future<http.Response> putRequest(String url, dynamic body, {Map<String, String>? headers}) async {
  final mergedHeaders = {
    'Content-Type': 'application/json',
    if (headers != null) ...headers,
  };

  logInfo('🌐 [PUT] $url');
  logDebug('📨 Headers: $mergedHeaders');
  logDebug('📨 Body: $body');

  final response = await http.put(Uri.parse(url), headers: mergedHeaders, body: jsonEncode(body));

  logInfo('✅ Status: ${response.statusCode}');
  logDebug('📦 Response: ${utf8.decode(response.bodyBytes)}');
  return response;
}

// 👉 DELETE
Future<http.Response> deleteRequest(String url, {Map<String, String>? headers}) async {
  final mergedHeaders = {
    'Content-Type': 'application/json',
    if (headers != null) ...headers,
  };

  logInfo('🌐 [DELETE] $url');
  logDebug('📨 Headers: $mergedHeaders');

  final response = await http.delete(Uri.parse(url), headers: mergedHeaders);

  logInfo('✅ Status: ${response.statusCode}');
  logDebug('📦 Response: ${utf8.decode(response.bodyBytes)}');
  return response;
}

// 👉 Заголовки авторизации + JSON
Map<String, String> authorizedHeaders(String token) => {
  'Authorization': 'Bearer $token',
  'Content-Type': 'application/json',
};

// 👉 Только авторизация
Map<String, String> authOnlyHeaders(String token) => {
  'Authorization': 'Bearer $token',
};

// ✅ Обработка пустого ответа
void handleEmptyResponse(http.Response response, {
  int successCode = 200,
  String errorMessage = 'Ошибка запроса',
}) {
  if (response.statusCode != successCode) {
    throw Exception('$errorMessage: ${utf8.decode(response.bodyBytes)}');
  }
}

// ✅ Обработка списка объектов
List<T> handleResponseList<T>(
  http.Response response,
  T Function(dynamic json) fromJson, {
  String errorMessage = 'Ошибка загрузки данных',
}) {
  if (response.statusCode == 200) {
    final data = json.decode(utf8.decode(response.bodyBytes));
    return (data as List).map(fromJson).toList();
  } else {
    throw Exception('$errorMessage: ${utf8.decode(response.bodyBytes)}');
  }
}

// ✅ Обработка одного объекта
T handleResponseObject<T>(
  http.Response response,
  T Function(dynamic json) fromJson, {
  int successCode = 200,
  String errorMessage = 'Ошибка получения объекта',
}) {
  if (response.statusCode == successCode) {
    final data = json.decode(utf8.decode(response.bodyBytes));
    return fromJson(data);
  } else {
    throw Exception('$errorMessage: ${utf8.decode(response.bodyBytes)}');
  }
}








