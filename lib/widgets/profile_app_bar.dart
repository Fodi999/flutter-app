// lib/widgets/profile_app_bar.dart
//
// • Показывает количество товаров прямо из Riverpod-состояния корзины.
// • Достаточно вызвать ProfileAppBar без передачи cartCount –
//   число возьмётся из `cartStateProvider`.
// • Прежний параметр cartCount оставлен (опц.) на случай,
//
//     ProfileAppBar(cartCount: fallbackQty, …)
//
//   но при наличии Riverpod-состояния он будет игнорироваться.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/cart_state.dart';      //  ←  provider корзины
import 'cart_button.dart';

class ProfileAppBar extends ConsumerWidget
    implements PreferredSizeWidget {
  final bool editMode;
  final bool isDark;
  final VoidCallback onToggleEdit;
  final VoidCallback onToggleTheme;
  final VoidCallback onLogout;

  /// Опционально (для обратной совместимости).  
  /// Если не задан, берётся из cartStateProvider.
  final int? cartCount;

  final VoidCallback onOpenCart;

  const ProfileAppBar({
    super.key,
    required this.editMode,
    required this.isDark,
    required this.onToggleEdit,
    required this.onToggleTheme,
    required this.onLogout,
    required this.onOpenCart,
    this.cartCount,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // qty из Riverpod-состояния; если null – используем переданный cartCount
    final qty = ref.watch(cartStateProvider).totalQty;
    final displayQty = cartCount ?? qty;

    return AppBar(
      title: const Text('Профиль'),
      actions: [
        IconButton(
          onPressed: onToggleEdit,
          icon: Icon(editMode ? Icons.close : Icons.edit),
          tooltip: editMode ? 'Отменить' : 'Редактировать профиль',
        ),
        IconButton(
          onPressed: onToggleTheme,
          icon: Icon(isDark ? Icons.wb_sunny : Icons.nightlight),
          tooltip: 'Переключить тему',
        ),
        IconButton(
          onPressed: onLogout,
          icon: const Icon(Icons.logout),
          tooltip: 'Выйти',
        ),
        // Кнопка корзины
        CartButton(
          count: displayQty,
          onPressed: onOpenCart,
        ),
      ],
    );
  }
}

