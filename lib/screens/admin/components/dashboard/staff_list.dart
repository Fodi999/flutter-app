import 'package:flutter/material.dart';
import 'package:sushi_app/models/user.dart';

class StaffList extends StatefulWidget {
  // 1️⃣ Конструктор сразу после объявления класса
  const StaffList({super.key, required this.staff});

  // 2️⃣ Затем — поля
  final List<User> staff;

  @override
  State<StaffList> createState() => _StaffListState();
}

class _StaffListState extends State<StaffList> {
  final TextEditingController searchController = TextEditingController();
  List<User> filteredStaff = [];

  @override
  void initState() {
    super.initState();
    filteredStaff = widget.staff;
  }

  void _filter(String query) {
    setState(() {
      filteredStaff = widget.staff
          .where((u) => u.email.toLowerCase().contains(query.toLowerCase()))
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
            onChanged: _filter,
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredStaff.length,
            itemBuilder: (context, index) {
              final user = filteredStaff[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green.shade100,
                    child: Text(
                      user.avatarLetter,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
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

