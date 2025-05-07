// lib/widgets/user_and_menu_loader.dart

import 'package:flutter/material.dart';
import 'package:sushi_app/models/user.dart';
import 'package:sushi_app/models/menu_item.dart';

/// Загружает пользователя и меню, и передаёт их в builder.
/// Показывает CircularProgressIndicator, пока идёт загрузка,
/// и ошибку, если один из Futures завершился с ошибкой.
class UserAndMenuLoader extends StatelessWidget {
  final Future<User> userFuture;
  final Future<List<MenuItem>> menuFuture;
  final Widget Function(BuildContext context, User user, List<MenuItem> menu)
      builder;

  const UserAndMenuLoader({
    Key? key,
    required this.userFuture,
    required this.menuFuture,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: userFuture,
      builder: (ctx, snapUser) {
        if (snapUser.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapUser.hasError || !snapUser.hasData) {
          return Center(child: Text('Ошибка загрузки профиля: ${snapUser.error}'));
        }
        final user = snapUser.data!;
        return FutureBuilder<List<MenuItem>>(
          future: menuFuture,
          builder: (ctx2, snapMenu) {
            if (snapMenu.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapMenu.hasError || !snapMenu.hasData) {
              return Center(child: Text('Ошибка загрузки меню: ${snapMenu.error}'));
            }
            return builder(ctx2, user, snapMenu.data!);
          },
        );
      },
    );
  }
}
