import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import 'login_screen.dart';
import 'profile_screen.dart';

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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Регистрация',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _buildInputField(controller: _nameController, hint: 'Имя'),
                const SizedBox(height: 16),
                _buildInputField(
                  controller: _emailController,
                  hint: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  controller: _phoneController,
                  hint: 'Телефон',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  controller: _passwordController,
                  hint: 'Пароль',
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                Text(
                  'Пароль должен быть не меньше 8 символов,\nсодержать цифру и заглавную букву',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: textColor.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 20),
                if (_error != null)
                  Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Зарегистрироваться'),
                ),
                const SizedBox(height: 20),
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
  }
}






