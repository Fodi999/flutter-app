import 'package:flutter/material.dart';
import '../../../models/user.dart'; // модель пользователя
import '../../../services/user_service.dart'; // ✅ новый сервис

class AdminDashboardController extends ChangeNotifier {
  final String token;
  List<User> allUsers = [];
  List<User> staff = [];
  bool isLoading = false;
  String error = '';

  AdminDashboardController({required this.token}) {
    fetchUsers();
  }

  int get userCount => allUsers.length;
  int get staffCount => staff.length;

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

  /// Метод для использования без state management (например, в initState)
  static Future<Map<String, dynamic>?> fetchUserStats(String token) async {
    try {
      final users = await UserService.getAllUsers(token);
      final staff = users
          .where((u) => ['повар', 'курьер', 'официант'].contains(u.role))
          .toList();
      return {
        'userCount': users.length,
        'staff': staff,
        'staffCount': staff.length,
      };
    } catch (e) {
      debugPrint('Ошибка загрузки пользователей: $e');
      return null;
    }
  }
}


