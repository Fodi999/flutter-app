import 'package:flutter/material.dart';
import 'package:sushi_app/models/menu_item.dart';
import 'user_menu_card.dart';

class TabbedGroupedMenu extends StatefulWidget {
  final List<MenuItem> items;
  final void Function(MenuItem) onAddToCart;

  const TabbedGroupedMenu({
    Key? key,
    required this.items,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  State<TabbedGroupedMenu> createState() => _TabbedGroupedMenuState();
}

class _TabbedGroupedMenuState extends State<TabbedGroupedMenu> with TickerProviderStateMixin {
  late TabController _tabController;
  late List<String> _categories;
  late Map<String, List<MenuItem>> _grouped;

  @override
  void initState() {
    super.initState();

    // Группируем по категориям
    _grouped = {};
    for (var item in widget.items) {
      final cat = (item.categoryName?.isEmpty ?? true) ? 'Без категории' : item.categoryName!;
      _grouped.putIfAbsent(cat, () => []).add(item);
    }

    _categories = _grouped.keys.toList();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: cs.primary,
          labelColor: cs.primary,
          unselectedLabelColor: cs.onSurface.withOpacity(0.6),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: _categories.map((cat) => Tab(text: cat)).toList(),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 540,
          child: TabBarView(
            controller: _tabController,
            children: _categories.map((cat) {
              final items = _grouped[cat]!;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  itemCount: items.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 280,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, i) {
                    final item = items[i];
                    return UserMenuCard(
                      item: item,
                      onAddToCart: () => widget.onAddToCart(item),
                    );
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
