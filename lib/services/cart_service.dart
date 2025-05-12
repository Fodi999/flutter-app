// lib/services/cart_service.dart

import 'package:sushi_app/models/cart.dart';
import 'package:sushi_app/services/api_constants.dart';
import 'package:sushi_app/services/http_helper.dart';

class CartService {
  /// Получить корзину пользователя
  static Future<Cart> getCart({
    required String userId,
    required String token,
  }) async {
    final url = '$baseUrl/users/$userId/cart/';
    final response = await getRequest(
      url,
      headers: authorizedHeaders(token),
    );
    return handleResponseObject<Cart>(
      response,
      (json) => Cart.fromJson(json as Map<String, dynamic>),
      errorMessage: 'Ошибка получения корзины',
    );
  }

  /// Добавить товар в корзину
  static Future<CartItem> addToCart({
    required String userId,
    required String token,
    required String menuItemId,
    required String name,
    required int quantity,
    required double price,
    Map<String, dynamic> options = const {}, // 🆕
  }) async {
    final url = '$baseUrl/users/$userId/cart/';
    final body = {
      'menuItemId': menuItemId,
      'name': name,
      'quantity': quantity,
      'price': price,
      'options': options, 
    };
    final response = await postRequest(
      url,
      body,
      headers: authorizedHeaders(token),
    );
    return handleResponseObject<CartItem>(
      response,
      (json) => CartItem.fromJson(json as Map<String, dynamic>),
      successCode: 200,
      errorMessage: 'Ошибка добавления в корзину',
    );
  }

  /// Обновить количество товара в корзине
  static Future<CartItem> updateCartItem({
    required String userId,
    required String token,
    required String menuItemId,
    required int quantity,
  }) async {
    final url = '$baseUrl/users/$userId/cart/$menuItemId';
    final body = {'quantity': quantity};
    final response = await putRequest(
      url,
      body,
      headers: authorizedHeaders(token),
    );
    return handleResponseObject<CartItem>(
      response,
      (json) => CartItem.fromJson(json as Map<String, dynamic>),
      successCode: 200,
      errorMessage: 'Ошибка обновления количества',
    );
  }

  /// Удалить один элемент из корзины
  static Future<void> removeCartItem({
    required String userId,
    required String token,
    required String menuItemId,
  }) async {
    final url = '$baseUrl/users/$userId/cart/$menuItemId';
    final response = await deleteRequest(
      url,
      headers: authorizedHeaders(token),
    );
    // Наш эндпоинт возвращает 204 No Content
    handleEmptyResponse(
      response,
      successCode: 204,
      errorMessage: 'Ошибка удаления из корзины',
    );
  }

  /// Очистить всю корзину
  static Future<void> clearCart({
    required String userId,
    required String token,
  }) async {
    final url = '$baseUrl/users/$userId/cart/';
    final response = await deleteRequest(
      url,
      headers: authorizedHeaders(token),
    );
    // 204 No Content
    handleEmptyResponse(
      response,
      successCode: 204,
      errorMessage: 'Ошибка очистки корзины',
    );
  }
}




