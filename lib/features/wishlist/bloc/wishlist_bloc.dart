import 'package:flutter_bloc/flutter_bloc.dart';

import 'wishlist_event.dart';
import 'wishlist_state.dart';

class WishlistBloc
    extends Bloc<WishlistEvent, WishlistState> {
  WishlistBloc()
      : super(const WishlistState()) {
    on<ToggleWishlist>(_onToggleWishlist);
    on<RemoveFromWishlist>(_onRemoveFromWishlist);
    on<ClearWishlist>(_onClearWishlist);
  }

  void _onToggleWishlist(
    ToggleWishlist event,
    Emitter<WishlistState> emit,
  ) {
    final products = List.of(state.products);

    final existingIndex = products.indexWhere(
      (product) => product.id == event.product.id,
    );

    if (existingIndex >= 0) {
      products.removeAt(existingIndex);
    } else {
      products.add(event.product);
    }

    emit(
      state.copyWith(
        products: products,
      ),
    );
  }

  void _onRemoveFromWishlist(
    RemoveFromWishlist event,
    Emitter<WishlistState> emit,
  ) {
    final products = state.products
        .where(
          (product) => product.id != event.productId,
        )
        .toList();

    emit(
      state.copyWith(
        products: products,
      ),
    );
  }

  void _onClearWishlist(
    ClearWishlist event,
    Emitter<WishlistState> emit,
  ) {
    emit(
      const WishlistState(),
    );
  }
}