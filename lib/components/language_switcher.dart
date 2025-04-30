// lib/components/language_switcher.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/locale_provider.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final isRussian = localeProvider.localeCode == 'ru';

    return IconButton(
      onPressed: () => localeProvider.toggleLocale(context),
      icon: Text(
        // Показываем флаг текущей локали
        isRussian ? '🇷🇺' : '🇬🇧',
        style: const TextStyle(fontSize: 24),
      ),
      // Подсказка для кнопки — переключает на противоположный язык
      tooltip: isRussian
          ? 'Switch to English'
          : 'Переключить на русский',
    );
  }
}

