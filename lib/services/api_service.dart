import 'package:dio/dio.dart';
import 'package:demo/services/storage_service.dart';

class ApiService {
  final Dio dio = Dio(BaseOptions(
    baseUrl: 'https://fakestoreapi.com/',
    validateStatus: (status) => status! < 500,
  ));

  ApiService() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Only attach token for protected endpoints (exclude login)
        if (!options.path.contains('auth/login')) {
          final token = await StorageService().getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }
        print('Request: ${options.method} ${options.uri}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('Response: ${response.statusCode} ${response.data}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print('API Error: ${e.message}');
        print('Status Code: ${e.response?.statusCode}');
        print('Response Data: ${e.response?.data}');
        return handler.next(e);
      },
    ));
  }
}