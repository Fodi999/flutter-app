import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sushi_app/models/user.dart';
import 'package:sushi_app/models/menu_item.dart';
import 'package:sushi_app/models/cart.dart';

import 'package:sushi_app/services/user_service.dart';
import 'package:sushi_app/services/menu_service.dart';
import 'package:sushi_app/services/cart_service.dart';
import 'package:sushi_app/state/cart_state.dart';
import 'package:sushi_app/utils/log_helper.dart';
import 'package:sushi_app/widgets/ad_banner_slider.dart';

import 'package:sushi_app/widgets/profile_app_bar.dart';
import 'package:sushi_app/widgets/profile_tips_dialog.dart';
import 'package:sushi_app/widgets/user_and_menu_loader.dart';
import 'package:sushi_app/widgets/profile_content.dart';
import 'package:sushi_app/widgets/order_history_tab.dart';

import 'components/cart_sidebar.dart';
import 'components/cart_bottom_sheet.dart';
import 'components/order_confirmation_screen.dart';

const String wsAdsUrl = 'ws://localhost:8000/ws/ads/stream'; // или прод адрес

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
    _tabController = TabController(length: 3, vsync: this);

    _userFuture = UserService.getUserById(widget.userId, widget.token).then((u) {
      _nameC.text = u.name;
      _emailC.text = u.email;
      _phoneC.text = u.phone;
      _addressC.text = u.address;
      _bioC.text = u.bio;
      _birthdayC.text = u.birthday;
      return u;
    });

    _menuFuture = MenuService.getMenuWithCategory(widget.token);
    _loadCart();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ProfileTipsDialog.showIfNeeded(context);
      logInfo('👤 Профиль открыт для пользователя ${widget.userId}', tag: 'ProfileScreen');
    });
  }

  Future<void> _loadCart() async {
    try {
      final cart = await CartService.getCart(
        userId: widget.userId,
        token: widget.token,
      );
      ref.read(cartStateProvider.notifier).set(cart.items);
    } catch (e, st) {
      logError('Ошибка загрузки корзины', tag: 'Cart', error: e, stackTrace: st);
    }
  }

  Future<void> _addToCart(MenuItem item, {Map<String, dynamic> options = const {}}) async {
    try {
      await CartService.addToCart(
        userId: widget.userId,
        token: widget.token,
        menuItemId: item.id,
        name: item.name,
        quantity: 1,
        price: item.price,
        options: options,
      );
      await _loadCart();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${item.name} добавлен в корзину')),
      );
    } catch (e) {
      logError('Не удалось добавить в корзину: ${item.name}', tag: 'Cart', error: e);
    }
  }

  void _openCart(User user) {
    final items = ref.read(cartStateProvider);
    if (items.isEmpty) return;

    void _toConfirm(CartItem _, User u) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OrderConfirmationScreen(
            cartItems: List<CartItem>.from(items),
            token: widget.token,
            user: u,
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

  Future<void> _saveProfile() async {
    final data = {
      'name': _nameC.text,
      'email': _emailC.text,
      'phone': _phoneC.text,
      'address': _addressC.text,
      'bio': _bioC.text,
      'birthday': _birthdayC.text,
    };

    try {
      await UserService.updateUserById(widget.userId, data, widget.token);
      if (mounted) {
        setState(() => _editMode = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Профиль обновлён')),
        );
      }
    } catch (e) {
      logError('Ошибка при обновлении профиля', tag: 'ProfileScreen', error: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = _isDark ? _darkTheme : _lightTheme;

    return Theme(
      data: theme,
      child: UserAndMenuLoader(
        userFuture: _userFuture,
        menuFuture: _menuFuture,
        builder: (ctx, user, menu) {
          final visibleMenu = menu.where((m) => m.published).toList();
          return Scaffold(
            appBar: ProfileAppBar(
              editMode: _editMode,
              isDark: _isDark,
              onToggleEdit: () => setState(() => _editMode = !_editMode),
              onToggleTheme: () => setState(() => _isDark = !_isDark),
              onLogout: () => Navigator.pop(context),
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
              onCancelEdit: () => setState(() => _editMode = false),
              onAddToCart: _addToCart,
              adBanner: const AdBannerSlider(), // ✅ добавлено
              orderHistoryTab: OrderHistoryTab(
                userId: widget.userId,
                token: widget.token,
                onOpenCart: () => _openCart(user),
              ),
            ),
          );
        },
      ),
    );
  }

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
}









