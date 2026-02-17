import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/app_colors.dart';

class StreamingScreen extends StatefulWidget {
  const StreamingScreen({super.key});

  @override
  State<StreamingScreen> createState() => _StreamingScreenState();
}

class _StreamingScreenState extends State<StreamingScreen> {
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
          'Streaming',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xFF00D285),
                child: Icon(
                  Icons.play_circle_fill,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Streaming Quality',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Rendimiento para video en 4K/UHD',
              style: TextStyle(color: AppColors.textBody, fontSize: 13),
            ),
            const SizedBox(height: 20),
            _buildPlatformsList(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformsList() {
    final platforms = [
      {
        'name': 'Netflix',
        'quality': '4K UHD',
        'status': 'Excelente',
        'icon': Icons.movie,
      },
      {
        'name': 'Disney+',
        'quality': '4K UHD',
        'status': 'Excelente',
        'icon': Icons.animation,
      },
      {
        'name': 'YouTube',
        'quality': '8K Ready',
        'status': 'Excelente',
        'icon': Icons.play_arrow,
      },
      {
        'name': 'Twitch',
        'quality': '1080p 60fps',
        'status': 'Excelente',
        'icon': Icons.live_tv,
      },
      {
        'name': 'Prime Video',
        'quality': '4K UHD',
        'status': 'Excelente',
        'icon': Icons.video_library,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF32324A),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: platforms.map((p) => _buildPlatformRow(p)).toList(),
      ),
    );
  }

  Widget _buildPlatformRow(Map<String, dynamic> platform) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: const Color(0xFF1F1F30),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(6),
            alignment: Alignment.center,
            child: Icon(
              platform['icon'] as IconData,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  platform['name'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  platform['status'] as String,
                  style: const TextStyle(
                    color: AppColors.textBody,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Text(
            platform['quality'] as String,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
