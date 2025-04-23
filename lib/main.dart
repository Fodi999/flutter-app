import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';
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
              scaffoldBackgroundColor: const Color(0xFFF7FAF7),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF4CAF50),
                primary: const Color(0xFF4CAF50),
                secondary: const Color(0xFFFFC107),
                surface: Colors.white.withOpacity(0.9),
                brightness: Brightness.light,
              ),
              textTheme: const TextTheme(
                displayLarge: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                bodyLarge: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  color: Colors.black87,
                ),
                bodyMedium: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  color: Color(0xFF616161),
                ),
              ),
              cardTheme: CardThemeData(
                elevation: 0,
                color: Colors.white.withOpacity(0.7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                surfaceTintColor: Colors.transparent,
                clipBehavior: Clip.antiAlias,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF4CAF50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 24,
                  ),
                  elevation: 2,
                  shadowColor: Colors.black.withOpacity(0.2),
                  animationDuration: const Duration(milliseconds: 200),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: Colors.white.withOpacity(0.3),
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontFamily: 'Roboto',
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide(
                    color: Color(0xFF4CAF50),
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: FadeThroughPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.macOS: FadeThroughPageTransitionsBuilder(),
                  TargetPlatform.windows: FadeThroughPageTransitionsBuilder(),
                  TargetPlatform.linux: FadeThroughPageTransitionsBuilder(),
                },
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: const Color(0xFF121212),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF4CAF50),
                primary: const Color(0xFF4CAF50),
                secondary: const Color(0xFFFFC107),
                surface: Colors.black.withOpacity(0.8),
                brightness: Brightness.dark,
              ),
              textTheme: const TextTheme(
                displayLarge: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                bodyLarge: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  color: Colors.white70,
                ),
                bodyMedium: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  color: Color(0xFFBDBDBD),
                ),
              ),
              cardTheme: CardThemeData(
                elevation: 0,
                color: Colors.grey[900]!.withOpacity(0.7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                surfaceTintColor: Colors.transparent,
                clipBehavior: Clip.antiAlias,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: const Color(0xFF4CAF50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 24,
                  ),
                  elevation: 2,
                  shadowColor: Colors.black.withOpacity(0.3),
                  animationDuration: const Duration(milliseconds: 200),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: Colors.grey[900]!.withOpacity(0.5),
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontFamily: 'Roboto',
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide(
                    color: Color(0xFF4CAF50),
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: FadeThroughPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.macOS: FadeThroughPageTransitionsBuilder(),
                  TargetPlatform.windows: FadeThroughPageTransitionsBuilder(),
                  TargetPlatform.linux: FadeThroughPageTransitionsBuilder(),
                },
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




