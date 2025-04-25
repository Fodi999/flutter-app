import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../models/menu_item.dart';
import '../../services/user_service.dart';
import '../../services/menu_service.dart';
import 'components/user_menu_card.dart';
import '../../components/custom_card.dart'; // ✅ добавлен

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

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
  late Future<User> _userFuture;
  late Future<List<MenuItem>> _menuFuture;
  late TabController _tabController;

  bool editMode = false;
  bool isDark = false;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final bioController = TextEditingController();
  final birthdayController = TextEditingController();

  final lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF7FAF7),
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4CAF50)),
    cardColor: Colors.white.withOpacity(0.7),
  );

  final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4CAF50), brightness: Brightness.dark),
    cardColor: Colors.grey[900]!.withOpacity(0.6),
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUser();
    _menuFuture = MenuService.getMenuWithCategory(widget.token);
  }

  void _loadUser() {
    _userFuture = UserService.getUserById(widget.userId, widget.token).then((user) {
      nameController.text = user.name;
      emailController.text = user.email;
      phoneController.text = user.phone;
      addressController.text = user.address ?? '';
      bioController.text = user.bio ?? '';
      birthdayController.text = user.birthday ?? '';
      return user;
    });
  }

  Future<void> _saveProfile() async {
    final data = {
      "name": nameController.text,
      "email": emailController.text,
      "phone": phoneController.text,
      "address": addressController.text,
      "bio": bioController.text,
      "birthday": birthdayController.text,
    };
    await UserService.updateUserById(widget.userId, data, widget.token);
    setState(() {
      editMode = false;
      _loadUser();
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Профиль обновлён')));
  }

  Widget _buildHeader(User user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: isDark ? [Colors.green.shade900, Colors.black] : [Colors.lightGreenAccent, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white,
            child: Text(
              user.avatarLetter,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(user.email),
              Text('Роль: ${user.role}', style: TextStyle(color: Colors.grey[600])),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildEditableTabs() {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.primary,
          tabs: const [Tab(text: 'Профиль'), Tab(text: 'Контакты')],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 300,
          child: TabBarView(
            controller: _tabController,
            children: [
              Column(
                children: [
                  TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Имя')),
                  TextField(controller: bioController, decoration: const InputDecoration(labelText: 'О себе')),
                  TextField(controller: birthdayController, decoration: const InputDecoration(labelText: 'Дата рождения')),
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
        )
      ],
    );
  }

  Widget _buildTextRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$title: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value?.isNotEmpty == true ? value! : '—')),
        ],
      ),
    );
  }

  Widget _buildGroupedMenu(List<MenuItem> items) {
    final Map<String, List<MenuItem>> grouped = {};
    for (var item in items) {
      final cat = item.categoryName ?? 'Без категории';
      grouped.putIfAbsent(cat, () => []).add(item);
    }

    return Column(
      children: grouped.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(entry.key, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: entry.value.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (_, i) {
                final item = entry.value[i];
                return UserMenuCard(
                  item: item,
                  onAddToCart: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Добавлено: ${item.name}')),
                  ),
                );
              },
            ),
          ],
        );
      }).toList(),
    );
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
              icon: Icon(isDark ? Icons.wb_sunny : Icons.nightlight),
            ),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: FutureBuilder<User>(
          future: _userFuture,
          builder: (context, snapUser) {
            if (!snapUser.hasData) return const Center(child: CircularProgressIndicator());
            final user = snapUser.data!;
            return FutureBuilder<List<MenuItem>>(
              future: _menuFuture,
              builder: (context, snapMenu) {
                final menu = snapMenu.data ?? [];
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildHeader(user),
                      const SizedBox(height: 20),
                      CustomCard(
                        padding: const EdgeInsets.all(16),
                        child: editMode
                            ? _buildEditableTabs()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildTextRow('Email', user.email),
                                  _buildTextRow('Телефон', user.phone),
                                  _buildTextRow('Адрес', user.address),
                                  _buildTextRow('О себе', user.bio),
                                  _buildTextRow('День рождения', user.birthday),
                                ],
                              ),
                      ),
                      if (!editMode) _buildGroupedMenu(menu),
                    ],
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











