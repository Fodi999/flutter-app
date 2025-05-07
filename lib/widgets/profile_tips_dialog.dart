// lib/widgets/profile_tips_dialog.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileTipsDialog {
  /// Показывает подсказки один раз при первом открытии профиля
  static Future<void> showIfNeeded(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('profile_tips_shown') == true) return;

    // Небольшая задержка, чтобы диалог не выскочил мгновенно
    await Future.delayed(const Duration(seconds: 1));
    if (!context.mounted) return;

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
            Text(
              '🏪 Хотите открыть свой бизнес онлайн? Смени профиль на бизнес-аккаунт!',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Понятно'),
          ),
        ],
      ),
    );

    await prefs.setBool('profile_tips_shown', true);
  }
}
