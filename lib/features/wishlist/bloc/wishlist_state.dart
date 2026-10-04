import 'package:equatable/equatable.dart';

import '../../products/data/models/product_model.dart';

class WishlistState extends Equatable {
  final List<ProductModel> products;

  const WishlistState({
    this.products = const [],
  });

  bool contains(int productId) {
    return products.any(
      (product) => product.id == productId,
    );
  }

  WishlistState copyWith({
    List<ProductModel>? products,
  }) {
    return WishlistState(
      products: products ?? this.products,
    );
  }

  @override
  List<Object?> get props => [products];
}