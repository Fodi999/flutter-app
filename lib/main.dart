// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'theme/theme_light.dart';
import 'theme/theme_dark.dart';
import 'theme/theme_provider.dart';           // ← ваш ChangeNotifier
import 'screens/user/splash_screen.dart';

/* ─────────── Riverpod-провайдер для темы ─────────── */
final themeProvider =
    ChangeNotifierProvider<ThemeProvider>((ref) => ThemeProvider());

/* ─────────────────────── main() ───────────────────── */
void main() {
  runApp(
    const ProviderScope(child: SushiApp()),   // корневой Scope Riverpod
  );
}

/* ─────────────── Приложение ­­- ConsumerWidget ────── */
class SushiApp extends ConsumerWidget {
  const SushiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeProv = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Sushi App',
      debugShowCheckedModeBanner: false,

      // ─── темы ───────────────────────────────────────
      themeMode: themeProv.themeMode,
      theme:     lightTheme,
      darkTheme: darkTheme,

      // ─── стартовый экран ────────────────────────────
      home: SplashScreen(
        isDarkMode: themeProv.themeMode == ThemeMode.dark,
        onToggleTheme: () => ref.read(themeProvider).toggleTheme(),
      ),
    );
  }
}












