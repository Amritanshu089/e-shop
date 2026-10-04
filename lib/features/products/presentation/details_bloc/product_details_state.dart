import 'package:equatable/equatable.dart';

import '../../data/models/product_model.dart';

enum ProductDetailsStatus {
  initial,
  loading,
  success,
  failure,
}

class ProductDetailsState extends Equatable {
  final ProductDetailsStatus status;
  final ProductModel? product;
  final String? errorMessage;

  const ProductDetailsState({
    this.status = ProductDetailsStatus.initial,
    this.product,
    this.errorMessage,
  });

  ProductDetailsState copyWith({
    ProductDetailsStatus? status,
    ProductModel? product,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProductDetailsState(
      status: status ?? this.status,
      product: product ?? this.product,
      errorMessage:
          clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        product,
        errorMessage,
      ];
}