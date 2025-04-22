import 'package:flutter/material.dart';

class MenuItemForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descController;
  final TextEditingController imageController;
  final TextEditingController priceController;
  final VoidCallback onAddIngredient;

  const MenuItemForm({
    Key? key,
    required this.nameController,
    required this.descController,
    required this.imageController,
    required this.priceController,
    required this.onAddIngredient,
  }) : super(key: key);

  Widget _buildTextField(
      TextEditingController c, String label, bool number) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
        keyboardType:
            number ? TextInputType.number : TextInputType.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 24),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Добавить блюдо',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildTextField(nameController, 'Название', false),
            _buildTextField(descController, 'Описание', false),
            _buildTextField(imageController, 'Ссылка на фото', false),
            _buildTextField(priceController, 'Цена', true),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Добавить ингредиент'),
              onPressed: onAddIngredient,
            ),
          ],
        ),
      ),
    );
  }
}
