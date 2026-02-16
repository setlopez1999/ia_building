import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'package:go_router/go_router.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        title: const Text(
          'Chat',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildUserMessage(
                  "Hola, tengo dudas sobre mi conexión de internet",
                ),
                const SizedBox(height: 20),
                _buildBotMessage(
                  "Hola, Buenas tardes. Cuentame el detalle para poder ayudarte",
                ),
              ],
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildUserMessage(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFF32324A),
              borderRadius: BorderRadius.circular(
                15,
              ).copyWith(topRight: Radius.zero),
            ),
            child: Text(
              text,
              style: const TextStyle(color: AppColors.textBody),
            ),
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

  Widget _buildBotMessage(String text) {
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
              borderRadius: BorderRadius.circular(
                15,
              ).copyWith(topLeft: Radius.zero),
            ),
            child: Text(
              text,
              style: const TextStyle(color: AppColors.textBody),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.sentiment_satisfied_alt_outlined,
                color: Color(0xFF7B61FF),
              ),
              onPressed: () {},
            ),
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: '',
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send_outlined, color: Color(0xFF7B61FF)),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
