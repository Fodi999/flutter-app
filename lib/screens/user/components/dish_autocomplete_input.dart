import 'package:flutter/material.dart';

class DishAutocompleteInput extends StatefulWidget {
  final Function(String) onSelected;

  const DishAutocompleteInput({super.key, required this.onSelected});

  @override
  State<DishAutocompleteInput> createState() => _DishAutocompleteInputState();
}

class _DishAutocompleteInputState extends State<DishAutocompleteInput> {
  final TextEditingController _controller = TextEditingController();

  /// Здесь можно подставить свои блюда или подгружать из сервиса
  final List<String> _suggestions = [
    'Ролл Филадельфия',
    'Ролл Калифорния',
    'Нигири с лососем',
    'Сашими тунец',
    'Унаги маки',
    'Гункан с икрой',
    'Темпура ролл',
    'Чикен ролл',
  ];

  List<String> _filtered = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onInputChanged);
  }

  void _onInputChanged() {
    final input = _controller.text.toLowerCase();
    setState(() {
      _filtered = _suggestions
          .where((s) => s.toLowerCase().contains(input))
          .toList();
    });
  }

  void _selectDish(String dish) {
    _controller.text = dish;
    _filtered.clear();
    widget.onSelected(dish);
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'Введите название блюда',
            hintText: 'Например, Ролл Филадельфия...',
          ),
        ),
        if (_filtered.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filtered.length,
              itemBuilder: (context, index) {
                final suggestion = _filtered[index];
                return ListTile(
                  title: Text(suggestion),
                  onTap: () => _selectDish(suggestion),
                );
              },
            ),
          ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              widget.onSelected(_controller.text);
            }
          },
          child: const Text('Найти'),
        ),
      ],
    );
  }
}

