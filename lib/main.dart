// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'theme/theme_light.dart';       // ← ваша светлая тема
import 'theme/theme_dark.dart';        // ← ваша тёмная тема
import 'theme/theme_provider.dart';
import 'theme/locale_provider.dart';
import 'screens/user/splash_screen.dart';

void main() => runApp(const SushiApp());

class SushiApp extends StatelessWidget {
  const SushiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (_, themeProvider, localeProvider, __) {
          return MaterialApp(
            title: 'SushiRobot',
            debugShowCheckedModeBanner: false,

            // ─── темы ───
            themeMode: themeProvider.themeMode,
            theme:     lightTheme,      // из theme_light.dart
            darkTheme: darkTheme,       // из theme_dark.dart

            // ─── локализация ───
            locale: localeProvider.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            // ─── стартовый экран ───
            home: SplashScreen(
              isDarkMode: themeProvider.themeMode == ThemeMode.dark,
              onToggleTheme: themeProvider.toggleTheme,
            ),
          );
        },
      ),
    );
  }
}










