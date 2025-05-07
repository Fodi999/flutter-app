import 'package:flutter/material.dart';

class MenuItemForm extends StatelessWidget {
  const MenuItemForm({
    super.key,
    required this.nameController,
    required this.descController,
    required this.imageController,
    required this.priceController,
    required this.onAddIngredient,
    required this.formKey,
  });

  final TextEditingController nameController;
  final TextEditingController descController;
  final TextEditingController imageController;
  final TextEditingController priceController;
  final VoidCallback onAddIngredient;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    final imageUrl = imageController.text.trim();

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 24),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Шаг 1. Основная информация о блюде',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Название блюда',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Введите название'
                    : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: 'Описание',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: imageController,
                decoration: const InputDecoration(
                  labelText: 'Ссылка на изображение',
                  hintText: 'https://...',
                  border: OutlineInputBorder(),
                ),
              ),
              if (imageUrl.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageUrl,
                      height: 150,
                      errorBuilder: (_, __, ___) =>
                          const Text('Невозможно загрузить изображение'),
                    ),
                  ),
                ),
              const SizedBox(height: 12),

              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Цена продажи',
                  suffixText: '₽',
                  border: OutlineInputBorder(),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (val) {
                  final parsed = double.tryParse(val ?? '');
                  if (parsed == null || parsed <= 0) {
                    return 'Введите корректную цену';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Добавить ингредиент'),
                  onPressed: onAddIngredient,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


