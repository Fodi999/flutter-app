import 'package:flutter/material.dart';

class EmailSearchField extends StatelessWidget {
  // 1️⃣ Сначала — конструктор
  const EmailSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  // 2️⃣ Затем — поля
  final TextEditingController controller;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: const InputDecoration(
          hintText: 'Поиск по email',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

