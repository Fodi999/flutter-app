// lib/widgets/admin/create_ad_banner_form.dart
import 'package:flutter/material.dart';

class CreateAdBannerForm extends StatefulWidget {
  const CreateAdBannerForm({
    super.key,
    required this.onSubmit,
  });

  final void Function({
    required String imageUrl,
    required String text,
  }) onSubmit;

  @override
  State<CreateAdBannerForm> createState() => _CreateAdBannerFormState();
}

class _CreateAdBannerFormState extends State<CreateAdBannerForm> {
  final _formKey = GlobalKey<FormState>();
  final _imageUrlController = TextEditingController();
  final _textController = TextEditingController();

  @override
  void dispose() {
    _imageUrlController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        imageUrl: _imageUrlController.text.trim(),
        text: _textController.text.trim(),
      );
      _imageUrlController.clear();
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Создать баннер', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextFormField(
              controller: _imageUrlController,
              decoration: const InputDecoration(
                labelText: 'URL изображения',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Введите ссылку на изображение';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Краткий текст / слоган',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Введите текст';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _handleSubmit,
              child: const Text('Добавить баннер'),
            ),
          ],
        ),
      ),
    );
  }
}
