import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import '../../models/user.dart';
import '../admin/admin_dashboard.dart';
import 'profile_screen.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_sizes.dart';
import '../../theme/text_styles.dart';

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
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      final response = await AuthService.login(email, password);

      final token = response['token'];
      final userId = response['id'];
      final role = response['role'];

      if (role == 'admin') {
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

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.padding * 1.5,
              vertical: AppSizes.padding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Вход',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.displayLarge,
                ),
                const SizedBox(height: AppSizes.spacingXS),
                Text(
                  'Введите email и пароль для авторизации',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: AppSizes.spacingXL),

                _buildGlassInput(
                  controller: _emailController,
                  hintText: 'Email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: AppSizes.spacingM),

                _buildGlassInput(
                  controller: _passwordController,
                  hintText: 'Пароль',
                  icon: Icons.lock,
                  obscureText: true,
                ),
                const SizedBox(height: AppSizes.spacingL),

                if (_error != null)
                  Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.error),
                  ),

                const SizedBox(height: AppSizes.spacingM),
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSizes.padding,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusXL),
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
      ),
    );
  }

  Widget _buildGlassInput({
    required TextEditingController controller,
    required String hintText,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: AppTextStyles.bodyLarge.copyWith(color: theme.colorScheme.onSurface),
      decoration: InputDecoration(
        prefixIcon: icon != null
            ? Icon(icon, color: theme.colorScheme.primary)
            : null,
        hintText: hintText,
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: theme.hintColor),
        filled: true,
        fillColor: theme.colorScheme.surface.withOpacity(0.3),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.padding,
          vertical: AppSizes.padding,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}











