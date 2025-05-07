// lib/screens/user/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sushi_app/models/user.dart';
import 'package:sushi_app/models/menu_item.dart';
import 'package:sushi_app/models/cart.dart';

import 'package:sushi_app/services/user_service.dart';
import 'package:sushi_app/services/menu_service.dart';
import 'package:sushi_app/services/cart_service.dart';

import 'package:sushi_app/state/cart_state.dart';

import 'package:sushi_app/widgets/profile_app_bar.dart';
import 'package:sushi_app/widgets/profile_tips_dialog.dart';
import 'package:sushi_app/widgets/user_and_menu_loader.dart';
import 'package:sushi_app/widgets/profile_content.dart';

import 'components/cart_sidebar.dart';
import 'components/cart_bottom_sheet.dart';
import 'components/order_confirmation_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({
    super.key,
    required this.userId,
    required this.token,
  });

  final String userId;
  final String token;

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late final Future<User> _userFuture;
  late final Future<List<MenuItem>> _menuFuture;
  late final TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  bool _editMode = false;
  bool _isDark = false;

  final _nameC = TextEditingController();
  final _emailC = TextEditingController();
  final _phoneC = TextEditingController();
  final _addressC = TextEditingController();
  final _bioC = TextEditingController();
  final _birthdayC = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Загружаем профиль
    _userFuture =
        UserService.getUserById(widget.userId, widget.token).then((u) {
      _nameC.text = u.name;
      _emailC.text = u.email;
      _phoneC.text = u.phone;
      _addressC.text = u.address;
      _bioC.text = u.bio;
      _birthdayC.text = u.birthday;
      return u;
    });

    // Загружаем меню
    _menuFuture = MenuService.getMenuWithCategory(widget.token);

    // Синхронизируем корзину
    _loadCart();

    // Показываем советы, если нужно
    WidgetsBinding.instance
        .addPostFrameCallback((_) => ProfileTipsDialog.showIfNeeded(context));
  }

  /// Загружает корзину с сервера и обновляет провайдер
  Future<void> _loadCart() async {
    final cart = await CartService.getCart(
      userId: widget.userId,
      token: widget.token,
    );
    ref.read(cartStateProvider.notifier).set(cart.items);
  }

  /// Добавляет товар и перезагружает корзину
  Future<void> _addToCart(MenuItem item) async {
    await CartService.addToCart(
      userId: widget.userId,
      token: widget.token,
      menuItemId: item.id,
      name: item.name,
      quantity: 1,
      price: item.price,
    );
    await _loadCart();
  }

  /// Увеличивает количество и перезагружает корзину
  Future<void> _increase(CartItem ci) async {
    await CartService.updateCartItem(
      userId: widget.userId,
      token: widget.token,
      menuItemId: ci.menuItemId,
      quantity: ci.quantity + 1,
    );
    await _loadCart();
  }

  /// Уменьшает количество (или удаляет) и перезагружает корзину
  Future<void> _decrease(CartItem ci) async {
    if (ci.quantity > 1) {
      await CartService.updateCartItem(
        userId: widget.userId,
        token: widget.token,
        menuItemId: ci.menuItemId,
        quantity: ci.quantity - 1,
      );
    } else {
      await CartService.removeCartItem(
        userId: widget.userId,
        token: widget.token,
        menuItemId: ci.menuItemId,
      );
    }
    await _loadCart();
  }

  /// Удаляет позицию и перезагружает корзину
  Future<void> _remove(CartItem ci) async {
    await CartService.removeCartItem(
      userId: widget.userId,
      token: widget.token,
      menuItemId: ci.menuItemId,
    );
    await _loadCart();
  }

  /// Открывает CartSidebar или CartBottomSheet
  void _openCart(User user) {
    final items = ref.read(cartStateProvider);
    if (items.isEmpty) return;

    void _toConfirm(CartItem _, User u) {
      final total = ref.read(cartStateProvider.notifier).totalSum;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OrderConfirmationScreen(
  cartItems: List<CartItem>.from(items),
  user: u,
  token: widget.token,
),
        ),
      );
    }

    final isWide = MediaQuery.of(context).size.width >= 800;
    if (isWide) {
      showDialog(
        context: context,
        builder: (_) => CartSidebar(
          user: user,
          onCheckout: _toConfirm,
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => CartBottomSheet(
          user: user,
          onCheckout: _toConfirm,
        ),
      );
    }
  }

  /// Сохраняет профиль
  Future<void> _saveProfile() async {
    final data = {
      'name': _nameC.text,
      'email': _emailC.text,
      'phone': _phoneC.text,
      'address': _addressC.text,
      'bio': _bioC.text,
      'birthday': _birthdayC.text,
    };
    await UserService.updateUserById(widget.userId, data, widget.token);
    if (mounted) {
      setState(() => _editMode = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Профиль обновлён')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = _isDark ? _darkTheme : _lightTheme;
    final cartQty =
        ref.watch(cartStateProvider.select((s) => s.totalQty));

    return Theme(
      data: theme,
      child: UserAndMenuLoader(
        userFuture: _userFuture,
        menuFuture: _menuFuture,
        builder: (ctx, user, menu) {
          final visibleMenu =
              menu.where((m) => m.published).toList();
          return Scaffold(
            appBar: ProfileAppBar(
              editMode: _editMode,
              isDark: _isDark,
              onToggleEdit: () =>
                  setState(() => _editMode = !_editMode),
              onToggleTheme: () =>
                  setState(() => _isDark = !_isDark),
              onLogout: () => Navigator.pop(context),
              cartCount: cartQty,
              onOpenCart: () => _openCart(user),
            ),
            body: ProfileContent(
              user: user,
              menu: visibleMenu,
              editMode: _editMode,
              isDark: _isDark,
              tabController: _tabController,
              scrollController: _scrollController,
              nameController: _nameC,
              emailController: _emailC,
              phoneController: _phoneC,
              addressController: _addressC,
              bioController: _bioC,
              birthdayController: _birthdayC,
              onSaveProfile: _saveProfile,
              onCancelEdit: () =>
                  setState(() => _editMode = false),
              onAddToCart: _addToCart,
            ),
          );
        },
      ),
    );
  }

  final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF7FAF7),
    colorScheme:
        ColorScheme.fromSeed(seedColor: const Color(0xFF4CAF50)),
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
}



