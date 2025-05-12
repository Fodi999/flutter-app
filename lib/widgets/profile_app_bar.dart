import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/cart_state.dart';           // 🛒 Riverpod-провайдер корзины
import '../utils/log_helper.dart';           // 🧾 Логгирование действий
import 'cart_button.dart';                   // 🧩 Виджет кнопки корзины

class ProfileAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final bool editMode;
  final bool isDark;
  final VoidCallback onToggleEdit;
  final VoidCallback onToggleTheme;
  final VoidCallback onLogout;
  final VoidCallback onOpenCart;

  const ProfileAppBar({
    super.key,
    required this.editMode,
    required this.isDark,
    required this.onToggleEdit,
    required this.onToggleTheme,
    required this.onLogout,
    required this.onOpenCart,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qty = ref.watch(cartStateProvider).totalQty;

    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.surface,
      foregroundColor: Theme.of(context).colorScheme.onSurface,
      title: const Text('Профиль'),
      actions: [
        Tooltip(
          message: editMode ? 'Отменить редактирование' : 'Редактировать профиль',
          waitDuration: const Duration(milliseconds: 500),
          child: IconButton(
            icon: Icon(editMode ? Icons.close : Icons.edit),
            onPressed: () {
              logInfo(
                editMode
                    ? 'Отмена редактирования профиля'
                    : 'Включено редактирование профиля',
                tag: 'ProfileAppBar',
              );
              onToggleEdit();
            },
          ),
        ),
        Tooltip(
          message: 'Переключить тему',
          waitDuration: const Duration(milliseconds: 500),
          child: IconButton(
            icon: Icon(isDark ? Icons.wb_sunny : Icons.nightlight),
            onPressed: () {
              logInfo(
                'Смена темы: ${isDark ? 'на светлую' : 'на тёмную'}',
                tag: 'ProfileAppBar',
              );
              onToggleTheme();
            },
          ),
        ),
        Tooltip(
          message: 'Выйти',
          waitDuration: const Duration(milliseconds: 500),
          child: IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              logWarning('Пользователь нажал выход из аккаунта', tag: 'ProfileAppBar');
              onLogout();
            },
          ),
        ),
        Tooltip(
          message: 'Открыть корзину',
          waitDuration: const Duration(milliseconds: 500),
          child: CartButton(
           
            onPressed: () {
              logInfo('Открытие корзины (кол-во: $qty)', tag: 'ProfileAppBar');
              onOpenCart();
            },
          ),
        ),
      ],
    );
  }
}




