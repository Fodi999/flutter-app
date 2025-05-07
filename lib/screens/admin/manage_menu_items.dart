import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:sushi_app/models/menu_item.dart';
import 'package:sushi_app/models/ingredient.dart';
import 'package:sushi_app/models/menu_calculation.dart';
import 'package:sushi_app/models/inventory_item.dart';
import 'package:sushi_app/services/menu_service.dart';
import 'package:sushi_app/services/calculation_service.dart';
import 'package:sushi_app/services/inventory_service.dart';

import 'components/dashboard/form/menu_item_form.dart';
import 'components/dashboard/form/ingredient_table.dart';
import 'components/dashboard/form/calculation_panel.dart';
import 'components/dashboard/form/menu_card.dart';
import 'components/dashboard/form/ingredient_picker.dart';

class ManageMenuItemsScreen extends StatefulWidget {
  const ManageMenuItemsScreen({
    super.key,
    required this.token,
    required this.categoryId,
    required this.categoryName,
  });

  final String token;
  final String categoryId;
  final String categoryName;

  @override
  State<ManageMenuItemsScreen> createState() => _ManageMenuItemsScreenState();
}

class _ManageMenuItemsScreenState extends State<ManageMenuItemsScreen> {
  late Future<List<MenuItem>> _menuFuture;
  final ScrollController _scrollController = ScrollController();
  List<InventoryItem> inventory = [];
  List<Ingredient> ingredients = [];

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _imageController = TextEditingController();
  final _priceController = TextEditingController();

  double get _computedCost =>
      ingredients.fold(0.0, (sum, ing) => sum + ing.totalCost);
  int get _computedOutput =>
      ingredients.fold(0, (sum, ing) => sum + ing.amountGrams);

  @override
  void initState() {
    super.initState();
    _loadMenuItems();
    _loadInventory();
  }

  void _loadMenuItems() {
    _menuFuture = MenuService.getMenuWithCategory(widget.token);
  }

  Future<void> _loadInventory() async {
    final inv = await InventoryService.getInventoryItems(widget.token);
    setState(() => inventory = inv);
  }

  void _showSnackBar(String message, {bool error = false}) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: error ? Colors.red : Colors.green,
        ),
      );

  void _addEmptyIngredient() => setState(() {
        ingredients.add(Ingredient(
          productName: '',
          amountGrams: 0,
          pricePerKg: 0,
          wastePercent: 0,
          priceAfterWaste: 0,
          totalCost: 0,
        ));
      });

  void _updateIngredient(int index,
      {String? name, int? grams, double? waste}) {
    if (index < 0 || index >= ingredients.length) return;
    final selectedName = name ?? ingredients[index].productName;

    final fallback = InventoryItem(
      id: '',
      name: '',
      weightG: 0,
      pricePerKg: 0,
      available: false,
      createdAt: DateTime.now(),
      emoji: '',
      category: 'прочее',
    );

    final match = inventory.firstWhere(
      (it) => it.name == selectedName,
      orElse: () => fallback,
    );

    if (match.name.isEmpty) return;

    final pricePerKg = match.pricePerKg;
    final pricePerGram = pricePerKg / 1000;
    final usedGrams = grams ?? ingredients[index].amountGrams;
    final wastePercent = waste ?? ingredients[index].wastePercent;
    final priceAfterWaste = pricePerGram / (1 - wastePercent / 100);
    final totalCost = usedGrams * priceAfterWaste;

    setState(() {
      ingredients[index] = Ingredient(
        productName: match.name,
        amountGrams: usedGrams,
        pricePerKg: pricePerKg,
        wastePercent: wastePercent,
        priceAfterWaste: priceAfterWaste,
        totalCost: totalCost,
      );
    });
  }

  Future<void> _startEditMenuItem(MenuItem m) async {
    _nameController.text = m.name;
    _descController.text = m.description;
    _imageController.text = m.imageUrl;
    _priceController.text = m.price.toStringAsFixed(2);
    setState(() => ingredients = []);
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  Future<void> _saveDraft() async => _saveMenuItem(publish: false);

  Future<void> _saveAndPublish() async => _saveMenuItem(publish: true);

  Future<void> _saveMenuItem({required bool publish}) async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
    final outputWeight = _computedOutput.toDouble();
    final cost = _computedCost;

    if (name.isEmpty ||
        price <= 0 ||
        outputWeight <= 0 ||
        ingredients.any((e) => e.productName.isEmpty)) {
      _showSnackBar('Заполните все поля и ингредиенты', error: true);
      return;
    }

    final item = MenuItem(
      id: const Uuid().v4(),
      name: name,
      description: _descController.text.trim(),
      imageUrl: _imageController.text.trim(),
      price: price,
      costPrice: cost,
      margin: price - cost,
      createdAt: DateTime.now(),
      categoryId: widget.categoryId,
      published: publish,
    );

    final calc = MenuCalculation(
      id: '',
      menuItemId: item.id,
      ingredients: ingredients,
      totalWeightG: outputWeight,
      totalCost: cost,
      createdAt: DateTime.now(),
    );

    try {
      await MenuService.createMenuItem(item, widget.token);
      await CalculationService.saveDishCalculation(calc, widget.token);
      _showSnackBar(
          publish ? 'Блюдо опубликовано' : 'Блюдо сохранено как черновик');
      _clearForm();
      setState(_loadMenuItems);
    } catch (e) {
      _showSnackBar('Ошибка: $e', error: true);
    }
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _descController.clear();
    _imageController.clear();
    _priceController.clear();
    setState(() => ingredients.clear());
  }

  Future<void> _deleteMenuItem(String id) async {
    try {
      await MenuService.deleteMenuItem(id, widget.token);
      _showSnackBar('Блюдо удалено');
      setState(_loadMenuItems);
    } catch (e) {
      _showSnackBar('Ошибка удаления: $e', error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
    final isStepCompleted = _nameController.text.trim().isNotEmpty &&
        price > 0 &&
        _computedOutput > 0 &&
        ingredients.isNotEmpty &&
        ingredients.every((e) => e.productName.isNotEmpty);

    return Scaffold(
      appBar: AppBar(title: Text('Блюда — ${widget.categoryName}')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: FutureBuilder<List<MenuItem>>(
          future: _menuFuture,
          builder: (ctx, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return Center(child: Text('Ошибка: ${snap.error}'));
            }

            final items = (snap.data ?? [])
                .where((m) => m.categoryId == widget.categoryId)
                .toList();

            return SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MenuItemForm(
                    formKey: _formKey,
                    nameController: _nameController,
                    descController: _descController,
                    imageController: _imageController,
                    priceController: _priceController,
                    onAddIngredient: _addEmptyIngredient,
                  ),
                  const Divider(height: 32),
                  IngredientTable(
                    ingredients: ingredients,
                    onSelect: (i) async {
                      final picked = await showIngredientPicker(
                        context: context,
                        inventory: inventory,
                      );
                      if (picked != null) _updateIngredient(i, name: picked.name);
                    },
                    onUpdateGrams: (i, g) => _updateIngredient(i, grams: g),
                    onUpdateWaste: (i, w) => _updateIngredient(i, waste: w),
                    onDelete: (i) => setState(() => ingredients.removeAt(i)),
                  ),
                  const Divider(height: 32),
                  CalculationPanel(
                    cost: _computedCost,
                    output: _computedOutput,
                    price: price,
                    onSaveDraft: _saveDraft,
                    onSaveAndPublish: _saveAndPublish,
                    onClear: _clearForm,
                    isStepCompleted: isStepCompleted,
                  ),
                  const Divider(height: 32),
                  const Text(
                    'Список блюд',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: items.map((m) {
                      return MenuCard(
                        item: m,
                        onDelete: () => _deleteMenuItem(m.id),
                        onPublish: () async {
                          try {
                            await MenuService.publishMenuItem(m.id, widget.token);
                            _showSnackBar('Статус публикации изменён');
                            setState(_loadMenuItems);
                          } catch (e) {
                            _showSnackBar('Ошибка публикации: $e', error: true);
                          }
                        },
                        onEdit: () => _startEditMenuItem(m),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}




























