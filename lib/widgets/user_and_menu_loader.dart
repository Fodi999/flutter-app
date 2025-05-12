import 'package:flutter/material.dart';
import 'package:sushi_app/models/user.dart';
import 'package:sushi_app/models/menu_item.dart';
import 'package:sushi_app/utils/log_helper.dart'; // ✅ подключение логгера

/// Загружает пользователя и меню, и передаёт их в builder.
/// Показывает CircularProgressIndicator, пока идёт загрузка,
/// и ошибку, если один из Futures завершился с ошибкой.
class UserAndMenuLoader extends StatelessWidget {
  final Future<User> userFuture;
  final Future<List<MenuItem>> menuFuture;
  final Widget Function(BuildContext context, User user, List<MenuItem> menu) builder;

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
          logError('Ошибка загрузки пользователя: ${snapUser.error}', tag: 'UserAndMenuLoader');
          return Center(child: Text('Ошибка загрузки профиля: ${snapUser.error}'));
        }

        final user = snapUser.data!;
        logInfo('✅ Пользователь загружен: ${user.email}', tag: 'UserAndMenuLoader');

        return FutureBuilder<List<MenuItem>>(
          future: menuFuture,
          builder: (ctx2, snapMenu) {
            if (snapMenu.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapMenu.hasError || !snapMenu.hasData) {
              logError('Ошибка загрузки меню: ${snapMenu.error}', tag: 'UserAndMenuLoader');
              return Center(child: Text('Ошибка загрузки меню: ${snapMenu.error}'));
            }

            logInfo('✅ Меню успешно загружено. Кол-во: ${snapMenu.data!.length}', tag: 'UserAndMenuLoader');
            return builder(ctx2, user, snapMenu.data!);
          },
        );
      },
    );
  }
}

