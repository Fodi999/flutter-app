import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:sushi_app/components/primary_button.dart';
import 'package:sushi_app/components/app_title.dart';
import 'package:sushi_app/theme/app_spacing.dart';
import 'package:sushi_app/theme/locale_provider.dart';
import 'package:sushi_app/utils/responsive.dart';

import 'register_screen.dart';
import 'login_screen.dart';

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
    // Получаем переводы
    final loc = AppLocalizations.of(context)!;
    // Провайдер для переключения языка
    final localeProvider = context.watch<LocaleProvider>();
    final isRu = localeProvider.locale.languageCode == 'ru';

    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;
    final isDesktop = Responsive.isDesktop(context);
    final maxWidth = isDesktop ? 600.0 : double.infinity;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // Переключатель языка
          IconButton(
            onPressed: localeProvider.toggleLocale,
            icon: Text(
              isRu ? '🇷🇺' : '🇬🇧',
              style: const TextStyle(fontSize: 24),
            ),
            tooltip: isRu ? loc.switchToEnglish : loc.switchToRussian,
          ),
          // Переключатель темы
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
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.xl,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Название приложения
                  const AppTitle(fontSize: 48, animate: true),
                  const SizedBox(height: AppSpacing.sm),
                  // Локализованный слоган
                  Text(
                    loc.slogan,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: textColor.withOpacity(0.85),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Фичи
                  for (int i = 0; i < 3; i++) ...[
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        String text;
                        IconData icon;
                        switch (i) {
                          case 0:
                            icon = Icons.check_circle;
                            text = loc.freshIngredients;
                            break;
                          case 1:
                            icon = Icons.local_shipping;
                            text = loc.fastOrder;
                            break;
                          default:
                            icon = Icons.verified_user;
                            text = loc.qualitySafety;
                        }
                        return Opacity(
                          opacity: _fadeAnimations[i].value,
                          child: Transform.translate(
                            offset: _slideAnimations[i].value * 20,
                            child: _buildFeatureBox(context, icon, text),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],

                  const SizedBox(height: AppSpacing.lg),

                  // Кнопки входа и регистрации
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          text: loc.login,
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
                          color:
                              theme.colorScheme.surface.withOpacity(0.05),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: PrimaryButton(
                          text: loc.register,
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
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureBox(
      BuildContext context, IconData icon, String text) {
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
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor:
                theme.colorScheme.primary.withOpacity(0.2),
            child: Icon(icon, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: AppSpacing.sm),
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


