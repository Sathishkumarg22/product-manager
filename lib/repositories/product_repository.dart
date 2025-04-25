import 'package:demo/models/product.dart';
import 'package:demo/services/api_service.dart';
import 'package:demo/services/api_url.dart';
import 'package:dio/dio.dart';

class ProductRepository {
  final ApiService apiService = ApiService();

  Future<List<Product>> getProducts() async {
    try {
      final response = await apiService.dio.get('/products');
      return (response.data as List).map((json) {
        return Product.fromJson(json);
      }).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw 'Products endpoint not found.';
      } else if (e.response?.statusCode == 401) {
        throw 'Unauthorized access to products.';
      } else {
        throw 'Error fetching products: ${e.message}';
      }
    } catch (e) {
      throw 'Unexpected error: $e';
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final response = await apiService.dio.post(
        ApiUrl.productList,
        data: product.toJson(),
      );
      return response.data;
    } on DioException catch (e) {
      throw 'Error adding product: ${e.message}';
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      final response = await apiService.dio.put(
        '${ApiUrl.productList}/${product.id}',
        data: product.toJson(),
      );
      return response.data;
    } on DioException catch (e) {
      throw 'Error updating product: ${e.message}';
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await apiService.dio.delete('${ApiUrl.productList}/$id');
    } on DioException catch (e) {
      throw 'Error deleting product: ${e.message}';
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await apiService.dio.get(ApiUrl.productList);
      final products =
          (response.data as List)
              .map((json) => Product.fromJson(json))
              .toList();
      return products
          .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } on DioException catch (e) {
      throw 'Error searching products: ${e.message}';
    }
  }
}
