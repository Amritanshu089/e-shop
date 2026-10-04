import 'package:flutter_bloc/flutter_bloc.dart';

import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<IncreaseQuantity>(_onIncreaseQuantity);
    on<DecreaseQuantity>(_onDecreaseQuantity);
    on<ClearCart>(_onClearCart);
  }

  void _onAddToCart(
    AddToCart event,
    Emitter<CartState> emit,
  ) {
    final existingIndex = state.items.indexWhere(
      (item) => item.product.id == event.item.product.id,
    );

    if (existingIndex == -1) {
      emit(
        state.copyWith(
          items: [
            ...state.items,
            event.item,
          ],
        ),
      );

      return;
    }

    final updatedItems = [...state.items];

    final existingItem = updatedItems[existingIndex];

    final newQuantity =
        existingItem.quantity + event.item.quantity;

    updatedItems[existingIndex] = existingItem.copyWith(
      quantity: newQuantity >
              existingItem.product.stock
          ? existingItem.product.stock
          : newQuantity,
    );

    emit(
      state.copyWith(
        items: updatedItems,
      ),
    );
  }

  void _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) {
    final updatedItems = state.items
        .where(
          (item) => item.product.id != event.productId,
        )
        .toList();

    emit(
      state.copyWith(
        items: updatedItems,
      ),
    );
  }

  void _onIncreaseQuantity(
    IncreaseQuantity event,
    Emitter<CartState> emit,
  ) {
    final updatedItems = state.items.map((item) {
      if (item.product.id != event.productId) {
        return item;
      }

      if (item.quantity >= item.product.stock) {
        return item;
      }

      return item.copyWith(
        quantity: item.quantity + 1,
      );
    }).toList();

    emit(
      state.copyWith(
        items: updatedItems,
      ),
    );
  }

  void _onDecreaseQuantity(
    DecreaseQuantity event,
    Emitter<CartState> emit,
  ) {
    final item = state.items.firstWhere(
      (item) => item.product.id == event.productId,
    );

    if (item.quantity <= 1) {
      add(
        RemoveFromCart(event.productId),
      );
      return;
    }

    final updatedItems = state.items.map((item) {
      if (item.product.id != event.productId) {
        return item;
      }

      return item.copyWith(
        quantity: item.quantity - 1,
      );
    }).toList();

    emit(
      state.copyWith(
        items: updatedItems,
      ),
    );
  }

  void _onClearCart(
    ClearCart event,
    Emitter<CartState> emit,
  ) {
    emit(
      const CartState(
        items: [],
      ),
    );
  }
}