import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/menu_calculation.dart';
import 'api_constants.dart';
import 'http_helper.dart';
import 'package:sushi_app/utils/log_helper.dart';

class CalculationService {
  static Future<void> saveDishCalculation(MenuCalculation calculation, String token) async {
    final url = '$baseUrl/menu/calculation';
    final headers = authorizedHeaders(token);
    final body = jsonEncode(calculation.toJson());

    logInfo('📤 [SAVE CALCULATION] POST $url');
    logDebug('📨 Headers: $headers');
    logDebug('📨 Body: $body');

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    logInfo('✅ Status: ${response.statusCode}');
    if (response.statusCode != 201) {
      logError('❌ Response Body: ${utf8.decode(response.bodyBytes)}');
    }

    handleEmptyResponse(
      response,
      successCode: 201,
      errorMessage: 'Ошибка сохранения калькуляции',
    );
  }

  /// ✅ Загрузка существующей калькуляции по блюду
  static Future<MenuCalculation?> getDishCalculation(String menuItemId) async {
    final url = '$baseUrl/menu/calculation/$menuItemId';

    logInfo('📥 [GET CALCULATION] GET $url');

    final response = await http.get(Uri.parse(url));

    logInfo('📶 Status: ${response.statusCode}');
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      return MenuCalculation.fromJson(jsonData);
    } else if (response.statusCode == 404) {
      logInfo('⚠️ Калькуляция не найдена');
      return null;
    } else {
      logError('❌ Ошибка загрузки калькуляции: ${utf8.decode(response.bodyBytes)}');
      throw Exception('Ошибка загрузки калькуляции');
    }
  }
}



