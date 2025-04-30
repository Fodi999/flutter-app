import 'package:flutter/material.dart';
import 'package:sushi_app/models/user.dart';
import 'package:sushi_app/services/user_service.dart';

class AdminDashboardController extends ChangeNotifier {
  // 1️⃣ Конструктор сразу после объявления класса
  AdminDashboardController({required this.token}) {
    fetchUsers();
  }

  // 2️⃣ Затем — поля
  final String token;
  List<User> allUsers = [];
  List<User> staff = [];
  bool isLoading = false;
  String error = '';

  // 3️⃣ Геттеры
  int get userCount => allUsers.length;
  int get staffCount => staff.length;

  // 4️⃣ Методы
  Future<void> fetchUsers() async {
    isLoading = true;
    notifyListeners();

    try {
      final users = await UserService.getAllUsers(token);
      allUsers = users;
      staff = users
          .where((u) => ['повар', 'курьер', 'официант'].contains(u.role))
          .toList();
      error = '';
    } catch (e) {
      error = 'Ошибка загрузки пользователей: $e';
      debugPrint(error);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Утилитарный статический метод для получения статистики без создания контроллера
  static Future<Map<String, dynamic>?> fetchUserStats(String token) async {
    try {
      final users = await UserService.getAllUsers(token);
      final staffList = users
          .where((u) => ['повар', 'курьер', 'официант'].contains(u.role))
          .toList();
      return {
        'userCount': users.length,
        'staff': staffList,
        'staffCount': staffList.length,
      };
    } catch (e) {
      debugPrint('Ошибка загрузки пользователей: $e');
      return null;
    }
  }
}



