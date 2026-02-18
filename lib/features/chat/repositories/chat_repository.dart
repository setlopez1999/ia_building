import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // Added for debugPrint

class ChatRepository {
  final Dio _dio =
      Dio(
          BaseOptions(
            baseUrl: 'https://n8ntest.cd-latam.com',
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {
              'Authorization':
                  'kR_7tY2n5M8x1V9a4S7t0Yp3n-6m8V9a2C1x5Z7D4k3Jq9L0mN2bP5r8E_Wj1hGf',
              'Content-Type': 'application/json',
            },
          ),
        )
        ..interceptors.add(
          LogInterceptor(
            requestBody: true,
            responseBody: true,
            logPrint: (obj) => debugPrint('DIO_LOG: $obj'),
          ),
        );

  Future<String> sendMessage(String message) async {
    try {
      // The user specified the body should look like [{"output": "..."}]
      final response = await _dio.post(
        '/webhook/post_chat',
        data: [
          {'request': message},
        ],
      );

      if (response.statusCode == 200) {
        // Parse response which user says looks like [{"output": "..."}]
        if (response.data is List && response.data.isNotEmpty) {
          final firstItem = response.data[0];
          return firstItem['output']?.toString() ?? 'Sin respuesta';
        } else if (response.data is Map) {
          return response.data['output']?.toString() ?? 'Sin respuesta';
        }
        return 'Respuesta inesperada del servidor';
      }
      return 'Error del servidor: ${response.statusCode}';
    } catch (e) {
      return 'Error de conexión: $e';
    }
  }
}
