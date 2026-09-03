class ChatMessage {

  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage copyWith({
    String? text,
    bool? isUser,
    DateTime? timestamp,
  }) {
    return ChatMessage(
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
