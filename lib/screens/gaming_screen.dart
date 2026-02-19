import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../utils/app_colors.dart';
import '../features/gaming/models/game.dart';
import '../features/gaming/providers/gaming_provider.dart';

class GamingScreen extends ConsumerWidget {
  const GamingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamesAsync = ref.watch(gamesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
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
            gamesAsync.when(
              data: (games) => _buildGamesList(context, games),
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 210, 7, 0),
                  ),
                ),
              ),
              error: (err, stack) => Center(
                child: Text(
                  'Error: $err',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildGamesList(BuildContext context, List<Game> games) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF32324A),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: games.map((game) => _buildGameRow(context, game)).toList(),
      ),
    );
  }

  Widget _buildGameRow(BuildContext context, Game game) {
    // Map existing assets if possible, or use placeholder.
    // Since names changed, I'll use a generic icon or try to match.
    String logoAsset = 'assets/logos/logo_valorant.png';
    if (game.name.contains('Counter Strike 2'))
      logoAsset = 'assets/logos/logo_cs2.png';
    if (game.name.contains('Dota')) logoAsset = 'assets/logos/logo_dota2.png';
    if (game.name.contains('Fortnite'))
      logoAsset = 'assets/logos/logo_fortnite.png';
    if (game.name.contains('Valorant'))
      logoAsset = 'assets/logos/logo_valorant.png';
    if (game.name.contains('PUBG')) logoAsset = 'assets/logos/logo_pubg.png';

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: () => context.push('/gaming/${game.id}'),
        borderRadius: BorderRadius.circular(10),
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
                logoAsset,
                width: 45,
                height: 45,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.videogame_asset, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    game.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Ver Latencia',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              game.ping,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
