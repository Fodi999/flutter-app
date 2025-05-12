import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:sushi_app/models/ad_banner.dart';
import 'package:sushi_app/services/api_constants.dart';
import 'package:sushi_app/utils/log_helper.dart';

class AdService {
  // WebSocket-подключение
  static WebSocketChannel connectToAds() {
    final wsBaseUrl = baseUrl.replaceFirst('http', 'ws').replaceAll('/api', '');
    final uri = Uri.parse('$wsBaseUrl/ws/banners');
    logInfo('🔌 WebSocket подключение к: $uri');
    return WebSocketChannel.connect(uri);
  }

  // Получить список рекламных баннеров
static Future<List<AdBanner>> fetchAds({required String token}) async {
  final url = '$baseUrl/ads';
  logInfo('📡 Запрос баннеров: $url');

  final response = await http.get(Uri.parse(url), headers: {
    'Authorization': 'Bearer $token',
  });

  // ✅ Декодируем явно как UTF-8
  final decodedBody = utf8.decode(response.bodyBytes);
  logInfo('📥 Ответ баннеров: ${response.statusCode} $decodedBody');

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(decodedBody);
    return data.map((e) => AdBanner.fromJson(e)).toList();
  } else {
    logError('❌ Ошибка загрузки баннеров: $decodedBody');
    throw Exception('Ошибка загрузки баннеров: $decodedBody');
  }
}


  // Создать новый баннер
  static Future<void> createAdBanner({
    required String token,
    required String imageUrl,
    required String text,
  }) async {
    final url = '$baseUrl/ads';
    final payload = {'image_url': imageUrl, 'text': text};
    final body = jsonEncode(payload);

    logInfo('📤 Отправка баннера:\nURL: $imageUrl\nText: $text\nJSON: $body');

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    logInfo('📥 Ответ на создание: ${response.statusCode} ${response.body}');

    if (response.statusCode != 201) {
      logError('❌ Ошибка при создании баннера: ${response.body}');
      throw Exception('Ошибка при создании баннера: ${response.body}');
    }
  }

  // Удалить баннер
  static Future<void> deleteAdBanner({
    required String id,
    required String token,
  }) async {
    final url = '$baseUrl/ads/$id';
    logInfo('🗑️ Удаление баннера: $url');

    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    logInfo('📥 Ответ на удаление: ${response.statusCode} ${response.body}');

    if (response.statusCode != 200) {
      logError('❌ Ошибка при удалении баннера: ${response.body}');
      throw Exception('Ошибка при удалении баннера: ${response.body}');
    }
  }
}





