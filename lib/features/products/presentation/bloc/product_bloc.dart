import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  static const int pageSize = 20;

  int currentSkip = 0;

  ProductBloc(this.repository) : super(const ProductState()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadCategories>(_onLoadCategories);
    on<RefreshProducts>(_onRefreshProducts);
    on<LoadMoreProducts>(_onLoadMoreProducts);
    on<SearchProducts>(_onSearchProducts);
    on<SelectCategory>(_onSelectCategory);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    if (state.status == ProductStatus.loading) {
      return;
    }

    emit(
      state.copyWith(
        status: ProductStatus.loading,
        clearError: true,
      ),
    );

    try {
      currentSkip = 0;

      final List<ProductModel> products =
          await repository.getProducts(
        limit: pageSize,
        skip: currentSkip,
      );

      currentSkip = products.length;

      emit(
        state.copyWith(
          status: ProductStatus.success,
          products: products,
          hasReachedMax: products.length < pageSize,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProductStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<ProductState> emit,
  ) async {
    try {
      final List<String> categories =
          await repository.getCategories();

      emit(
        state.copyWith(
          categories: categories,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onRefreshProducts(
    RefreshProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(
      state.copyWith(
        isRefreshing: true,
        clearError: true,
      ),
    );

    try {
      currentSkip = 0;

      final List<ProductModel> products =
          await repository.getProducts(
        limit: pageSize,
        skip: currentSkip,
      );

      currentSkip = products.length;

      emit(
        state.copyWith(
          status: ProductStatus.success,
          products: products,
          isRefreshing: false,
          hasReachedMax: products.length < pageSize,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isRefreshing: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadMoreProducts(
    LoadMoreProducts event,
    Emitter<ProductState> emit,
  ) async {
    if (state.isLoadingMore || state.hasReachedMax) {
      return;
    }

    emit(
      state.copyWith(
        isLoadingMore: true,
        clearError: true,
      ),
    );

    try {
      final List<ProductModel> newProducts =
          await repository.getProducts(
        limit: pageSize,
        skip: currentSkip,
      );

      currentSkip += newProducts.length;

      final List<ProductModel> allProducts = [
        ...state.products,
        ...newProducts,
      ];

      emit(
        state.copyWith(
          products: allProducts,
          isLoadingMore: false,
          hasReachedMax: newProducts.length < pageSize,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingMore: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<ProductState> emit,
  ) async {
    final query = event.query.trim();

    if (query.isEmpty) {
      emit(
        state.copyWith(
          searchQuery: '',
          searchResults: const [],
          clearError: true,
        ),
      );

      return;
    }

    emit(
      state.copyWith(
        searchQuery: query,
        clearError: true,
      ),
    );

    try {
      final List<ProductModel> results =
          await repository.searchProducts(query);

      emit(
        state.copyWith(
          searchQuery: query,
          searchResults: results,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onSelectCategory(
    SelectCategory event,
    Emitter<ProductState> emit,
  ) async {
    if (event.category == null ||
        event.category!.isEmpty) {
      emit(
        state.copyWith(
          clearSelectedCategory: true,
          clearError: true,
        ),
      );

      add(const LoadProducts());
      return;
    }

    emit(
      state.copyWith(
        selectedCategory: event.category,
        status: ProductStatus.loading,
        clearError: true,
      ),
    );

    try {
      final List<ProductModel> products =
          await repository.getProductsByCategory(
        event.category!,
      );

      emit(
        state.copyWith(
          status: ProductStatus.success,
          products: products,
          hasReachedMax: true,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProductStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}