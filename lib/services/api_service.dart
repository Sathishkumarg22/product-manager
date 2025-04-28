import 'package:demo/services/api_url.dart';
import 'package:dio/dio.dart';
import 'package:demo/services/storage_service.dart';

class ApiService {
  final Dio dio = Dio(BaseOptions(
    baseUrl: ApiUrl.baseUrl,
    validateStatus: (status) => status! < 500,
  ));

  ApiService({Dio? dio}) {
    dio?.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (!options.path.contains(ApiUrl.login)) {
          final token = await StorageService().getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        return handler.next(e);
      },
    ));
  }
}