import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:sushi_app/services/ad_service.dart';

class AdBannerSlider extends StatefulWidget {
  const AdBannerSlider({super.key});

  @override
  State<AdBannerSlider> createState() => _AdBannerSliderState();
}

class _AdBannerSliderState extends State<AdBannerSlider> {
  late final WebSocketChannel _channel;
  final List<Map<String, dynamic>> _ads = [];

  @override
  void initState() {
    super.initState();
    _channel = AdService.connectToAds();

    _channel.stream.listen((event) {
      try {
        final decoded = json.decode(event);
        if (decoded is List) {
          final banners = decoded.whereType<Map<String, dynamic>>().toList();
          if (mounted) {
            setState(() {
              _ads
                ..clear()
                ..addAll(banners);
            });
          }
        }
      } catch (e) {
        debugPrint('❌ Ошибка при обработке баннеров: $e');
      }
    });
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_ads.isEmpty) {
      return const SizedBox(
        height: 180,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _ads.length,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (context, index) {
          final ad = _ads[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Image.network(
                    ad['image_url'] ?? '',
                    width: 300,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image)),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                  Container(
                    width: 300,
                    height: 180,
                    color: Colors.black.withOpacity(0.4),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      ad['text'] ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
