// lib/widgets/profile_content.dart
import 'package:flutter/material.dart';

import 'package:sushi_app/models/user.dart';
import 'package:sushi_app/models/menu_item.dart';

import 'package:sushi_app/components/custom_card.dart';
import 'package:sushi_app/screens/user/components/profile_header.dart';
import 'package:sushi_app/screens/user/components/dish_autocomplete_input.dart';
import 'package:sushi_app/screens/user/components/editable_tabs.dart';
import 'package:sushi_app/screens/user/components/profile_info.dart';
import 'package:sushi_app/screens/user/components/grouped_menu.dart';

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
  });

  /* ────────── входные данные ────────── */
  final User                    user;
  final List<MenuItem>          menu;

  final bool                    editMode;
  final bool                    isDark;

  final TabController           tabController;
  final ScrollController        scrollController;

  final TextEditingController   nameController;
  final TextEditingController   emailController;
  final TextEditingController   phoneController;
  final TextEditingController   addressController;
  final TextEditingController   bioController;
  final TextEditingController   birthdayController;

  final VoidCallback            onSaveProfile;
  final VoidCallback            onCancelEdit;
  final void Function(MenuItem) onAddToCart;

  /* ────────── UI ────────── */
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          /* шапка профиля */
          ProfileHeader(user: user, isDark: isDark),
          const SizedBox(height: 20),

          /* автокомплит адреса */
          DishAutocompleteInput(
            onSelected: (sel) => addressController.text = sel,
          ),
          const SizedBox(height: 20),

          /* профиль / редактирование */
          CustomCard(
            padding: const EdgeInsets.all(16),
            child: editMode
                ? EditableTabs(
                    tabController:       tabController,
                    nameController:      nameController,
                    bioController:       bioController,
                    birthdayController:  birthdayController,
                    emailController:     emailController,
                    phoneController:     phoneController,
                    addressController:   addressController,
                    onSave:              onSaveProfile,
                    onCancel:            onCancelEdit,
                  )
                : ProfileInfo(fields: {
                    'Email'        : user.email,
                    'Телефон'      : user.phone,
                    'Адрес'        : user.address,
                    'О себе'       : user.bio,
                    'День рождения': user.birthday,
                  }),
          ),

          /* меню блюд (если не режим редакт.) */
          if (!editMode)
            GroupedMenu(
              items:       menu,
              onAddToCart: onAddToCart,
            ),
        ],
      ),
    );
  }
}

