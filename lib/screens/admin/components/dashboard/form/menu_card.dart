import 'package:flutter/material.dart';
import 'package:sushi_app/models/menu_item.dart';

class MenuCard extends StatelessWidget {
  const MenuCard({
    super.key,
    required this.item,
    required this.onDelete,
    required this.onPublish,
    this.onEdit,
  });

  final MenuItem item;
  final VoidCallback onDelete;
  final VoidCallback onPublish;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    // Рассчитываем основные показатели
    final costPrice = item.costPrice;
    final margin = item.margin;
    final marginPercent = costPrice > 0
        ? ((item.price - costPrice) / costPrice * 100).toStringAsFixed(0)
        : '0';

    // Ширина карточки: 45% экрана, но не меньше 200 и не больше 300
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.45;
    final constrainedWidth = cardWidth.clamp(200.0, 300.0);

    return InkWell(
      onTap: onEdit,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: constrainedWidth,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          margin: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Изображение или заглушка
              if (item.imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12)),
                  child: Image.network(
                    item.imageUrl,
                    height: 140,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Container(
                  height: 140,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: const Icon(Icons.image,
                      size: 60, color: Colors.white70),
                ),

              // Содержимое карточки
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Название и статус публикации
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: item.published
                                ? Colors.green[100]
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item.published ? 'Опубликовано' : 'Черновик',
                            style: TextStyle(
                              fontSize: 10,
                              color: item.published
                                  ? Colors.green[800]
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Описание
                    Text(
                      item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.black87),
                    ),
                    const SizedBox(height: 8),

                    // Цена и себестоимость + маржа
                    Row(
                      children: [
                        Text(
                          '${item.price.toStringAsFixed(2)} ₽',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Себестоимость: ${costPrice.toStringAsFixed(2)} ₽',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black54),
                            ),
                            Text(
                              'Маржа: ${margin.toStringAsFixed(2)} ₽ ($marginPercent%)',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black54),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Кнопки действий
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(
                            item.published
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color:
                                item.published ? Colors.green : Colors.grey,
                          ),
                          tooltip: item.published
                              ? 'Снять с публикации'
                              : 'Опубликовать',
                          onPressed: onPublish,
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blueGrey),
                          tooltip: 'Редактировать',
                          onPressed: onEdit,
                        ),
                        IconButton(
                          icon:
                              const Icon(Icons.delete, color: Colors.redAccent),
                          tooltip: 'Удалить',
                          onPressed: onDelete,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}







