import '../datasources/product_remote_data_source.dart';
import '../models/product_model.dart';

class ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepository(this.remoteDataSource);

  Future<List<ProductModel>> getProducts({
    int limit = 20,
    int skip = 0,
  }) {
    return remoteDataSource.getProducts(
      limit: limit,
      skip: skip,
    );
  }

  Future<ProductModel> getProduct(int id) {
    return remoteDataSource.getProduct(id);
  }

  Future<List<ProductModel>> searchProducts(
    String query,
  ) {
    return remoteDataSource.searchProducts(query);
  }

  Future<List<String>> getCategories() {
    return remoteDataSource.getCategories();
  }

  Future<List<ProductModel>> getProductsByCategory(
    String category,
  ) {
    return remoteDataSource.getProductsByCategory(
      category,
    );
  }
}