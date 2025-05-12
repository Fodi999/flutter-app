// lib/screens/admin/manage_ads.dart
import 'package:flutter/material.dart';
import 'package:sushi_app/models/ad_banner.dart';
import 'package:sushi_app/services/ad_service.dart';
import 'package:sushi_app/utils/log_helper.dart';
import 'package:sushi_app/widgets/admin/ad_banner_card.dart';

class ManageAdsScreen extends StatefulWidget {
  final String token;

  const ManageAdsScreen({super.key, required this.token});

  @override
  State<ManageAdsScreen> createState() => _ManageAdsScreenState();
}

class _ManageAdsScreenState extends State<ManageAdsScreen> {
  late Future<List<AdBanner>> _adsFuture;
  final _imageUrlController = TextEditingController();
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAds();
  }

  void _loadAds() {
    setState(() {
      _adsFuture = AdService.fetchAds(token: widget.token);
    });
  }

  Future<void> _addAdBanner() async {
    try {
      await AdService.createAdBanner(
        token: widget.token,
        imageUrl: _imageUrlController.text,
        text: _textController.text,
      );
      logInfo('🎉 Новый баннер создан');
      _imageUrlController.clear();
      _textController.clear();
      _loadAds();
    } catch (e) {
      logError('Ошибка при создании баннера', error: e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка при добавлении баннера')),
      );
    }
  }

 Future<void> _deleteBanner(String id) async {

    try {
      await AdService.deleteAdBanner(id: id, token: widget.token);
      logInfo('🗑️ Баннер удалён (id: $id)');
      _loadAds();
    } catch (e) {
      logError('Ошибка при удалении баннера', error: e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка при удалении баннера')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Управление рекламой')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Создать новый баннер',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _imageUrlController,
              decoration: const InputDecoration(labelText: 'URL изображения'),
            ),
            TextField(
              controller: _textController,
              decoration: const InputDecoration(labelText: 'Текст / слоган'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _addAdBanner,
              child: const Text('Добавить баннер'),
            ),
            const Divider(height: 32),
            const Text(
              'Список баннеров',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<AdBanner>>(
                future: _adsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Ошибка загрузки баннеров'));
                  }

                  final banners = snapshot.data!;
                  if (banners.isEmpty) {
                    return const Center(child: Text('Баннеров пока нет'));
                  }

                  return ListView.builder(
                    itemCount: banners.length,
                    itemBuilder: (context, index) {
                      final banner = banners[index];
                      return AdBannerCard(
                        banner: banner,
                        onDelete: () => _deleteBanner(banner.id),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

