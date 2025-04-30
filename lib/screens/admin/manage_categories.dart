import 'package:flutter/material.dart';
import 'package:sushi_app/models/category.dart';
import 'package:sushi_app/services/category_service.dart';
import 'package:sushi_app/screens/admin/manage_menu_items.dart';

class ManageCategoriesScreen extends StatefulWidget {
  const ManageCategoriesScreen({super.key, required this.token});

  final String token;

  @override
  State<ManageCategoriesScreen> createState() => _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState extends State<ManageCategoriesScreen> {
  late Future<List<Category>> _categoriesFuture;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() {
    _categoriesFuture = CategoryService.getCategories(widget.token);
  }

  void _showSnackBar(String message, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _createCategory() async {
    if (_formKey.currentState!.validate()) {
      try {
        await CategoryService.createCategory(
          _nameController.text.trim(),
          widget.token,
        );
        _nameController.clear();
        _showSnackBar('Категория создана');
        setState(() => _loadCategories());
      } catch (e) {
        _showSnackBar('Ошибка при создании категории: $e', error: true);
      }
    }
  }

  Future<void> _deleteCategory(String id) async {
    try {
      await CategoryService.deleteCategory(id, widget.token);
      _showSnackBar('Категория удалена');
      setState(() => _loadCategories());
    } catch (e) {
      _showSnackBar('Ошибка при удалении категории: $e', error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Категории меню',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Новая категория',
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) =>
                        val == null || val.trim().isEmpty ? 'Введите название' : null,
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _createCategory,
                  child: const Text('Добавить'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: FutureBuilder<List<Category>>(
              future: _categoriesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Ошибка: ${snapshot.error}'));
                }

                final categories = snapshot.data ?? [];

                return ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];

                    return Card(
                      child: ListTile(
                        title: Text(category.name),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteCategory(category.id),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ManageMenuItemsScreen(
                                token: widget.token,
                                categoryId: category.id,
                                categoryName: category.name,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}




