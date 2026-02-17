import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/app_colors.dart';

class GamingScreen extends StatefulWidget {
  const GamingScreen({super.key});

  @override
  State<GamingScreen> createState() => _GamingScreenState();
}

class _GamingScreenState extends State<GamingScreen> {
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
          'Gaming',
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
                  Icons.videogame_asset,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Gaming',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Optimizado para competitivos',
              style: TextStyle(color: AppColors.textBody, fontSize: 13),
            ),
            const SizedBox(height: 20),
            _buildGamesList(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildGamesList() {
    final games = [
      {
        'name': 'Riot Games',
        'ping': '25 ms',
        'status': 'Excelente',
        'logo': 'assets/logos/logo_riot.png',
      },
      {
        'name': 'Valve',
        'ping': '39 ms',
        'status': 'Excelente',
        'logo': 'assets/logos/logo_valve.png',
      },
      {
        'name': 'Epic Games',
        'ping': '36 ms',
        'status': 'Excelente',
        'logo': 'assets/logos/logo_epic_games.png',
      },
      {
        'name': 'Activision',
        'ping': '22 ms',
        'status': 'Excelente',
        'logo': 'assets/logos/logo_activision.png',
      },
      {
        'name': 'EA Sports',
        'ping': '46 ms',
        'status': 'Excelente',
        'logo': 'assets/logos/logo_ea.png',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF32324A),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: games.map((game) => _buildGameRow(game)).toList(),
      ),
    );
  }

  Widget _buildGameRow(Map<String, String> game) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(6),
            alignment: Alignment.center,
            child: Image.asset(
              game['logo']!,
              width: 45,
              height: 45,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  game['name']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  game['status']!,
                  style: const TextStyle(
                    color: AppColors.textBody,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Text(
            game['ping']!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
