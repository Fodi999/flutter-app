// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import 'theme/theme_light.dart';
import 'theme/theme_dark.dart';
import 'theme/theme_provider.dart';
import 'theme/locale_provider.dart';
import 'screens/user/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Создаём LocalizationDelegate из flutter_translate
  final delegate = await LocalizationDelegate.create(
    fallbackLocale: 'en',
    supportedLocales: ['en', 'ru'],
    basePath: 'assets/i18n',
  );

  runApp(
    LocalizedApp(
      delegate,
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ],
        child: const SushiApp(),
      ),
    ),
  );
}

class SushiApp extends StatelessWidget {
  const SushiApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Получаем delegate для MaterialApp
    final localizationDelegate = LocalizedApp.of(context).delegate;

    return Consumer<ThemeProvider>(
      builder: (context, themeProv, _) {
        return MaterialApp(
          title: 'Sushi App',
          debugShowCheckedModeBanner: false,

          // ─── Тема ───
          themeMode: themeProv.themeMode,
          theme: lightTheme,
          darkTheme: darkTheme,

          // ─── Локализация ───
          locale: localizationDelegate.currentLocale,
          supportedLocales: localizationDelegate.supportedLocales,
          localizationsDelegates: [
            localizationDelegate,                          // flutter_translate
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          // ─── Стартовый экран ───
          home: SplashScreen(
            isDarkMode: themeProv.themeMode == ThemeMode.dark,
            onToggleTheme: themeProv.toggleTheme,
          ),
        );
      },
    );
  }
}











