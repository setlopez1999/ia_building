import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/app_colors.dart';
import '../../../core/providers/providers.dart';
import '../../../data/models/servidor_juego.dart';

class GamingScreen extends ConsumerWidget {
  const GamingScreen({super.key});

  String _gameNameToId(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('counter strike') || lower.contains('cs')) return 'cs2';
    if (lower.contains('dota')) return 'dota2';
    if (lower.contains('fortnite')) return 'fortnite';
    if (lower.contains('valorant')) return 'valorant';
    if (lower.contains('pubg')) return 'pubg';
    return name;
  }

  String _logoForJuego(String juego) {
    final lower = juego.toLowerCase();
    if (lower.contains('counter strike') || lower.contains('cs'))
      return 'assets/logos/logo_cs2.png';
    if (lower.contains('dota')) return 'assets/logos/logo_dota2.png';
    if (lower.contains('fortnite')) return 'assets/logos/logo_fortnite.png';
    if (lower.contains('valorant')) return 'assets/logos/logo_valorant.png';
    if (lower.contains('pubg')) return 'assets/logos/logo_pubg.png';
    return 'assets/logos/logo_valorant.png';
  }

  Color _colorForEstado(String estado) {
    switch (estado) {
      case 'EXCELENTE':
        return const Color(0xFF00D285);
      case 'BUENO':
        return Colors.amber;
      case 'MALO':
        return Colors.orange;
      case 'SIN_CONEXIÓN':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servidoresAsync = ref.watch(servidoresJuegoProvider);

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
            servidoresAsync.when(
              data: (servidores) => _buildGamesList(context, servidores),
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

  Widget _buildGamesList(BuildContext context, List<ServidorJuego> servidores) {
    if (servidores.isEmpty) {
      return const Text(
        'No hay servidores disponibles',
        style: TextStyle(color: AppColors.textBody),
      );
    }
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF32324A),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: servidores.map((sv) => _buildGameRow(context, sv)).toList(),
      ),
    );
  }

  Widget _buildGameRow(BuildContext context, ServidorJuego sv) {
    final statusColor = _colorForEstado(sv.estado);

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: () => context.push('/check_health/gaming/${_gameNameToId(sv.juego)}'),
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
                _logoForJuego(sv.juego),
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
                    sv.juego,
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
              '${sv.pingMs} ms',
              style: TextStyle(
                color: statusColor,
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
