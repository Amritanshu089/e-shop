import 'package:equatable/equatable.dart';

import '../../products/data/models/product_model.dart';

abstract class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object?> get props => [];
}

class ToggleWishlist extends WishlistEvent {
  final ProductModel product;

  const ToggleWishlist(this.product);

  @override
  List<Object?> get props => [product];
}

class RemoveFromWishlist extends WishlistEvent {
  final int productId;

  const RemoveFromWishlist(this.productId);

  @override
  List<Object?> get props => [productId];
}

class ClearWishlist extends WishlistEvent {
  const ClearWishlist();
}