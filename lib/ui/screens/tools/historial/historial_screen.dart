import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tvapp/core/domain/entities/tools/diagnostico.dart';
import 'package:tvapp/core/theme/app_colors.dart';
import 'package:tvapp/ui/providers/tools/diagnostico_providers.dart';
import 'package:tvapp/ui/shared/widgets/app_loading.dart';

class HistorialScreen extends ConsumerWidget {
  static const String name = 'Historial';
  static const String path = '/tools/historial';

  const HistorialScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historialAsync = ref.watch(historialDiagnosticoProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Historial de diagnósticos',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: historialAsync.when(
        loading: () => const AppLoading(message: 'Cargando historial...'),
        error: (_, __) => const Center(
          child: Text(
            'No se pudo cargar el historial',
            style: TextStyle(color: AppColors.textBody),
          ),
        ),
        data: (items) => items.isEmpty
            ? const Center(
                child: Text(
                  'Sin diagnósticos previos',
                  style: TextStyle(color: AppColors.textBody),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, index) => _DiagnosticoItem(item: items[index]),
              ),
      ),
    );
  }
}

// ── Widgets privados ──────────────────────────────────────────────────────────

class _DiagnosticoItem extends StatelessWidget {
  final Diagnostico item;

  const _DiagnosticoItem({required this.item});

  // Mismos colores/umbrales que diagnostico_result_screen.dart — un solo
  // resultado ('resultado'), pintado igual en cualquier pantalla que lo muestre.
  Color get _colorResultado {
    if (item.resultado.contains('EXCELENTE')) return const Color(0xFF00D285);
    if (item.resultado.contains('BUENO')) return const Color(0xFF8BC34A);
    if (item.resultado.contains('REGULAR')) return const Color(0xFFFFA726);
    return const Color(0xFFF44336);
  }

  IconData get _iconResultado {
    if (item.resultado.contains('EXCELENTE')) return Icons.check_circle;
    if (item.resultado.contains('BUENO')) return Icons.check_circle;
    if (item.resultado.contains('REGULAR')) return Icons.warning_amber_rounded;
    return Icons.cancel;
  }

  String get _fechaRelativa {
    final diff = DateTime.now().difference(item.fecha);
    if (diff.inMinutes < 1) {
      return 'Ahora';
    }
    if (diff.inMinutes < 60) {
      return 'Hace ${diff.inMinutes} min';
    }
    if (diff.inHours < 24) {
      return 'Hace ${diff.inHours} h';
    }
    if (diff.inDays == 1) {
      return 'Ayer';
    }
    return 'Hace ${diff.inDays} días';
  }

  @override
  Widget build(BuildContext context) {
    final color = _colorResultado;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.container,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(_iconResultado, color: color, size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.resultado,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '↓ ${item.velocidadBajadaMbps.toStringAsFixed(1)} Mbps  ·  ${item.latenciaIspMs} ms',
                  style: const TextStyle(color: AppColors.textBody, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            _fechaRelativa,
            style: const TextStyle(color: AppColors.textBody, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
