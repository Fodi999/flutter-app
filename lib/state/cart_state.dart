import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/cart.dart';

part 'cart_state.g.dart';

/*───────────────────────────────────────────────────────────────*/
/*                STATE  =  List<CartItem>                       */
/*───────────────────────────────────────────────────────────────*/
@riverpod
class CartState extends _$CartState {
  @override
  List<CartItem> build() => [];

  void set(List<CartItem> items) => state = List.from(items);

  void inc(CartItem ci) => _update(ci, ci.quantity + 1);
  void dec(CartItem ci) => _update(ci, ci.quantity - 1);
  void remove(CartItem ci) =>
      state = state.where((e) => e.id != ci.id).toList();

  void clear() => state = [];

  void addOrUpdate(CartItem newItem) {
    final index = state.indexWhere((e) => e.id == newItem.id);
    if (index == -1) {
      state = [...state, newItem];
    } else {
      state = [
        for (final e in state)
          e.id == newItem.id
              ? e.copyWith(quantity: e.quantity + newItem.quantity)
              : e
      ];
    }
  }

  void updateItem(String id, CartItem updatedItem) {
    state = [
      for (final e in state) if (e.id == id) updatedItem else e,
    ];
  }

  int get totalQty => state.fold(0, (s, e) => s + e.quantity);
  double get totalSum => state.fold(0.0, (s, e) => s + e.quantity * e.price);

  void _update(CartItem ci, int newQty) {
    if (newQty <= 0) return remove(ci);
    state = [
      for (final e in state)
        e.id == ci.id ? e.copyWith(quantity: newQty) : e,
    ];
  }

  void incWithFeedback(CartItem ci, void Function(String)? onChange) {
    inc(ci);
    onChange?.call('${ci.name} +1');
  }

  void decWithFeedback(CartItem ci, void Function(String)? onChange) {
    dec(ci);
    onChange?.call('${ci.name} -1');
  }

  /// Метод вызывается после оформления заказа:
  /// очищает корзину и вызывает callback (например, закрытие bottom sheet)
  void finalizeOrder({void Function()? onComplete}) {
    clear();
    onComplete?.call();
  }

  /// Группировка по cartId (можно адаптировать под restaurantId и т.п.)
  Map<String, List<CartItem>> get groupedByCartId {
    final map = <String, List<CartItem>>{};
    for (final item in state) {
     map.putIfAbsent(item.cartId.toString(), () => []).add(item);

    }
    return map;
  }
}

/*───────────────────────────────────────────────────────────────*/
/* Расширяем CartItem методом copyWith с поддержкой options      */
/*───────────────────────────────────────────────────────────────*/
extension CartItemCopy on CartItem {
  CartItem copyWith({
    int? quantity,
    Map<String, dynamic>? options,
  }) =>
      CartItem(
        id: id,
        cartId: cartId,
        menuItemId: menuItemId,
        name: name,
        quantity: quantity ?? this.quantity,
        price: price,
        imageUrl: imageUrl,
        options: options ?? this.options,
      );
}

/*───────────────────────────────────────────────────────────────*/
/* Расширения для List<CartItem>                                 */
/*───────────────────────────────────────────────────────────────*/
extension CartItemListX on List<CartItem> {
  int get totalQty => fold(0, (s, e) => s + e.quantity);
  double get totalSum => fold(0.0, (s, e) => s + e.quantity * e.price);
}


