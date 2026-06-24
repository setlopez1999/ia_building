import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/providers/providers.dart';
import '../../../shared/data/local/local_storage.dart';
import '../models/chat_message.dart';
import '../repositories/chat_repository.dart';

part 'chat_provider.g.dart';

@riverpod
ChatRepository chatRepository(ChatRepositoryRef ref) {
  return ChatRepository(apiClient: ref.watch(apiClientProvider));
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

    final response = await ref.read(chatRepositoryProvider).sendMessage(
      text,
      sessionId: _sessionId,
    );

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
