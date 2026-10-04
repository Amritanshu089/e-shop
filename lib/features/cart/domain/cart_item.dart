import 'package:equatable/equatable.dart';

import '../../products/data/models/product_model.dart';

class CartItem extends Equatable {
  final ProductModel product;
  final int quantity;

  const CartItem({
    required this.product,
    required this.quantity,
  });

  double get discountedPrice {
    return product.price -
        (product.price * product.discountPercentage / 100);
  }

  double get totalPrice {
    return discountedPrice * quantity;
  }

  CartItem copyWith({
    ProductModel? product,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [
        product,
        quantity,
      ];
}