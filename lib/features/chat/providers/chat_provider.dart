import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/chat_message.dart';
import '../repositories/chat_repository.dart';

part 'chat_provider.g.dart';

@riverpod
ChatRepository chatRepository(ChatRepositoryRef ref) {
  return ChatRepository();
}

@riverpod
class Chat extends _$Chat {
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
    // 1. Add user message
    final userMessage = ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    state = [...state, userMessage];

    // 2. Add temporary bot message "typing"
    final botTyping = ChatMessage(
      text: '...',
      isUser: false,
      timestamp: DateTime.now(),
    );
    state = [...state, botTyping];

    // 3. Get actual response
    final response = await ref.read(chatRepositoryProvider).sendMessage(text);

    // 4. Update state with real response
    state = [
      for (final msg in state)
        if (msg == botTyping)
          msg.copyWith(text: response, timestamp: DateTime.now())
        else
          msg,
    ];
  }

  void clearChat() {
    state = [
      ChatMessage(
        text: 'Chat reiniciado. ¿En qué puedo ayudarte hoy?',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    ];
  }
}
