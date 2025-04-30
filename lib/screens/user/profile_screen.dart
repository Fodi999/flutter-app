import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sushi_app/models/user.dart';
import 'package:sushi_app/models/menu_item.dart';
import 'package:sushi_app/services/user_service.dart';
import 'package:sushi_app/services/menu_service.dart';
import 'package:sushi_app/components/custom_card.dart';

// Наш компонент для карточки корзины
import 'components/cart_item_card.dart';

import 'components/profile_header.dart';
import 'components/editable_tabs.dart';
import 'components/profile_info.dart';
import 'components/grouped_menu.dart';
import 'components/dish_autocomplete_input.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.userId, required this.token});

  final String userId;
  final String token;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late final Future<User> _userFuture;
  late final Future<List<MenuItem>> _menuFuture;
  late final TabController _tabController;
  late final ScrollController _scrollController;

  bool _editMode = false;
  bool _isDark = false;

  // Состояние корзины
  final Map<MenuItem, int> _cart = {};

  // Контроллеры форм
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _bioController = TextEditingController();
  final _birthdayController = TextEditingController();

  // Темы
  final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF7FAF7),
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4CAF50)),
    cardColor: Colors.white.withOpacity(0.7),
  );
  final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF4CAF50),
      brightness: Brightness.dark,
    ),
    cardColor: Colors.grey[900]!.withOpacity(0.6),
  );

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _tabController = TabController(length: 2, vsync: this);

    _userFuture =
        UserService.getUserById(widget.userId, widget.token).then((user) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _phoneController.text = user.phone;
      _addressController.text = user.address;
      _bioController.text = user.bio;
      _birthdayController.text = user.birthday;
      return user;
    });

    _menuFuture = MenuService.getMenuWithCategory(widget.token);
    _showProfileTips();
  }

  Future<void> _showProfileTips() async {
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool('profile_tips_shown') ?? false) && mounted) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Советы по управлению профилем'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('✏ Нажмите на ✎, чтобы редактировать профиль.'),
              SizedBox(height: 8),
              Text('🌙 Нажмите на 🌞 или 🌙, чтобы переключить тему.'),
              SizedBox(height: 8),
              Text('🚪 Нажмите на 🚪, чтобы выйти из аккаунта.'),
              SizedBox(height: 8),
              Divider(),
              SizedBox(height: 8),
              Text(
                  '🏪 Хотите открыть свой бизнес онлайн? Смени профиль на бизнес-аккаунт!'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Понятно'),
            ),
          ],
        ),
      );
      await prefs.setBool('profile_tips_shown', true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _bioController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final data = {
      "name": _nameController.text,
      "email": _emailController.text,
      "phone": _phoneController.text,
      "address": _addressController.text,
      "bio": _bioController.text,
      "birthday": _birthdayController.text,
    };
    await UserService.updateUserById(widget.userId, data, widget.token);
    if (!mounted) return;
    setState(() => _editMode = false);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Профиль обновлён')));
  }

  void _addToCart(MenuItem item) {
    setState(() {
      _cart.update(item, (q) => q + 1, ifAbsent: () => 1);
    });
  }

  void _removeFromCart(MenuItem item) {
    setState(() => _cart.remove(item));
  }

  void _changeQuantity(MenuItem item, int delta) {
    setState(() {
      final current = _cart[item] ?? 0;
      final updated = (current + delta).clamp(0, 99);
      if (updated > 0) _cart[item] = updated;
      else _cart.remove(item);
    });
  }

  void _scrollToCart() {
    if (_cart.isEmpty) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = _isDark ? _darkTheme : _lightTheme;

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Профиль'),
          actions: [
            IconButton(
              onPressed: () => setState(() => _editMode = !_editMode),
              icon: Icon(_editMode ? Icons.close : Icons.edit),
            ),
            IconButton(
              onPressed: () => setState(() => _isDark = !_isDark),
              icon: Icon(_isDark ? Icons.wb_sunny : Icons.nightlight),
            ),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.logout),
            ),
            // Просто иконка корзины с бэйджем
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  onPressed: _scrollToCart,
                  icon: const Icon(Icons.shopping_cart),
                ),
                if (_cart.isNotEmpty)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        '${_cart.values.fold<int>(0, (sum, q) => sum + q)}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        body: FutureBuilder<User>(
          future: _userFuture,
          builder: (context, snapUser) {
            if (!snapUser.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final user = snapUser.data!;
            return FutureBuilder<List<MenuItem>>(
              future: _menuFuture,
              builder: (context, snapMenu) {
                final menu = snapMenu.data ?? [];
                return SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      ProfileHeader(user: user, isDark: _isDark),
                      const SizedBox(height: 20),
                      DishAutocompleteInput(
                        onSelected: (sel) => _addressController.text = sel,
                      ),
                      const SizedBox(height: 20),
                      CustomCard(
                        padding: const EdgeInsets.all(16),
                        child: _editMode
                            ? EditableTabs(
                                tabController: _tabController,
                                nameController: _nameController,
                                bioController: _bioController,
                                birthdayController: _birthdayController,
                                emailController: _emailController,
                                phoneController: _phoneController,
                                addressController: _addressController,
                                onSave: _saveProfile,
                                onCancel: () =>
                                    setState(() => _editMode = false),
                              )
                            : ProfileInfo(fields: {
                                'Email': user.email,
                                'Телефон': user.phone,
                                'Адрес': user.address,
                                'О себе': user.bio,
                                'День рождения': user.birthday,
                              }),
                      ),
                      if (!_editMode) GroupedMenu(
                        items: menu,
                        // передаём callback чтобы добавить в корзину
                        onAddToCart: _addToCart,
                      ),
                      if (_cart.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        Text('Ваша корзина',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 12),
                        for (var e in _cart.entries)
                          CartItemCard(
                            item: e.key,
                            quantity: e.value,
                            onRemove: () => _removeFromCart(e.key),
                            onIncrease: () => _changeQuantity(e.key, 1),
                            onDecrease: () => _changeQuantity(e.key, -1),
                          ),
                      ],
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}





