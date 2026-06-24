import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/app_colors.dart';
import '../../../core/providers/providers.dart';

class HistorialScreen extends ConsumerWidget {
  const HistorialScreen({super.key});

  Color _colorForResultado(String resultado) {
    if (resultado.startsWith('EXCELENTE')) return const Color(0xFF00D285);
    if (resultado.startsWith('BUENO')) return const Color(0xFF2196F3);
    if (resultado.startsWith('REGULAR')) return const Color(0xFFFF9800);
    if (resultado.startsWith('MALO')) return const Color(0xFFF44336);
    return Colors.grey;
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays == 0) {
      return 'Hoy, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays == 1) {
      return 'Ayer, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } else {
      return '${dt.day}/${dt.month}/${dt.year}';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historialAsync = ref.watch(historialDiagnosticoProvider);

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
          'Historial',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: historialAsync.when(
          data: (historial) {
            if (historial.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: Text(
                    'No hay diagnósticos registrados',
                    style: TextStyle(color: AppColors.textBody, fontSize: 16),
                  ),
                ),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Historial de diagnósticos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                ...List.generate(historial.length, (index) {
                  final d = historial[index];
                  final isLast = index == historial.length - 1;
                  return _buildTimelineItem(
                    status: d.resultado,
                    color: _colorForResultado(d.resultado),
                    time: _formatDate(d.fecha),
                    metrics:
                        'Velocidad: ${d.velocidadBajadaMbps.toStringAsFixed(0)} Mbps - Latencia: ${d.latenciaIspMs} ms',
                    isLast: isLast,
                  );
                }),
              ],
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 60),
              child: CircularProgressIndicator(color: Color(0xFF00D285)),
            ),
          ),
          error: (err, _) => Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Text(
                'Error al cargar historial',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required String status,
    required Color color,
    required String time,
    required String metrics,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              if (!isLast)
                Expanded(child: Container(width: 2, color: Colors.white24)),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3F3D53),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            status,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            time,
                            style: const TextStyle(
                              color: Color(0xFF867DE5),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        metrics,
                        style: const TextStyle(
                          color: AppColors.textBody,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Ver detalles',
                        style: TextStyle(
                          color: AppColors.textBody,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
