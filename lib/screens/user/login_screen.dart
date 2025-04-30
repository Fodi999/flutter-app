import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

// widgets
import 'package:sushi_app/components/custom_input.dart';
import 'package:sushi_app/components/primary_button.dart';

// models / services
import 'package:sushi_app/models/user.dart';
import 'package:sushi_app/services/auth_service.dart';
import 'package:sushi_app/services/user_service.dart';

// screens
import 'package:sushi_app/screens/admin/admin_dashboard.dart';
import 'package:sushi_app/screens/user/profile_screen.dart';

// theme
import 'package:sushi_app/theme/app_spacing.dart';
import 'package:sushi_app/theme/locale_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _pass  = TextEditingController();

  bool   _loading = false;
  String? _error;

  Future<void> _handleLogin() async {
    // блокируем кнопку
    setState(() {
      _loading = true;
      _error   = null;
    });

    try {
      final email    = _email.text.trim();
      final password = _pass.text;

      final res   = await AuthService.login(email, password);
      final token = res['token'] as String;
      final id    = res['id']    as String;
      final role  = res['role']  as String;

      if (!mounted) return;

      if (role == 'admin') {
        final admin = User(
          id           : id,
          name         : 'Admin',
          email        : email,
          phone        : '',
          role         : role,
          address      : '',
          bio          : '',
          birthday     : '',
          createdAt    : DateTime.now(),
          lastActive   : DateTime.now(),
          online       : true,
          orders       : 0,
          avatarLetter : 'A',
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => AdminDashboard(user: admin, token: token),
          ),
        );
      } else {
        final user = await UserService.getUserById(id, token);
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ProfileScreen(userId: user.id, token: token),
          ),
        );
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }

    // разблокируем кнопку
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final loc            = AppLocalizations.of(context)!;
    final theme          = Theme.of(context);
    final cs             = theme.colorScheme;
    final dt             = theme.textTheme;
    final localeProvider = context.watch<LocaleProvider>();
    final isRu           = localeProvider.locale.languageCode == 'ru';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: cs.primary),
        actions: [
          IconButton(
            onPressed: localeProvider.toggleLocale,
            icon: Text(isRu ? '🇷🇺' : '🇬🇧', style: const TextStyle(fontSize: 24)),
            tooltip: isRu ? loc.switchToEnglish : loc.switchToRussian,
          ),
          IconButton(
            onPressed: widget.onToggleTheme,
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: cs.primary,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg * 1.5,
              vertical:   AppSpacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(loc.login, textAlign: TextAlign.center, style: dt.displayLarge),
                const SizedBox(height: AppSpacing.xs),
                Text(loc.loginSubtitle, textAlign: TextAlign.center, style: dt.bodyMedium),
                const SizedBox(height: AppSpacing.xl),

                // email
                CustomInput(
                  controller  : _email,
                  label       : loc.email,
                  hintText    : loc.enterEmail,
                  prefixIcon  : const Icon(Icons.email),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: AppSpacing.md),

                // password
                CustomInput(
                  controller : _pass,
                  label      : loc.password,
                  hintText   : loc.enterPassword,
                  prefixIcon : const Icon(Icons.lock),
                  obscureText: true,
                ),
                const SizedBox(height: AppSpacing.lg),

                // сообщение об ошибке
                if (_error != null) ...[
                  Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: cs.error),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],

                // кнопка входа
                PrimaryButton(
                  text: loc.login,
                  // всегда передаём ненулевой VoidCallback
                  onPressed: () {
                    if (_loading) return;      // игнор повторного нажатия
                    _handleLogin();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
