import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import '../../models/user.dart';
import '../admin/admin_dashboard.dart';
import 'profile_screen.dart';

class LoginScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const LoginScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _error;

  void _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await AuthService.login(email, password);
      final token = response['token'];
      final userId = response['id'];
      final role = response['role'];

      if (role == 'admin') {
        // "Мок" для админа, т.к. в базе может не быть всех данных
        final user = User(
          id: userId,
          name: 'Admin',
          email: email,
          phone: '',
          role: role,
          address: '',
          bio: '',
          birthday: '',
          createdAt: DateTime.now(),
          lastActive: DateTime.now(),
          online: true,
          orders: 0,
          avatarLetter: 'A',
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => AdminDashboard(user: user, token: token),
          ),
        );
      } else {
        // Получаем актуального пользователя
        final user = await UserService.getUserById(userId, token);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ProfileScreen(userId: user.id, token: token),
          ),
        );
      }
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: theme.colorScheme.primary),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Вход',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Введите email и пароль',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 24),

              // Email
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Пароль
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Пароль',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 24),

              if (_error != null)
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Войти'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}








