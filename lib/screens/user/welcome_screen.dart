import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'login_screen.dart'; // подключаем LoginScreen

class WelcomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const WelcomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<Offset>> _slideAnimations;
  late List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();

    _slideAnimations = List.generate(3, (index) {
      return Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(0.2 * index, 0.6 + index * 0.2, curve: Curves.easeOut),
        ),
      );
    });

    _fadeAnimations = List.generate(3, (index) {
      return Tween<double>(
        begin: 0,
        end: 1,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(0.2 * index, 0.6 + index * 0.2, curve: Curves.easeOut),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: widget.onToggleTheme,
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'SushiRobot',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Доставка суши к вашей двери\nЗакажите свежие суши прямо сейчас!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: textColor.withOpacity(0.85),
                  ),
                ),
                const SizedBox(height: 36),

                // Анимационные блоки
                for (int i = 0; i < 3; i++) ...[
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimations[i].value,
                        child: Transform.translate(
                          offset: _slideAnimations[i].value * 20,
                          child: _buildFeatureBox(
                            context,
                            i == 0
                                ? Icons.check_circle
                                : i == 1
                                    ? Icons.local_shipping
                                    : Icons.verified_user,
                            i == 0
                                ? 'Свежие ингредиенты'
                                : i == 1
                                    ? 'Быстрое оформление заказа'
                                    : 'Качество и безопасность',
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                const SizedBox(height: 24),

                // Кнопки
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LoginScreen(
                                isDarkMode: widget.isDarkMode,
                                onToggleTheme: widget.onToggleTheme,
                              ),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(
                            color: theme.colorScheme.primary.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          'Вход',
                          style: TextStyle(color: textColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RegisterScreen(
                                isDarkMode: widget.isDarkMode,
                                onToggleTheme: widget.onToggleTheme,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Регистрация'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureBox(BuildContext context, IconData icon, String text) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.25),
          width: 1.2,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
            child: Icon(icon, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: textColor.withOpacity(0.85),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}













