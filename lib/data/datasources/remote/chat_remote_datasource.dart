import 'package:dio/dio.dart';
import '../../../core/config/env_config.dart';
import '../../models/chat_response_dto.dart';

class ChatRemoteDataSource {
  final Dio _dio;

  ChatRemoteDataSource()
      : _dio = Dio(
          BaseOptions(
            baseUrl: EnvConfig.chatBaseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {
              'Authorization': EnvConfig.chatApiToken,
              'Content-Type': 'application/json',
            },
          ),
        );

  Future<String> sendMessage(String message) async {
    try {
      final response = await _dio.post(
        '/webhook/post_chat',
        data: [
          {'request': message},
        ],
      );

      if (response.statusCode == 200) {
        if (response.data is List && response.data.isNotEmpty) {
          return ChatResponseDto.fromJson(response.data[0]).resolve();
        } else if (response.data is Map) {
          return ChatResponseDto.fromJson(response.data as Map<String, dynamic>).resolve();
        }
        return 'Respuesta inesperada del servidor';
      }
      return 'Error del servidor: ${response.statusCode}';
    } catch (e) {
      return 'Error de conexión: $e';
    }
  }
}
