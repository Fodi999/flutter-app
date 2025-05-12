import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sushi_app/utils/log_helper.dart'; // ✅ логгер

class ProfileTipsDialog {
  /// Показывает подсказки один раз при первом открытии профиля
  static Future<void> showIfNeeded(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    // Проверка: уже показывали?
    if (prefs.getBool('profile_tips_shown') == true) {
      logDebug('🧠 Подсказки профиля уже были показаны', tag: 'ProfileTips');
      return;
    }

    // Короткая задержка перед показом
    await Future.delayed(const Duration(seconds: 1));

    if (!context.mounted) return;

    logInfo('🎯 Показываем подсказки по профилю', tag: 'ProfileTips');

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Советы по управлению профилем'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('✏ Нажмите на ✎, чтобы редактировать профиль.'),
            SizedBox(height: 8),
            Text('🌙 Нажмите на 🌞 или 🌙, чтобы переключить тему.'),
            SizedBox(height: 8),
            Text('🚪 Нажмите на 🚪, чтобы выйти из аккаунта.'),
            SizedBox(height: 8),
            Divider(),
            SizedBox(height: 8),
            Text('🏪 Хотите открыть свой бизнес онлайн? Смени профиль на бизнес-аккаунт!'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              logInfo('✅ Пользователь закрыл подсказки профиля', tag: 'ProfileTips');
            },
            child: const Text('Понятно'),
          ),
        ],
      ),
    );

    await prefs.setBool('profile_tips_shown', true);
  }
}

