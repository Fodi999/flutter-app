// lib/components/language_switcher.dart

import 'package:flutter/material.dart';
import '../theme/translator.dart';

class LanguageSwitcher extends StatefulWidget {
  const LanguageSwitcher({super.key});

  @override
  State<LanguageSwitcher> createState() => _LanguageSwitcherState();
}

class _LanguageSwitcherState extends State<LanguageSwitcher> {
  void _toggleLanguage() {
    setState(() {
      currentLanguage = currentLanguage == 'ru' ? 'en' : 'ru';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isRussian = currentLanguage == 'ru';

    return IconButton(
      onPressed: _toggleLanguage,
      icon: Text(
        isRussian ? '🇷🇺' : '🇬🇧',
        style: const TextStyle(fontSize: 24),
      ),
      tooltip: isRussian ? t('switchToEnglish') : t('switchToRussian'),
    );
  }
}


