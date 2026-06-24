import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../local/local_storage.dart';
import '../../../core/constants/app_constants.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient({String? baseUrl}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Content-Type': 'application/json'},
        validateStatus: (_) => true,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = LocalStorage.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          debugPrint('[ApiClient] Error ${error.response?.statusCode}: ${error.message}');
          return handler.next(error);
        },
      ),
    );

    if (kDebugMode || AppConstants.appDebug) {
      _dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    }
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? queryParams}) async {
    final response = await _dio.get(path, queryParameters: queryParams);
    return response.data;
  }

  Future<dynamic> post(String path, {dynamic body}) async {
    final response = await _dio.post(path, data: body);
    return response.data;
  }

  Future<dynamic> put(String path, {dynamic body}) async {
    final response = await _dio.put(path, data: body);
    return response.data;
  }

  Future<dynamic> delete(String path) async {
    final response = await _dio.delete(path);
    return response.data;
  }
}
