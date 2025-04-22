import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'screens/user/welcome_screen.dart';

void main() {
  runApp(const SushiApp());
}

class SushiApp extends StatelessWidget {
  const SushiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'SushiRobot',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: ThemeData(
              brightness: Brightness.light,
              scaffoldBackgroundColor: const Color(0xFFF2FFF3),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFFA8E6A1),
                brightness: Brightness.light,
              ),
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: Colors.black87),
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: Colors.grey[200],
                hintStyle: TextStyle(color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: const Color(0xFF0D1F17),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF1B5E20),
                brightness: Brightness.dark,
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: Colors.grey[900],
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              useMaterial3: true,
            ),
            home: WelcomeScreen(
              isDarkMode: themeProvider.themeMode == ThemeMode.dark,
              onToggleTheme: themeProvider.toggleTheme,
            ),
          );
        },
      ),
    );
  }
}


