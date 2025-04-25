import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import '../../theme/app_sizes.dart';
import '../../components/custom_input.dart'; // ✅ подключён кастомный инпут
import '../../components/primary_button.dart'; // ✅ подключена кнопка

class RegisterScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const RegisterScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _error;

  void _register() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await AuthService.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
      );

      final response = await AuthService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      final token = response['token'];
      final userId = response['id'];

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ProfileScreen(userId: userId, token: token),
        ),
      );
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
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
        title: const Text('Регистрация'),
        centerTitle: true,
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
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingXL,
              vertical: AppSizes.paddingL,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: textColor,
                  ),
                  child: const Text(
                    '',
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: AppSizes.spacingXL),

                CustomInput(
                  controller: _nameController,
                  label: 'Имя',
                  hintText: 'Введите имя',
                ),
                const SizedBox(height: AppSizes.spacingM),

                CustomInput(
                  controller: _emailController,
                  label: 'Email',
                  hintText: 'example@mail.com',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email),
                ),
                const SizedBox(height: AppSizes.spacingM),

                CustomInput(
                  controller: _phoneController,
                  label: 'Телефон',
                  hintText: '+7...',
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.phone),
                ),
                const SizedBox(height: AppSizes.spacingM),

                CustomInput(
                  controller: _passwordController,
                  label: 'Пароль',
                  hintText: 'Придумайте пароль',
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock),
                ),
                const SizedBox(height: AppSizes.spacingS),

                Text(
                  'Пароль должен быть не меньше 8 символов,\nсодержать цифру и заглавную букву',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: textColor.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: AppSizes.spacingL),

                if (_error != null)
                  Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                const SizedBox(height: AppSizes.spacingS),

                PrimaryButton(
                  text: 'Зарегистрироваться',
                  onPressed: _isLoading ? () {} : _register,
                  fullWidth: true,
                ),

                const SizedBox(height: AppSizes.spacingL),
                TextButton(
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
                  child: Text(
                    'Уже есть аккаунт? Войти',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}









