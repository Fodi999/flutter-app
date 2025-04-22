import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../models/menu_item.dart';
import '../../services/user_service.dart';
import '../../services/menu_service.dart';
import 'components/user_menu_card.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  final String token;

  const ProfileScreen({
    super.key,
    required this.userId,
    required this.token,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late Future<User> _userFuture;
  late Future<List<MenuItem>> _publishedFuture;

  bool editMode = false;
  bool isDark = false;
  late TabController _tabController;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final bioController = TextEditingController();
  final birthdayController = TextEditingController();

  final lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.green,
    scaffoldBackgroundColor: const Color(0xFFF2FFE5),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFDFFFD6),
      foregroundColor: Colors.black87,
    ),
  );

  final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.green,
    scaffoldBackgroundColor: const Color(0xFF003300),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF002200),
      foregroundColor: Colors.white,
    ),
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _reloadAll();
  }

  void _reloadAll() {
    _userFuture = _loadUser();
    _publishedFuture = MenuService.getMenuWithCategory(); // ← берём с категориями
  }

  Future<User> _loadUser() async {
    final user = await UserService.getUserById(widget.userId, widget.token);
    nameController.text = user.name;
    emailController.text = user.email;
    phoneController.text = user.phone;
    addressController.text = user.address ?? '';
    bioController.text = user.bio ?? '';
    birthdayController.text = user.birthday ?? '';
    return user;
  }

  Widget _buildTextRow(String title, String? value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Text('$title: ', style: const TextStyle(fontWeight: FontWeight.bold)),
            Expanded(child: Text(value?.isNotEmpty == true ? value! : '—')),
          ],
        ),
      );

  Widget _buildHeader(User user) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.green.shade900, Colors.black]
                : [Colors.lightGreenAccent, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: Colors.white,
              child: Text(user.avatarLetter, style: const TextStyle(fontSize: 28)),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(user.email, style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 4),
                  Text('Роль: ${user.role}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      );

  /// Сетка блюд по категориям
Widget _buildGroupedMenu(List<MenuItem> items) {
  final Map<String, List<MenuItem>> grouped = {};
  for (var item in items) {
    final category = item.categoryName ?? 'Без категории';
    grouped.putIfAbsent(category, () => []).add(item);
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: grouped.entries.map((entry) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(
            entry.key,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(builder: (context, constraints) {
            int crossAxisCount = 1;
            if (constraints.maxWidth > 1000) {
              crossAxisCount = 3;
            } else if (constraints.maxWidth > 600) {
              crossAxisCount = 2;
            }
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: entry.value.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.78,
              ),
              itemBuilder: (_, i) {
                final item = entry.value[i];
                return UserMenuCard(
                  item: item,
                  onAddToCart: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Добавлено в корзину: ${item.name}')),
                    );
                  },
                );
              },
            );
          }),
        ],
      );
    }).toList(),
  );
}


  Widget _buildEditableForm() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Column(
        key: ValueKey(editMode),
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [Tab(text: 'Профиль'), Tab(text: 'Контакты')],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 300,
            child: TabBarView(
              controller: _tabController,
              children: [
                Column(
                  children: [
                    TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Имя')),
                    TextField(controller: bioController, decoration: const InputDecoration(labelText: 'О себе')),
                    TextField(controller: birthdayController, decoration: const InputDecoration(labelText: 'Дата рождения (YYYY-MM-DD)')),
                  ],
                ),
                Column(
                  children: [
                    TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
                    TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Телефон')),
                    TextField(controller: addressController, decoration: const InputDecoration(labelText: 'Адрес')),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton(onPressed: _saveProfile, child: const Text('Сохранить')),
              const SizedBox(width: 12),
              OutlinedButton(onPressed: () => setState(() => editMode = false), child: const Text('Отмена')),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _saveProfile() async {
    try {
      final data = {
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "phone": phoneController.text.trim(),
        "address": addressController.text.trim(),
        "bio": bioController.text.trim(),
        "birthday": birthdayController.text.trim(),
      };
      await UserService.updateUserById(widget.userId, data, widget.token);

      setState(() {
        editMode = false;
        _reloadAll();
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Профиль обновлён')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ошибка: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = isDark ? darkTheme : lightTheme;

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Профиль'),
          actions: [
            IconButton(
              onPressed: () => setState(() => editMode = !editMode),
              icon: Icon(editMode ? Icons.close : Icons.edit),
            ),
            IconButton(
              onPressed: () => setState(() => isDark = !isDark),
              icon: Icon(isDark ? Icons.wb_sunny : Icons.nightlight_round),
            ),
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: FutureBuilder<User>(
          future: _userFuture,
          builder: (context, snapUser) {
            if (snapUser.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapUser.hasError || !snapUser.hasData) {
              return const Center(child: Text('Ошибка загрузки профиля'));
            }
            final user = snapUser.data!;

            return FutureBuilder<List<MenuItem>>(
              future: _publishedFuture,
              builder: (context, snapMenu) {
                final menuReady = snapMenu.connectionState == ConnectionState.done &&
                    !snapMenu.hasError &&
                    snapMenu.hasData;
                final items = menuReady ? snapMenu.data! : const <MenuItem>[];

                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: SingleChildScrollView(
                    key: ValueKey(user.id + (editMode ? '_edit' : '_view')),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildHeader(user),
                        const SizedBox(height: 24),
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: editMode
                                ? _buildEditableForm()
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildTextRow('Телефон', user.phone),
                                      _buildTextRow('Адрес', user.address),
                                      _buildTextRow('О себе', user.bio),
                                      _buildTextRow('Дата рождения', user.birthday),
                                      _buildTextRow('ID', user.id),
                                    ],
                                  ),
                          ),
                        ),
                        if (!editMode && menuReady) ...[
                          const SizedBox(height: 24),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Опубликованные блюда',
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          _buildGroupedMenu(items),
                        ],
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}









