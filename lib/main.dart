import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';

import 'theme/theme_provider.dart';
import 'theme/theme_light.dart';
import 'theme/theme_dark.dart';
import 'screens/user/splash_screen.dart'; // ✅ Заменили welcome_screen

void main() {
  runApp(const SushiApp());
}

class SushiApp extends StatelessWidget {
  const SushiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeProvider>(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'SushiRobot',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: lightTheme,
            darkTheme: darkTheme,
            home: SplashScreen( // ✅ Теперь это первый экран
              isDarkMode: themeProvider.themeMode == ThemeMode.dark,
              onToggleTheme: themeProvider.toggleTheme,
            ),
          );
        },
      ),
    );
  }
}






