// lib/state/cart_state.dart
//
// Единственный «источник-правды» для корзины.
//   ref.watch(cartStateProvider)            → список CartItem’ов
//   ref.read(cartStateProvider).totalQty    → общее кол-во (через notifer)
//   ref.watch(cartStateProvider).totalQty   → общее кол-во (через extension)
//
// Изменения: ref.read(cartStateProvider.notifier).inc(item) и т.п.

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/cart.dart';

part 'cart_state.g.dart'; // ← генерируется build_runner’ом

/*───────────────────────────────────────────────────────────────*/
/*                STATE  =  List<CartItem>                       */
/*───────────────────────────────────────────────────────────────*/
@riverpod
class CartState extends _$CartState {
  /* ---------------- initial ---------------- */
  @override
  List<CartItem> build() => [];

  /* ---------------- public API ------------- */
  void set(List<CartItem> items) => state = List.from(items);

  void inc(CartItem ci) => _update(ci, ci.quantity + 1);
  void dec(CartItem ci) => _update(ci, ci.quantity - 1);
  void remove(CartItem ci) =>
      state = state.where((e) => e.id != ci.id).toList();

  /* ---------------- selectors -------------- */
  int    get totalQty => state.fold(0,   (s, e) => s + e.quantity);
  double get totalSum =>
      state.fold(0.0, (s, e) => s + e.quantity * e.price);

  /* ---------------- internal --------------- */
  void _update(CartItem ci, int newQty) {
    if (newQty <= 0) return remove(ci);
    state = [
      for (final e in state)
        e.id == ci.id ? e.copyWith(quantity: newQty) : e,
    ];
  }
}

/*───────────────────────────────────────────────────────────────*/
/*      Расширяем CartItem методом copyWith (удобно для _update) */
/*───────────────────────────────────────────────────────────────*/
extension CartItemCopy on CartItem {
  CartItem copyWith({int? quantity}) => CartItem(
        id: id,
        cartId: cartId,
        menuItemId: menuItemId,
        name: name,
        quantity: quantity ?? this.quantity,
        price: price,
        imageUrl: imageUrl,
      );
}

/*───────────────────────────────────────────────────────────────*/
/*   📌  Новый extension для самого List<CartItem>               */
/*───────────────────────────────────────────────────────────────*/
extension CartItemListX on List<CartItem> {
  /// Сумма всех количеств
  int get totalQty  => fold(0,   (s, e) => s + e.quantity);

  /// Итоговая стоимость (qty × price для каждой позиции)
  double get totalSum => fold(0.0, (s, e) => s + e.quantity * e.price);
}

