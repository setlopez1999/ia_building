import '../repositories/i_chat_repository.dart';

class SendChatMessage {
  final IChatRepository repository;

  SendChatMessage(this.repository);

  Future<String> call(String message) {
    return repository.sendMessage(message);
  }
}
