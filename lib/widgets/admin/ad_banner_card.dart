// lib/widgets/admin/ad_banner_card.dart
import 'package:flutter/material.dart';
import 'package:sushi_app/models/ad_banner.dart';

class AdBannerCard extends StatelessWidget {
  const AdBannerCard({
    super.key,
    required this.banner,
    required this.onDelete,
  });

  final AdBanner banner;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Image.network(
          banner.imageUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
        title: Text(banner.text),
        subtitle: Text(
          banner.isActive ? 'Активен' : 'Отключён',
          style: TextStyle(
            color: banner.isActive ? Colors.green : Colors.red,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
