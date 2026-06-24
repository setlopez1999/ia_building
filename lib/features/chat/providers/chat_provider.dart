import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/sources/remote/api_client.dart';
import '../../../core/providers/providers.dart';
import '../../../data/sources/local/local_storage.dart';
import '../models/chat_message.dart';
import '../repositories/chat_repository.dart';

part 'chat_provider.g.dart';

@riverpod
ChatRepository chatRepository(ChatRepositoryRef ref) {
  return ChatRepository(apiClient: ref.read(apiClientProvider));
}

@riverpod
class Chat extends _$Chat {
  String? _sessionId;

  @override
  List<ChatMessage> build() {
    return [
      ChatMessage(
        text: 'Hola, soy tu asistente virtual. ¿En qué puedo ayudarte hoy?',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    ];
  }

  Future<void> sendMessage(String text) async {
    final userMessage = ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    state = [...state, userMessage];

    final botTyping = ChatMessage(
      text: '...',
      isUser: false,
      timestamp: DateTime.now(),
    );
    state = [...state, botTyping];

    try {
      final response = await ref.read(chatRepositoryProvider).sendMessage(
        text,
        sessionId: _sessionId,
      );

      if (response['success'] == false) {
        final errMsg = response['msg'] as String? ?? 'Error al procesar el mensaje';
        state = [
          for (final msg in state)
            if (msg == botTyping)
              msg.copyWith(text: errMsg, timestamp: DateTime.now())
            else
              msg,
        ];
        return;
      }

      _sessionId = response['session_id'] as String?;
      if (_sessionId != null) {
        await LocalStorage.setChatSessionId(_sessionId!);
      }

      final reply = response['reply'] as String? ?? 'Sin respuesta';

      state = [
        for (final msg in state)
          if (msg == botTyping)
            msg.copyWith(text: reply, timestamp: DateTime.now())
          else
            msg,
      ];
    } catch (e) {
      String errMsg;
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          errMsg = 'Tiempo de espera agotado. Intenta de nuevo.';
        } else {
          errMsg = 'Error de conexión. Verifica tu red.';
        }
      } else {
        errMsg = 'Error interno. Intenta de nuevo.';
      }
      state = [
        for (final msg in state)
          if (msg == botTyping)
            msg.copyWith(text: errMsg, timestamp: DateTime.now())
          else
            msg,
      ];
    }
  }

  void clearChat() {
    _sessionId = null;
    LocalStorage.removeChatSessionId();
    state = [
      ChatMessage(
        text: 'Chat reiniciado. ¿En qué puedo ayudarte hoy?',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    ];
  }
}
