// lib/components/language_switcher.dart

import 'package:flutter/material.dart';
import '../theme/translator.dart';

class LanguageSwitcher extends StatefulWidget {
  const LanguageSwitcher({super.key});

  @override
  State<LanguageSwitcher> createState() => _LanguageSwitcherState();
}

class _LanguageSwitcherState extends State<LanguageSwitcher> {
  final List<String> _languages = ['ru', 'en', 'pl'];

  void _toggleLanguage() {
    final currentIndex = _languages.indexOf(currentLanguage);
    final nextIndex = (currentIndex + 1) % _languages.length;

    setState(() {
      currentLanguage = _languages[nextIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    final icon = {
      'ru': '🇷🇺',
      'en': '🇬🇧',
      'pl': '🇵🇱',
    }[currentLanguage]!;

    final tooltip = {
      'ru': t('switchToEnglish'),
      'en': t('switchToPolish'),
      'pl': t('switchToRussian'),
    }[currentLanguage]!;

    return IconButton(
      onPressed: _toggleLanguage,
      icon: Text(
        icon,
        style: const TextStyle(fontSize: 24),
      ),
      tooltip: tooltip,
    );
  }
}



