import 'package:demo/models/product.dart';
import 'package:demo/services/api_service.dart';
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
    final response = await apiService.dio.post('/products', data: product.toJson());
    print('Add Product Response: ${response}');
  } on DioException catch (e) {
    print('Add Product Error: ${e.response?.statusCode} ${e.message}');
    throw 'Error adding product: ${e.message}';
  }
}

  Future<void> updateProduct(Product product) async {
    print('Simulated POST: ${product.toJson()}');
  try {
    final response = await apiService.dio.put('/products/${product.id}', data: product.toJson());
    print('Add Product Response: ${response}');
  } on DioException catch (e) {
    throw 'Error updating product: ${e.message}';
  }
}

Future<void> deleteProduct(int id) async {
  try {
    await apiService.dio.delete('/products/$id');
  } on DioException catch (e) {
    throw 'Error deleting product: ${e.message}';
  }
}

  Future<List<Product>> searchProducts(String query) async {
    try {
      // Fake Store API doesn't support search; implement client-side filtering
      final response = await apiService.dio.get('/products');
      final products = (response.data as List).map((json) => Product.fromJson(json)).toList();
      return products.where((p) => p.name.toLowerCase().contains(query.toLowerCase())).toList();
    } on DioException catch (e) {
      throw 'Error searching products: ${e.message}';
    }
  }
}