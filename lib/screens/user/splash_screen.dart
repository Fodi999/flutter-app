import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sushi_app/screens/user/welcome_screen.dart';
import 'package:sushi_app/components/app_title.dart'; // ✅ добавлен
import 'package:sushi_app/components/primary_button.dart'; // ✅ добавлен

class SplashScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const SplashScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => WelcomeScreen(
              isDarkMode: widget.isDarkMode,
              onToggleTheme: widget.onToggleTheme,
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1B5E20),
              Color(0xFF43A047),
              Color(0xFF66BB6A),
              Color(0xFFC8E6C9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.ramen_dining_rounded, size: 80, color: Colors.white),
              const SizedBox(height: 32),
              const AppTitle(fontSize: 42, animate: true),
              const SizedBox(height: 12),
              Text(
                'Добро пожаловать на платформу\nвкусной и полезной кухни',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 20,
                  color: Colors.white70,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                text: 'Загрузка...',
                onPressed: () {}, // ✅ заменено на пустую функцию
                fullWidth: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}









