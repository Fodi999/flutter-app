// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme/theme_light.dart';
import 'theme/theme_dark.dart';
import 'theme/theme_provider.dart';
import 'screens/user/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const SushiApp(),
    ),
  );
}

class SushiApp extends StatefulWidget {
  const SushiApp({super.key});

  @override
  State<SushiApp> createState() => _SushiAppState();
}

class _SushiAppState extends State<SushiApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProv, _) {
        return MaterialApp(
          title: 'Sushi App',
          debugShowCheckedModeBanner: false,

          // ─── Тема ───
          themeMode: themeProv.themeMode,
          theme: lightTheme,
          darkTheme: darkTheme,

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











