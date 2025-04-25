import 'package:dio/dio.dart';
import 'package:demo/services/api_service.dart';
import 'package:demo/services/storage_service.dart';

class AuthRepository {
  final ApiService apiService = ApiService();
  final StorageService storageService;

  AuthRepository({required this.storageService});

  Future<String> login(String username, String password) async {
    try {
      final response = await apiService.dio.post(
        'auth/login',
        data: {
          'username': "mor_2314",
          'password': "83r5^_",
        },
      );
      print('Login Response: ${response.data}');
      
      if (response.statusCode == 200 && response.data['token'] != null) {
        final token = response.data['token'] as String;
        await storageService.saveToken(token);
        return token;
      } else {
        throw 'Login failed: Invalid response from server';
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw 'Login endpoint not found. Please check the API configuration.';
      } else if (e.response?.statusCode == 401) {
        throw 'Invalid username or password.';
      } else {
        throw 'Login error: ${e.message}';
      }
    } catch (e) {
      throw 'Unexpected error: $e';
    }
  }

  Future<void> logout() async {
    await storageService.clearToken();
  }

  Future<String?> getToken() async {
    return await storageService.getToken();
  }
}