import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tvapp/core/theme/app_colors.dart';
import 'package:tvapp/core/domain/entities/tools/servidor_juego.dart';
import 'package:tvapp/ui/providers/tools/gaming_server_providers.dart';
import 'package:tvapp/ui/providers/tools/gaming_monitor_service.dart';
import 'package:tvapp/ui/shared/widgets/juego_logo_widget.dart';
import 'package:tvapp/ui/shared/widgets/app_loading.dart';

class GamingScreen extends ConsumerWidget {
  static const String name = 'Gaming';

  const GamingScreen({super.key});

  Color _colorForEstado(String estado) {
    switch (estado) {
      case 'EXCELENTE':
        return AppColors.success;
      case 'BUENO':
        return Colors.amber;
      case 'MALO':
        return Colors.orange;
      case 'SIN_CONEXIÓN':
        return AppColors.error;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Carga datos desde la API (path original que funciona, refresca cada 10s)
    ref.watch(servidoresJuegoProvider);
    // Activa el monitor; Riverpod lo destruye al salir de la pantalla
    ref.watch(gamingListMonitorProvider);
    // Stream reactivo: recibe datos iniciales + actualizaciones de ping del monitor
    final servidoresAsync = ref.watch(servidoresJuegoStreamProvider);

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
                backgroundColor: AppColors.success,
                child: Icon(Icons.videogame_asset, color: Colors.white, size: 50),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Gaming',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            const Text(
              'Optimizado para competitivos',
              style: TextStyle(color: AppColors.textBody, fontSize: 13),
            ),
            const SizedBox(height: 20),
            servidoresAsync.when(
              data: (servidores) => _GamesListCard(
                servidores: servidores,
                onGameTap: (sv) =>
                    context.push('/tools/gaming/detail', extra: sv.id),
                colorForEstado: _colorForEstado,
              ),
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: AppLoading(message: 'Cargando servidores...'),
              ),
              error: (err, _) =>
                  Text('Error: $err', style: const TextStyle(color: Colors.red)),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _GamesListCard extends StatelessWidget {
  final List<ServidorJuego> servidores;
  final void Function(ServidorJuego) onGameTap;
  final Color Function(String) colorForEstado;

  const _GamesListCard({
    required this.servidores,
    required this.onGameTap,
    required this.colorForEstado,
  });

  @override
  Widget build(BuildContext context) {
    if (servidores.isEmpty) {
      return const Text('No hay servidores disponibles',
          style: TextStyle(color: AppColors.textBody));
    }
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.container,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: servidores
            .map((sv) => _GameRow(
                  servidor: sv,
                  onTap: () => onGameTap(sv),
                  statusColor: colorForEstado(sv.estado),
                ))
            .toList(),
      ),
    );
  }
}

class _GameRow extends StatelessWidget {
  final ServidorJuego servidor;
  final VoidCallback onTap;
  final Color statusColor;

  const _GameRow({
    required this.servidor,
    required this.onTap,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: onTap,
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
              child: JuegoLogoWidget(logo: servidor.logo, size: 33),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    servidor.juego,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Ver Latencia',
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
                  ),
                ],
              ),
            ),
            Text(
              '${servidor.pingMs} ms',
              style: TextStyle(
                  color: statusColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
