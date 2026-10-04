import 'package:equatable/equatable.dart';

import '../../data/models/product_model.dart';

enum ProductStatus {
  initial,
  loading,
  success,
  failure,
}

class ProductState extends Equatable {
  final ProductStatus status;
  final List<ProductModel> products;
  final List<ProductModel> searchResults;
  final List<String> categories;

  final String searchQuery;
  final String? selectedCategory;

  final bool isRefreshing;
  final bool isLoadingMore;
  final bool hasReachedMax;

  final String? errorMessage;

  const ProductState({
    this.status = ProductStatus.initial,
    this.products = const [],
    this.searchResults = const [],
    this.categories = const [],
    this.searchQuery = '',
    this.selectedCategory,
    this.isRefreshing = false,
    this.isLoadingMore = false,
    this.hasReachedMax = false,
    this.errorMessage,
  });

  ProductState copyWith({
    ProductStatus? status,
    List<ProductModel>? products,
    List<ProductModel>? searchResults,
    List<String>? categories,
    String? searchQuery,
    String? selectedCategory,
    bool clearSelectedCategory = false,
    bool? isRefreshing,
    bool? isLoadingMore,
    bool? hasReachedMax,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      searchResults: searchResults ?? this.searchResults,
      categories: categories ?? this.categories,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: clearSelectedCategory
          ? null
          : selectedCategory ?? this.selectedCategory,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage:
          clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  List<ProductModel> get visibleProducts {
    if (searchQuery.trim().isNotEmpty) {
      return searchResults;
    }

    return products;
  }

  @override
  List<Object?> get props => [
        status,
        products,
        searchResults,
        categories,
        searchQuery,
        selectedCategory,
        isRefreshing,
        isLoadingMore,
        hasReachedMax,
        errorMessage,
      ];
}