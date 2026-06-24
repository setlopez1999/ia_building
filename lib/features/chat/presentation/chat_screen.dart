import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/chat_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
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

  void _sendMessage() {
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
    final messages = ref.watch(chatProvider);
    ref.listen(chatProvider, (_, __) => _scrollToBottom());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
            onPressed: () => ref.read(chatProvider.notifier).clearChat(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isLast = index == messages.length - 1;
                return Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
                  child: message.isUser
                      ? _UserBubble(text: message.text)
                      : _BotBubble(text: message.text),
                );
              },
            ),
          ),
          _ChatInputBar(
            controller: _controller,
            onSend: _sendMessage,
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
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFF32324A),
              borderRadius: BorderRadius.circular(15).copyWith(topRight: Radius.zero),
            ),
            child: Text(text, style: const TextStyle(color: AppColors.textBody)),
          ),
        ),
        const SizedBox(width: 10),
        const CircleAvatar(
          backgroundColor: Colors.white,
          radius: 20,
          child: Icon(Icons.person, color: Colors.black, size: 20),
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
          backgroundColor: Color(0xFF7B61FF),
          radius: 20,
          child: Icon(Icons.smart_toy_outlined, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFF32324A),
              borderRadius: BorderRadius.circular(15).copyWith(topLeft: Radius.zero),
            ),
            child: isTyping
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF7B61FF)),
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

  const _ChatInputBar({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.send,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  hintText: 'Escribe un mensaje...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => onSend(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send_outlined, color: Color(0xFF7B61FF)),
              onPressed: onSend,
            ),
          ],
        ),
      ),
    );
  }
}
