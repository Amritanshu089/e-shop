import '../../../../core/network/api_client.dart';
import '../models/product_model.dart';

class ProductRemoteDataSource {
  final ApiClient apiClient;

  ProductRemoteDataSource(this.apiClient);

  Future<List<ProductModel>> getProducts({
    int limit = 20,
    int skip = 0,
  }) async {
    final data = await apiClient.get(
      '/products',
      queryParameters: {
        'limit': '$limit',
        'skip': '$skip',
      },
    );

    final products = data['products'] as List;

    return products
        .map(
          (item) => ProductModel.fromJson(item),
        )
        .toList();
  }

  Future<ProductModel> getProduct(int id) async {
    final data = await apiClient.get('/products/$id');

    return ProductModel.fromJson(data);
  }

  Future<List<ProductModel>> searchProducts(
    String query,
  ) async {
    final data = await apiClient.get(
      '/products/search',
      queryParameters: {
        'q': query,
      },
    );

    final products = data['products'] as List;

    return products
        .map(
          (item) => ProductModel.fromJson(item),
        )
        .toList();
  }

  Future<List<String>> getCategories() async {
    final data = await apiClient.get(
      '/products/category-list',
    );

    return List<String>.from(data);
  }

  Future<List<ProductModel>> getProductsByCategory(
    String category,
  ) async {
    final data = await apiClient.get(
      '/products/category/$category',
    );

    final products = data['products'] as List;

    return products
        .map(
          (item) => ProductModel.fromJson(item),
        )
        .toList();
  }
}