import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/locale_provider.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isRussian = localeProvider.locale.languageCode == 'ru';

    return IconButton(
      onPressed: () {
        localeProvider.toggleLocale();
      },
      icon: Text(
        isRussian ? '🇷🇺' : '🇬🇧',
        style: const TextStyle(fontSize: 24),
      ),
      tooltip: isRussian ? 'Переключить на English' : 'Switch to Russian',
    );
  }
}
