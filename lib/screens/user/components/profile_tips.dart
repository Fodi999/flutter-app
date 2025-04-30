import 'package:flutter/material.dart';

class ProfileTips {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Понятно'),
            ),
          ],
        );
      },
    );
  }
}


