import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tvapp/core/theme/app_colors.dart';
import 'package:tvapp/ui/providers/tools/chat_provider.dart';
import 'package:tvapp/ui/shared/widgets/app_loading.dart';

class ChatScreen extends ConsumerStatefulWidget {
  static const String name = 'Chat';

  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(bool isSending) {
    if (isSending) return;
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    ref.read(chatProvider.notifier).sendMessage(text);
    _scrollToBottom();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncMessages = ref.watch(chatProvider);
    final msgs = asyncMessages.asData?.value ?? [];
    final isSending = msgs.isNotEmpty && !msgs.last.isUser && msgs.last.text == '...';

    ref.listen(chatProvider, (_, next) {
      if (next.hasValue) _scrollToBottom();
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.canPop() ? context.pop() : context.go('/'),
        ),
        title: const Text(
          'Chat',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            onPressed: isSending ? null : () => ref.read(chatProvider.notifier).clearChat(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: asyncMessages.when(
              loading: () => const AppLoading(message: 'Cargando historial...'),
              error: (_, __) => const AppLoading(message: 'Error al cargar el historial'),
              data: (messages) => ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isLast = index == messages.length - 1;
                  return Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
                    child: message.isUser
                        ? _UserBubble(text: message.text)
                        : _BotBubble(text: message.text),
                  );
                },
              ),
            ),
          ),
          _ChatInputBar(
            controller: _controller,
            isSending: isSending,
            onSend: () => _sendMessage(isSending),
          ),
        ],
      ),
    );
  }
}

class _UserBubble extends StatelessWidget {
  final String text;
  const _UserBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.container,
              borderRadius: BorderRadius.circular(16).copyWith(topRight: Radius.zero),
            ),
            child: Text(text, style: const TextStyle(color: Colors.white)),
          ),
        ),
        const SizedBox(width: 8),
        const CircleAvatar(
          backgroundColor: AppColors.accentBlue,
          radius: 18,
          child: Icon(Icons.person, color: Colors.white, size: 18),
        ),
      ],
    );
  }
}

class _BotBubble extends StatelessWidget {
  final String text;
  const _BotBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    final isTyping = text == '...';
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          backgroundColor: AppColors.accentBlue,
          radius: 18,
          child: Icon(Icons.smart_toy_outlined, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.container,
              borderRadius: BorderRadius.circular(16).copyWith(topLeft: Radius.zero),
            ),
            child: isTyping
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.accentBlue,
                    ),
                  )
                : Text(text, style: const TextStyle(color: AppColors.textBody)),
          ),
        ),
      ],
    );
  }
}

class _ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isSending;

  const _ChatInputBar({
    required this.controller,
    required this.onSend,
    required this.isSending,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.container,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isSending
                  ? Colors.white12
                  : AppColors.accentBlue.withValues(alpha: 0.4),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  textInputAction: TextInputAction.send,
                  enabled: !isSending,
                  // Texto siempre blanco sobre fondo oscuro del container
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: isSending ? 'Esperando respuesta...' : 'Escribe un mensaje...',
                    hintStyle: const TextStyle(color: AppColors.textBody),
                    border: InputBorder.none,
                    // Anula el filled:true del inputDecorationTheme global
                    // para que no sobreescriba el fondo oscuro del container
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                  ),
                  onSubmitted: (_) => onSend(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: AnimatedOpacity(
                  opacity: isSending ? 0.3 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded, color: AppColors.accentBlue),
                    onPressed: isSending ? null : onSend,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
