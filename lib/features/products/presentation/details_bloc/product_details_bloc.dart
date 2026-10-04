import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/product_repository.dart';
import 'product_details_event.dart';
import 'product_details_state.dart';

class ProductDetailsBloc
    extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  final ProductRepository repository;

  ProductDetailsBloc(this.repository)
      : super(const ProductDetailsState()) {
    on<LoadProductDetails>(_onLoadProductDetails);
  }

  Future<void> _onLoadProductDetails(
    LoadProductDetails event,
    Emitter<ProductDetailsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ProductDetailsStatus.loading,
        clearError: true,
      ),
    );

    try {
      final product = await repository.getProduct(
        event.productId,
      );

      emit(
        state.copyWith(
          status: ProductDetailsStatus.success,
          product: product,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProductDetailsStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}