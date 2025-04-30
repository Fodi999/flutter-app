import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:sushi_app/components/custom_input.dart';
import 'package:sushi_app/components/primary_button.dart';
import 'package:sushi_app/screens/user/login_screen.dart';
import 'package:sushi_app/screens/user/profile_screen.dart';
import 'package:sushi_app/services/auth_service.dart';
import 'package:sushi_app/theme/app_sizes.dart';
import 'package:sushi_app/theme/locale_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controllers
  final _nameController     = TextEditingController();
  final _emailController    = TextEditingController();
  final _phoneController    = TextEditingController();
  final _passwordController = TextEditingController();

  // State
  bool   _isLoading = false;
  String? _error;

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _error     = null;
    });

    try {
      await AuthService.register(
        name     : _nameController.text.trim(),
        email    : _emailController.text.trim(),
        phone    : _phoneController.text.trim(),
        password : _passwordController.text,
      );

      final response = await AuthService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ProfileScreen(
            userId: response['id'],
            token : response['token'],
          ),
        ),
      );
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr            = AppLocalizations.of(context)!;
    final theme         = Theme.of(context);
    final textColor     = theme.textTheme.bodyLarge?.color ?? Colors.white;
    final fadedTextColor= textColor.withAlpha((0.6 * 255).round());
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isRussian      = localeProvider.locale.languageCode == 'ru';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(tr.register),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: localeProvider.toggleLocale,
            icon: Text(isRussian ? '🇷🇺' : '🇬🇧', style: const TextStyle(fontSize: 24)),
            tooltip: isRussian ? tr.switchToEnglish : tr.switchToRussian,
          ),
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
              horizontal: AppSizes.paddingXL,
              vertical:   AppSizes.paddingL,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSizes.spacingXL),

                CustomInput(
                  controller: _nameController,
                  label     : tr.name,
                  hintText  : tr.enterName,
                ),
                const SizedBox(height: AppSizes.spacingM),

                CustomInput(
                  controller   : _emailController,
                  label        : tr.email,
                  hintText     : tr.enterEmail,
                  keyboardType : TextInputType.emailAddress,
                  prefixIcon   : const Icon(Icons.email),
                ),
                const SizedBox(height: AppSizes.spacingM),

                CustomInput(
                  controller   : _phoneController,
                  label        : tr.phone,
                  hintText     : tr.enterPhone,
                  keyboardType : TextInputType.phone,
                  prefixIcon   : const Icon(Icons.phone),
                ),
                const SizedBox(height: AppSizes.spacingM),

                CustomInput(
                  controller  : _passwordController,
                  label       : tr.password,
                  hintText    : tr.createPassword,
                  obscureText : true,
                  prefixIcon  : const Icon(Icons.lock),
                ),
                const SizedBox(height: AppSizes.spacingS),

                Text(
                  tr.passwordRequirements,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: fadedTextColor),
                ),
                const SizedBox(height: AppSizes.spacingL),

                if (_error != null) ...[
                  Text(_error!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.redAccent)),
                  const SizedBox(height: AppSizes.spacingS),
                ],

                PrimaryButton(
                  text     : tr.register,
                  onPressed: () {
                    if (!_isLoading) _register();
                  },
                  fullWidth: true,
                ),

                const SizedBox(height: AppSizes.spacingL),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LoginScreen(
                          isDarkMode    : widget.isDarkMode,
                          onToggleTheme: widget.onToggleTheme,
                        ),
                      ),
                    );
                  },
                  child: Text(tr.alreadyHaveAccount, style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




