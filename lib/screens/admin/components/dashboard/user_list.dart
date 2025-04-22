import 'package:flutter/material.dart';
import '../../../models/user.dart';
import '../../../services/user_service.dart'; // ✅ обновлённый импорт

class UserList extends StatefulWidget {
  final String token;

  const UserList({super.key, required this.token});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<User> allUsers = [];
  List<User> filteredUsers = [];
  final TextEditingController searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final users = await UserService.getAllUsers(widget.token);
      setState(() {
        allUsers = users;
        filteredUsers = users;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('❌ Ошибка загрузки пользователей: $e');
      setState(() => isLoading = false);
    }
  }

  void _filterUsers(String query) {
    final lower = query.toLowerCase();
    setState(() {
      filteredUsers = allUsers
          .where((user) => user.email.toLowerCase().contains(lower))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              hintText: 'Поиск по email',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: _filterUsers,
          ),
        ),
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green.shade100,
                      child: Text(user.avatarLetter),
                    ),
                    title: Text('${user.name} (${user.role})'),
                    subtitle: Text(user.email),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

