import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../services/user_service.dart';
import 'components/dashboard/email_search_field.dart';
import 'components/user/user_card.dart';

class ManageUsersScreen extends StatefulWidget {
  final String token;

  const ManageUsersScreen({super.key, required this.token});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  late Future<List<User>> _usersFuture;
  List<User> allUsers = [];
  List<User> filteredUsers = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() {
    _usersFuture = UserService.getAllUsers(widget.token);
    _usersFuture.then((users) {
      setState(() {
        allUsers = users;
        filteredUsers = users;
      });
    });
  }

  Future<void> _deleteUser(String id) async {
    try {
      await UserService.deleteUser(id, widget.token);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пользователь удалён')),
      );
      _loadUsers();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка удаления: $e')),
      );
    }
  }

  Future<void> _changeUserRole(User user, String newRole) async {
    try {
      await UserService.updateUserRole(user.id, newRole, widget.token);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Роль обновлена на $newRole')),
      );
      _loadUsers();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка обновления роли: $e')),
      );
    }
  }

  void _filterByEmail(String email) {
    setState(() {
      filteredUsers = allUsers
          .where((user) => user.email.toLowerCase().contains(email.toLowerCase()))
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
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Нет пользователей'));
          }

          return Column(
            children: [
              EmailSearchField(
                controller: _searchController,
                onChanged: _filterByEmail,
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = filteredUsers[index];
                    return UserCard(
                      user: user,
                      onDelete: () => _deleteUser(user.id),
                      onRoleChange: (role) => _changeUserRole(user, role),
                      index: index,
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
