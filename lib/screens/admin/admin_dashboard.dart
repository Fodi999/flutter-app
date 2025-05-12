import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sushi_app/models/user.dart';
import 'package:sushi_app/theme/theme_provider.dart';
import 'package:sushi_app/services/menu_service.dart';

import 'controllers/admin_dashboard_controller.dart';
import 'manage_users.dart';
import 'manage_categories.dart';
import 'manage_inventory.dart';
import 'manage_ads.dart'; // ✅ реклама

import 'components/dashboard/sidebar_item.dart';
import 'components/dashboard/dashboard_card.dart';
import 'components/dashboard/staff_list.dart';

class AdminDashboard extends ConsumerStatefulWidget {
  const AdminDashboard({
    super.key,
    required this.user,
    required this.token,
  });

  final User user;
  final String token;

  @override
  ConsumerState<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends ConsumerState<AdminDashboard>
    with SingleTickerProviderStateMixin {
  String currentPage = 'dashboard';
  bool isSidebarOpen = true;

  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  int userCount = 0;
  int staffCount = 0;
  int menuItemCount = 0;
  Map<String, int> categoryCounts = {};
  List<User> staff = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
    _loadDashboardData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadDashboardData() async {
    final result = await AdminDashboardController.fetchUserStats(widget.token);
    final menuItems = await MenuService.getMenuWithCategory(widget.token);

    if (result != null && mounted) {
      final counts = <String, int>{};
      for (var item in menuItems) {
        final name = item.categoryName ?? 'Без категории';
        counts[name] = (counts[name] ?? 0) + 1;
      }
      setState(() {
        userCount = result['userCount'] as int;
        staff = List<User>.from(result['staff'] as List);
        staffCount = result['staffCount'] as int;
        menuItemCount = menuItems.length;
        categoryCounts = counts;
      });
    }
  }

  Widget _buildContent() {
    switch (currentPage) {
      case 'users':
        return ManageUsersScreen(token: widget.token);
      case 'staff':
        return StaffList(staff: staff);
      case 'categories':
        return ManageCategoriesScreen(token: widget.token);
      case 'inventory':
        return ManageInventoryScreen(token: widget.token);
      case 'ads': // ✅ реклама
        return ManageAdsScreen(token: widget.token);
      default:
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: DashboardCard(
                        icon: Icons.people_alt_rounded,
                        title: 'Пользователи',
                        value: '$userCount',
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      child: DashboardCard(
                        icon: Icons.badge_rounded,
                        title: 'Персонал',
                        value: '$staffCount',
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      child: DashboardCard(
                        icon: Icons.restaurant_menu,
                        title: 'Блюда',
                        value: '$menuItemCount',
                        color: Colors.orange,
                        bottomChild: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: categoryCounts.entries
                              .map((e) => Text(
                                    '${e.key}: ${e.value}',
                                    style: const TextStyle(fontSize: 12),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.green.shade100,
                      child: Text(
                        widget.user.avatarLetter.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Здравствуйте, ${widget.user.name} (админ)',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProv = ref.watch(themeProvider);

    return Scaffold(
      body: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isSidebarOpen ? 240 : 72,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : Colors.grey[100],
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
            ),
            child: Column(
              children: [
                const SizedBox(height: 16),
                IconButton(
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      isSidebarOpen ? Icons.chevron_left : Icons.menu,
                      key: ValueKey(isSidebarOpen),
                    ),
                  ),
                  onPressed: () =>
                      setState(() => isSidebarOpen = !isSidebarOpen),
                ),
                const SizedBox(height: 16),
                SidebarItem(
                  icon: Icons.dashboard,
                  label: 'Панель',
                  selected: currentPage == 'dashboard',
                  showLabel: isSidebarOpen,
                  onTap: () {
                    setState(() {
                      currentPage = 'dashboard';
                      _controller.forward(from: 0);
                    });
                  },
                ),
                SidebarItem(
                  icon: Icons.people_alt_rounded,
                  label: 'Пользователи',
                  selected: currentPage == 'users',
                  showLabel: isSidebarOpen,
                  onTap: () {
                    setState(() {
                      currentPage = 'users';
                      _controller.forward(from: 0);
                    });
                  },
                ),
                SidebarItem(
                  icon: Icons.badge_rounded,
                  label: 'Персонал',
                  selected: currentPage == 'staff',
                  showLabel: isSidebarOpen,
                  onTap: () async {
                    await _loadDashboardData();
                    setState(() {
                      currentPage = 'staff';
                      _controller.forward(from: 0);
                    });
                  },
                ),
                SidebarItem(
                  icon: Icons.category,
                  label: 'Категории',
                  selected: currentPage == 'categories',
                  showLabel: isSidebarOpen,
                  onTap: () {
                    setState(() {
                      currentPage = 'categories';
                      _controller.forward(from: 0);
                    });
                  },
                ),
                SidebarItem(
                  icon: Icons.inventory_2_outlined,
                  label: 'Склад',
                  selected: currentPage == 'inventory',
                  showLabel: isSidebarOpen,
                  onTap: () {
                    setState(() {
                      currentPage = 'inventory';
                      _controller.forward(from: 0);
                    });
                  },
                ),
                SidebarItem(
                  icon: Icons.campaign_rounded,
                  label: 'Реклама', // ✅ новая вкладка
                  selected: currentPage == 'ads',
                  showLabel: isSidebarOpen,
                  onTap: () {
                    setState(() {
                      currentPage = 'ads';
                      _controller.forward(from: 0);
                    });
                  },
                ),
                SidebarItem(
                  icon: Icons.logout,
                  label: 'Выход',
                  showLabel: isSidebarOpen,
                  onTap: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  IconButton(
                    tooltip: 'Переключить тему',
                    icon: Icon(
                      themeProv.themeMode == ThemeMode.dark
                          ? Icons.light_mode
                          : Icons.dark_mode,
                    ),
                    onPressed: () => ref.read(themeProvider).toggleTheme(),
                  ),
                ],
              ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              body: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }
}


















