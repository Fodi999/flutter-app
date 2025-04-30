import 'package:flutter/material.dart';
import 'package:sushi_app/models/user.dart';
import 'package:sushi_app/services/user_service.dart';
import 'components/dashboard/email_search_field.dart';
import 'components/user/user_card.dart';

class ManageUsersScreen extends StatefulWidget {
  // 1️⃣ Конструктор сразу после объявления класса
  const ManageUsersScreen({super.key, required this.token});

  // 2️⃣ Поле
  final String token;

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  late Future<List<User>> _usersFuture;
  List<User> _allUsers = [];
  List<User> _filteredUsers = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    _searchController.addListener(() {
      _filterByEmail(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchUsers() async {
    _usersFuture = UserService.getAllUsers(widget.token);
    try {
      final users = await _usersFuture;
      if (!mounted) return;
      setState(() {
        _allUsers = users;
        _filteredUsers = users;
      });
    } catch (_) {
      // Ошибку здесь можно залогировать, если нужно
    }
  }

  Future<void> _deleteUser(String id) async {
    try {
      await UserService.deleteUser(id, widget.token);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пользователь удалён')),
      );
      await _fetchUsers();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка удаления: $e')),
      );
    }
  }

  Future<void> _changeUserRole(User user, String newRole) async {
    try {
      await UserService.updateUserRole(user.id, newRole, widget.token);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Роль обновлена на $newRole')),
      );
      await _fetchUsers();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка обновления роли: $e')),
      );
    }
  }

  void _filterByEmail(String email) {
    final q = email.toLowerCase();
    setState(() {
      _filteredUsers = _allUsers
          .where((u) => u.email.toLowerCase().contains(q))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<User>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }
          // snapshot.data всегда не-null здесь, т.к. будущий список загружен
          return Column(
            children: [
              EmailSearchField(
                controller: _searchController,
                onChanged: _filterByEmail,
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = _filteredUsers[index];
                    return UserCard(
                      user: user,
                      index: index,
                      onDelete: () => _deleteUser(user.id),
                      onRoleChange: (role) => _changeUserRole(user, role),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

