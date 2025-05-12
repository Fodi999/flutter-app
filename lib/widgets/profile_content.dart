import 'package:flutter/material.dart';
import 'package:sushi_app/models/user.dart';
import 'package:sushi_app/models/menu_item.dart';

import 'package:sushi_app/components/custom_card.dart';
import 'package:sushi_app/screens/user/components/profile_header.dart';
import 'package:sushi_app/screens/user/components/dish_autocomplete_input.dart';
import 'package:sushi_app/screens/user/components/editable_tabs.dart';
import 'package:sushi_app/screens/user/components/profile_info.dart';
import 'package:sushi_app/screens/user/components/grouped_menu.dart';

import 'package:sushi_app/utils/log_helper.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({
    super.key,
    required this.user,
    required this.menu,
    required this.editMode,
    required this.isDark,
    required this.tabController,
    required this.scrollController,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.addressController,
    required this.bioController,
    required this.birthdayController,
    required this.onSaveProfile,
    required this.onCancelEdit,
    required this.onAddToCart,
    required this.orderHistoryTab,
    required this.adBanner, // ✅ новый параметр
  });

  final User user;
  final List<MenuItem> menu;

  final bool editMode;
  final bool isDark;

  final TabController tabController;
  final ScrollController scrollController;

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController bioController;
  final TextEditingController birthdayController;

  final VoidCallback onSaveProfile;
  final VoidCallback onCancelEdit;
  final void Function(MenuItem) onAddToCart;

  final Widget orderHistoryTab;
  final Widget adBanner; // ✅ рекламный блок

  @override
  Widget build(BuildContext context) {
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        final tab = ['Профиль', 'Меню', 'История заказов'][tabController.index];
        logInfo('🔄 Переключение на вкладку: $tab', tag: 'ProfileContent');
      }
    });

    return Column(
      children: [
        TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: 'Профиль'),
            Tab(text: 'Меню'),
            Tab(text: 'История заказов'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              _buildProfileTab(),
              _buildMenuTab(context),
              orderHistoryTab,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          ProfileHeader(user: user, isDark: isDark),
          const SizedBox(height: 20),
          adBanner, // ✅ вставка рекламного блока
          const SizedBox(height: 20),
          DishAutocompleteInput(
            onSelected: (sel) {
              logInfo('📍 Выбран адрес из подсказки: $sel', tag: 'ProfileContent');
              addressController.text = sel;
            },
          ),
          const SizedBox(height: 20),
          CustomCard(
            padding: const EdgeInsets.all(16),
            child: editMode
                ? EditableTabs(
                    tabController: tabController,
                    nameController: nameController,
                    bioController: bioController,
                    birthdayController: birthdayController,
                    emailController: emailController,
                    phoneController: phoneController,
                    addressController: addressController,
                    onSave: () {
                      logInfo('💾 Сохранение профиля пользователя', tag: 'ProfileContent');
                      onSaveProfile();
                    },
                    onCancel: () {
                      logInfo('❌ Отмена редактирования профиля', tag: 'ProfileContent');
                      onCancelEdit();
                    },
                  )
                : ProfileInfo(fields: {
                    'Email': user.email,
                    'Телефон': user.phone,
                    'Адрес': user.address,
                    'О себе': user.bio,
                    'День рождения': user.birthday,
                  }),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GroupedMenu(
        items: menu,
        onAddToCart: (item) {
          logInfo('➕ Добавление "${item.name}" в корзину', tag: 'ProfileContent');
          onAddToCart(item);
        },
      ),
    );
  }
}





