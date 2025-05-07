import 'package:flutter/material.dart';
import 'package:sushi_app/models/menu_item.dart';
import 'user_menu_card.dart';

class GroupedMenu extends StatefulWidget {
  /// Список элементов меню
  final List<MenuItem> items;
  /// Коллбэк на добавление в корзину
  final void Function(MenuItem) onAddToCart;

  const GroupedMenu({
    Key? key,
    required this.items,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  State<GroupedMenu> createState() => _GroupedMenuState();
}

class _GroupedMenuState extends State<GroupedMenu> {
  late Map<String, List<MenuItem>> _grouped;
  late List<String> _categories;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _groupAndInit();
  }

  void _groupAndInit() {
    _grouped = <String, List<MenuItem>>{};
    for (var item in widget.items) {
      final cat = (item.categoryName?.isEmpty ?? true)
          ? 'Без категории'
          : item.categoryName!;
      _grouped.putIfAbsent(cat, () => []).add(item);
    }
    _categories = _grouped.keys.toList();
    _selectedCategory ??= _categories.isNotEmpty ? _categories.first : null;
  }

  @override
  void didUpdateWidget(covariant GroupedMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    // если изменился список items — перегруппировать и сохранить выбор, если он есть
    if (oldWidget.items != widget.items) {
      _groupAndInit();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (_selectedCategory == null) {
      return const SizedBox(); // нет данных
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Горизонтальный список «вкладок»
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: _categories.map((cat) {
              final isSelected = cat == _selectedCategory;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: InkWell(
                  onTap: () => setState(() => _selectedCategory = cat),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? cs.primary
                          : cs.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: cs.primary,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      cat,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                            color:
                                isSelected ? cs.onPrimary : cs.primary,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w600,
                          ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 12),

        // Сетка только для выбранной категории
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _grouped[_selectedCategory]!.length,
            gridDelegate:
                const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 280,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, i) {
              final item = _grouped[_selectedCategory]![i];
              return UserMenuCard(
                item: item,
                onAddToCart: () => widget.onAddToCart(item),
              );
            },
          ),
        ),
      ],
    );
  }
}

