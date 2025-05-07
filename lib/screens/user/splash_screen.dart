import 'package:flutter/material.dart';
import 'package:sushi_app/components/app_title.dart';
import 'package:sushi_app/components/primary_button.dart';
import 'package:sushi_app/screens/user/welcome_screen.dart';
import 'package:sushi_app/theme/app_spacing.dart';
import 'package:sushi_app/utils/responsive.dart';
import 'package:sushi_app/theme/animated_fade_in.dart';

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

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slideIn = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;
    final isDesktop = Responsive.isDesktop(context);
    final horizontalPadding = isDesktop ? AppSpacing.xl : AppSpacing.lg;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) => Opacity(
                      opacity: _fadeIn.value,
                      child: Transform.translate(
                        offset: _slideIn.value * 20,
                        child: Icon(
                          Icons.ramen_dining_rounded,
                          size: 80,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) => Opacity(
                      opacity: _fadeIn.value,
                      child: Transform.translate(
                        offset: _slideIn.value * 20,
                        child: const AppTitle(fontSize: 42, animate: true),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) => Opacity(
                      opacity: _fadeIn.value,
                      child: Transform.translate(
                        offset: _slideIn.value * 20,
                        child: Text(
                          'Witamy w SHOKU — miejscu, gdzie smak spotyka się z troską o zdrowie.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            height: 1.4,
                            color: colorScheme.onPrimary
                                .withOpacity(0.8),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) => Opacity(
                      opacity: _fadeIn.value,
                      child: Transform.translate(
                        offset: _slideIn.value * 20,
                        child: PrimaryButton(
                          text: 'Dalej',
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => WelcomeScreen(
                                  isDarkMode: widget.isDarkMode,
                                  onToggleTheme: widget.onToggleTheme,
                                ),
                              ),
                            );
                          },
                          fullWidth: false,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}














