import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductEvent {
  const LoadProducts();
}

class LoadCategories extends ProductEvent {
  const LoadCategories();
}

class RefreshProducts extends ProductEvent {
  const RefreshProducts();
}

class LoadMoreProducts extends ProductEvent {
  const LoadMoreProducts();
}

class SearchProducts extends ProductEvent {
  final String query;

  const SearchProducts(this.query);

  @override
  List<Object?> get props => [query];
}

class SelectCategory extends ProductEvent {
  final String? category;

  const SelectCategory(this.category);

  @override
  List<Object?> get props => [category];
}