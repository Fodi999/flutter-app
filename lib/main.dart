import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sushi_app/utils/log_helper.dart';
import 'theme/theme_light.dart';
import 'theme/theme_dark.dart';
import 'theme/theme_provider.dart';

import 'screens/user/splash_screen.dart';
import 'screens/user/profile_screen.dart';
import 'screens/user/components/order_history_screen.dart';

final themeProvider = ChangeNotifierProvider<ThemeProvider>((ref) => ThemeProvider());

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    logError('Flutter Error', error: details.exception, stackTrace: details.stack);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    logError('Uncaught Platform Error', error: error, stackTrace: stack);
    return true;
  };

  runZonedGuarded(() {
    runApp(const ProviderScope(child: SushiApp()));
  }, (error, stack) {
    logError('Uncaught Zone Error', error: error, stackTrace: stack);
  });
}

class SushiApp extends ConsumerWidget {
  const SushiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeProv = ref.watch(themeProvider);

    logInfo('🚀 Запуск приложения SushiApp', tag: 'Main');

    return MaterialApp(
      title: 'Sushi App',
      debugShowCheckedModeBanner: false,
      themeMode: themeProv.themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(
              isDarkMode: themeProv.themeMode == ThemeMode.dark,
              onToggleTheme: () => ref.read(themeProvider).toggleTheme(),
            ),

        '/profile': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          if (args is! Map<String, dynamic> || args['userId'] == null || args['token'] == null) {
            throw FlutterError('Маршрут /profile требует аргументы: userId и token');
          }
          return ProfileScreen(
            userId: args['userId'] as String,
            token: args['token'] as String,
          );
        },

        '/order-history': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          if (args is! Map<String, dynamic> || args['userId'] == null || args['token'] == null) {
            throw FlutterError('Маршрут /order-history требует аргументы: userId и token');
          }
          return OrderHistoryScreen(
            userId: args['userId'] as String,
            token: args['token'] as String,
          );
        },
      },
    );
  }
}

















