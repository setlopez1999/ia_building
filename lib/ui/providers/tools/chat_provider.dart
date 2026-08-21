import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tvapp/core/infraestructure/datasource/tools/tools_api_client.dart';
import 'package:tvapp/core/infraestructure/repositories/tools/chat_repository.dart';
import 'package:tvapp/storage/tools/local_storage.dart';
import '../models/chat_message.dart';

part 'chat_provider.g.dart';

@riverpod
ChatRepository chatRepository(Ref ref) {
  return ChatRepository(apiClient: ToolsApiClient());
}

@riverpod
class Chat extends _$Chat {
  String? _sessionId;

  @override
  Future<List<ChatMessage>> build() async {
    _sessionId = LocalStorage.getChatSessionId();

    if (_sessionId != null) {
      try {
        final data = await ref.read(chatRepositoryProvider).getHistory(_sessionId!);
        final raw = data['messages'] as List<dynamic>? ?? [];
        if (raw.isNotEmpty) {
          return raw.map((m) {
            final map = m as Map<String, dynamic>;
            return ChatMessage(
              text: map['content'] as String? ?? '',
              isUser: map['role'] == 'user',
              timestamp: DateTime.tryParse(map['created_at'] as String? ?? '') ?? DateTime.now(),
            );
          }).toList();
        }
      } catch (_) {
        // Historial no disponible — cae al mensaje de bienvenida
      }
    }

    return [
      ChatMessage(
        text: 'Hola, soy tu asistente virtual. ¿En qué puedo ayudarte hoy?',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    ];
  }

  Future<void> sendMessage(String text) async {
    final current = state.asData?.value ?? [];

    final userMessage = ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    final botTyping = ChatMessage(
      text: '...',
      isUser: false,
      timestamp: DateTime.now(),
    );

    state = AsyncData([...current, userMessage, botTyping]);

    try {
      final response = await ref.read(chatRepositoryProvider).sendMessage(
        text,
        sessionId: _sessionId,
      );

      _sessionId = response['session_id'] as String?;
      if (_sessionId != null) {
        await LocalStorage.setChatSessionId(_sessionId!);
      }

      final reply = response['reply'] as String? ?? 'Sin respuesta';
      final msgs = state.asData?.value ?? [];

      state = AsyncData([
        for (final msg in msgs)
          if (msg == botTyping)
            msg.copyWith(text: reply, timestamp: DateTime.now())
          else
            msg,
      ]);
    } catch (_) {
      final msgs = state.asData?.value ?? [];
      state = AsyncData([
        for (final msg in msgs)
          if (msg == botTyping)
            msg.copyWith(text: 'No se pudo enviar el mensaje.', timestamp: DateTime.now())
          else
            msg,
      ]);
    }
  }

  void clearChat() {
    _sessionId = null;
    LocalStorage.removeChatSessionId();
    state = AsyncData([
      ChatMessage(
        text: 'Chat reiniciado. ¿En qué puedo ayudarte hoy?',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    ]);
  }
}
