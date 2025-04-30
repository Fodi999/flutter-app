import 'package:flutter/material.dart';

class EditableTabs extends StatelessWidget {
  final TabController tabController;
  final TextEditingController nameController;
  final TextEditingController bioController;
  final TextEditingController birthdayController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const EditableTabs({
    super.key,
    required this.tabController,
    required this.nameController,
    required this.bioController,
    required this.birthdayController,
    required this.emailController,
    required this.phoneController,
    required this.addressController,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: tabController,
          labelColor: Theme.of(context).colorScheme.primary,
          tabs: const [
            Tab(text: 'Профиль'),
            Tab(text: 'Контакты'),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 400, // увеличено, чтобы не было overflow
          child: TabBarView(
            controller: tabController,
            children: [
              // Вкладка "Профиль"
              Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Имя'),
                  ),
                  TextField(
                    controller: bioController,
                    decoration: const InputDecoration(labelText: 'О себе'),
                  ),
                  TextField(
                    controller: birthdayController,
                    decoration: const InputDecoration(labelText: 'Дата рождения'),
                  ),
                ],
              ),
              // Вкладка "Контакты"
              Column(
                children: [
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: 'Телефон'),
                  ),
                  TextField(
                    controller: addressController,
                    decoration: const InputDecoration(labelText: 'Адрес'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            ElevatedButton(
              onPressed: onSave,
              child: const Text('Сохранить'),
            ),
            const SizedBox(width: 12),
            OutlinedButton(
              onPressed: onCancel,
              child: const Text('Отмена'),
            ),
          ],
        ),
      ],
    );
  }
}



