import 'package:flutter/material.dart';
import 'package:sushi_app/models/user.dart';

class ProfileHeader extends StatelessWidget {
  final User user;
  final bool isDark;

  const ProfileHeader({super.key, required this.user, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: isDark
              ? [Colors.green.shade900, Colors.black]
              : [Colors.lightGreenAccent, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white,
            child: Text(
              user.avatarLetter,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.name,
                  style:
                      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(user.email),
              Text('Роль: ${user.role}', style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }
}
