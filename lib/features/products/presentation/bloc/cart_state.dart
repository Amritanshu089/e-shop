import 'package:equatable/equatable.dart';

import '../../../cart/domain/cart_item.dart';

class CartState extends Equatable {
  final List<CartItem> items;

  const CartState({
    this.items = const [],
  });

  int get totalItems {
    return items.fold(
      0,
      (total, item) => total + item.quantity,
    );
  }

  double get subtotal {
    return items.fold(
      0,
      (total, item) => total + item.totalPrice,
    );
  }

  double get deliveryFee {
    if (items.isEmpty) {
      return 0;
    }

    return subtotal >= 100 ? 0 : 7.99;
  }

  double get total {
    return subtotal + deliveryFee;
  }

  CartState copyWith({
    List<CartItem>? items,
  }) {
    return CartState(
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [items];
}