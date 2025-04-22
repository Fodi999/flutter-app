import 'package:flutter/material.dart';
import '../../../../models/user.dart';
import 'role_translator.dart';

class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback onDelete;
  final void Function(String) onRoleChange;
  final int index;

  const UserCard({
    super.key,
    required this.user,
    required this.onDelete,
    required this.onRoleChange,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: 1,
      duration: Duration(milliseconds: 300 + index * 100),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.only(bottom: 20),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.green.shade100,
                    child: Text(
                      user.avatarLetter,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${user.name} (${translateRoleToEN(user.role)})',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(user.email, style: const TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _infoRow(Icons.vpn_key, 'ID: ${user.id}'),
              _infoRow(Icons.phone, user.phone),
              if (user.address != null)
                _infoRow(Icons.home, 'Address: ${user.address!}'),
              if (user.bio != null)
                _infoRow(Icons.info_outline, 'About: ${user.bio!}'),
              if (user.birthday != null)
                _infoRow(Icons.cake, 'Birthday: ${user.birthday!}'),
              _infoRow(Icons.calendar_today, 'Created: ${user.createdAt}'),
              _infoRow(Icons.access_time, 'Last active: ${user.lastActive}'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: user.role,
                      decoration: const InputDecoration(
                        labelText: 'Role',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'admin', child: Text('Admin')),
                        DropdownMenuItem(value: 'user', child: Text('User')),
                        DropdownMenuItem(value: 'повар', child: Text('Chef')),
                        DropdownMenuItem(value: 'курьер', child: Text('Courier')),
                        DropdownMenuItem(value: 'официант', child: Text('Waiter')),
                      ],
                      onChanged: (newRole) {
                        if (newRole != null && newRole != user.role) {
                          onRoleChange(newRole);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Подтверждение'),
                            content: const Text(
                              'Вы точно хотите безвозвратно удалить пользователя?',
                            ),
                            actions: [
                              TextButton(
                                child: const Text('Отмена'),
                                onPressed: () => Navigator.of(ctx).pop(),
                              ),
                              TextButton(
                                child: const Text(
                                  'Удалить',
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                  onDelete();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text('Удалить'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}

