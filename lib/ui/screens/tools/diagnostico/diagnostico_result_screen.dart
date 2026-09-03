import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tvapp/core/theme/app_colors.dart';
import 'package:tvapp/ui/providers/tools/diagnostico_notifier.dart';
import 'package:tvapp/ui/providers/tools/dispositivos_providers.dart';
import 'package:tvapp/ui/screens/tools/diagnostico/diagnostico_screen.dart';

// ── Colores y puntuaciones compartidas ─────────────────────────────────────────
// Un solo lugar para cada fórmula: el badge de arriba promedia estos mismos
// puntajes, así que nunca puede quedar desincronizado con las tarjetas.

Color colorPorCalidad(ItemCalidad c) {
  switch (c) {
    case ItemCalidad.bueno:   return const Color(0xFF00D285);
    case ItemCalidad.regular: return Colors.orange;
    case ItemCalidad.malo:    return const Color(0xFFF44336);
    default:                  return Colors.grey;
  }
}

double scoreVelocidad(ItemCalidad calidad, double? bajadaMbps) {
  final mbps = bajadaMbps ?? 0;
  switch (calidad) {
    case ItemCalidad.bueno:
      return (8.5 + (mbps - 20).clamp(0, 80) / 80 * 1.5).clamp(8.5, 10.0);
    case ItemCalidad.regular:
      return (5.0 + (mbps - 5) / 15 * 3.4).clamp(5.0, 8.4);
    case ItemCalidad.malo:
      return (mbps / 5 * 4.9).clamp(0.0, 4.9);
    default:
      return 0;
  }
}

ItemCalidad calidadWifiSenal(int? dbm) {
  if (dbm == null) return ItemCalidad.fallido;
  if (dbm >= -60) return ItemCalidad.bueno;
  if (dbm >= -70) return ItemCalidad.regular;
  return ItemCalidad.malo;
}

/// Puntuación 0-10 — más cerca de 0 dBm es mejor señal.
double scoreWifi(int? senialDbm) {
  if (senialDbm == null) return 0;
  final dbm = senialDbm;
  switch (calidadWifiSenal(dbm)) {
    case ItemCalidad.bueno:
      return (8.5 + ((dbm + 60).clamp(0, 30) / 30) * 1.5).clamp(8.5, 10.0);
    case ItemCalidad.regular:
      return (5.0 + ((dbm + 70).clamp(0, 9) / 9) * 3.4).clamp(5.0, 8.4);
    case ItemCalidad.malo:
      return (((dbm + 90).clamp(0, 19) / 19) * 4.9).clamp(0.0, 4.9);
    default:
      return 0;
  }
}

/// Sin un número continuo confiable (potencia viene como texto) — puntuación fija por nivel.
double scoreFibra(ItemCalidad calidad) {
  switch (calidad) {
    case ItemCalidad.bueno:   return 9.5;
    case ItemCalidad.regular: return 6.5;
    case ItemCalidad.malo:    return 2.5;
    default:                  return 0;
  }
}

/// Puntuación 0-10 según el peor (mayor) ms entre Google e ISP — menos ms es mejor.
double scoreLatencia(int? googleMs, int? ispMs) {
  final valores = [googleMs, ispMs].whereType<int>().where((v) => v > 0);
  if (valores.isEmpty) return 0;
  final peorMs = valores.reduce((a, b) => a > b ? a : b);

  if (peorMs < 100) {
    return (10.0 - (peorMs / 100) * 1.5).clamp(8.5, 10.0);
  }
  if (peorMs < 250) {
    return (8.4 - ((peorMs - 100) / 150) * 3.4).clamp(5.0, 8.4);
  }
  return (4.9 - ((peorMs - 250).clamp(0, 250) / 250) * 4.9).clamp(0.0, 4.9);
}

/// Peor de las dos calidades — determina el color de la tarjeta combinada.
ItemCalidad peorCalidad(ItemCalidad a, ItemCalidad b) {
  const orden = {
    ItemCalidad.fallido: 0,
    ItemCalidad.malo: 1,
    ItemCalidad.regular: 2,
    ItemCalidad.cargando: 3,
    ItemCalidad.pendiente: 3,
    ItemCalidad.bueno: 4,
  };
  return orden[a]! <= orden[b]! ? a : b;
}

class DiagnosticoResultScreen extends ConsumerWidget {

  const DiagnosticoResultScreen({super.key});
  static const String name = 'DiagnosticoResult';

  String _subtitleFibra(DiagnosticoState s) {
    if (s.calidadFibra == ItemCalidad.fallido) return 'No se pudo verificar la fibra';
    if (s.calidadFibra == ItemCalidad.malo) return 'Estado: ${s.fibraEstado}';
    final potencia = s.fibraPotenciaDbm ?? '--';
    return '${s.fibraEstado}  ·  $potencia dBm';
  }

  Color _colorResultado(String? r) {
    if (r == null) return Colors.grey;
    if (r.contains('EXCELENTE')) return const Color(0xFF00D285);
    if (r.contains('BUENO')) return const Color(0xFF8BC34A);
    if (r.contains('REGULAR')) return const Color(0xFFFFA726);
    return const Color(0xFFF44336);
  }

  IconData _iconResultado(String? r) {
    if (r?.contains('EXCELENTE') == true) return Icons.check_circle_outline;
    if (r?.contains('BUENO') == true) return Icons.check_circle_outline;
    if (r?.contains('REGULAR') == true) return Icons.warning_amber_rounded;
    return Icons.cancel_outlined;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(diagnosticoNotifierProvider);
    final deviceCount = ref.watch(dispositivosProvider).maybeWhen(
          data: (d) => d.length,
          orElse: () => null,
        );

    // El badge SIEMPRE debe reflejar exactamente lo que quedó guardado en el
    // backend (state.resultadoFinal) — es lo mismo que después se lee en el
    // historial. Si se calculara aparte (ej. promedio local), podría mostrar
    // "EXCELENTE" aquí y "MALO" en el historial para el mismo diagnóstico.
    final resultadoLabel = state.resultadoFinal ?? 'Completado';
    final resultColor = _colorResultado(state.resultadoFinal);
    final resultIcon = _iconResultado(state.resultadoFinal);

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
          'Resultado',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: resultColor.withOpacity(0.15),
                border: Border.all(color: resultColor, width: 3),
              ),
              child: Icon(resultIcon, color: resultColor, size: 60),
            ),
            const SizedBox(height: 20),
            Text(
              resultadoLabel,
              style: TextStyle(
                  color: resultColor,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Diagnóstico de red completado',
              style: TextStyle(color: AppColors.textBody, fontSize: 14),
            ),
            const SizedBox(height: 40),
            _VelocidadResultItem(
              calidad: state.calidadVelocidad,
              bajadaMbps: state.velocidadBajadaMbps,
              subidaMbps: state.velocidadSubidaMbps,
            ),
            const SizedBox(height: 12),
            _WifiResultItem(
              senialDbm: state.wifiSenialDbm,
              banda: state.wifiBanda,
            ),
            const SizedBox(height: 12),
            _FibraResultItem(
              calidad: state.calidadFibra,
              subtitle: _subtitleFibra(state),
            ),
            const SizedBox(height: 12),
            _LatenciaResultItem(
              calidad: peorCalidad(state.calidadGoogle, state.calidadIsp),
              googleMs: state.latenciaGoogleMs,
              ispMs: state.latenciaIspMs,
            ),
            const SizedBox(height: 20),
            _RecomendacionesCard(
              wifiSubtitle: deviceCount == null
                  ? 'No se pudo obtener el conteo de dispositivos'
                  : deviceCount > 3
                      ? 'Tienes $deviceCount dispositivos conectados. Considera desconectar los que no uses.'
                      : 'Tienes $deviceCount dispositivos conectados.',
            ),
            const SizedBox(height: 40),
            InkWell(
              onTap: () => context.pushReplacementNamed(DiagnosticoScreen.name),
              borderRadius: BorderRadius.circular(15),
              child: Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.refresh, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'Nuevo diagnóstico',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _RecomendacionesCard extends StatelessWidget {

  const _RecomendacionesCard({required this.wifiSubtitle});
  final String wifiSubtitle;

  static const _color = AppColors.accentBlue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF32324A),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: _color.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Recomendaciones',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          const SizedBox(height: 15),
          _item('Optimiza tu wifi', wifiSubtitle),
          const SizedBox(height: 15),
          _item(
            'Ubicación',
            'Tu señal wifi podría mejorar reubicando el router en un lugar central.',
          ),
        ],
      ),
    );
  }

  Widget _item(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14)),
        const SizedBox(height: 2),
        Text(subtitle,
            style: const TextStyle(color: AppColors.textBody, fontSize: 12)),
      ],
    );
  }
}

class _VelocidadResultItem extends StatelessWidget {

  const _VelocidadResultItem({
    required this.calidad,
    required this.bajadaMbps,
    required this.subidaMbps,
  });
  final ItemCalidad calidad;
  final double? bajadaMbps;
  final double? subidaMbps;

  @override
  Widget build(BuildContext context) {
    final color = colorPorCalidad(calidad);
    final score = scoreVelocidad(calidad, bajadaMbps);
    final fallido = calidad == ItemCalidad.fallido;
    final down = bajadaMbps?.toStringAsFixed(1) ?? '--';
    final up = subidaMbps?.toStringAsFixed(1) ?? '--';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF32324A),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: color, size: 22),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Velocidad de internet',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
                if (fallido)
                  const Text('Sin conexión a internet',
                      style: TextStyle(color: Colors.grey, fontSize: 12))
                else ...[
                  Text('Descarga: $down Mbps',
                      style: TextStyle(color: color, fontSize: 12)),
                  Text('Carga: $up Mbps',
                      style: TextStyle(color: color, fontSize: 12)),
                ],
              ],
            ),
          ),
          Text(
            '${score.toStringAsFixed(1)}/10',
            style: TextStyle(
                color: color, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _WifiResultItem extends StatelessWidget {

  const _WifiResultItem({required this.senialDbm, required this.banda});
  final int? senialDbm;
  final String? banda;

  @override
  Widget build(BuildContext context) {
    final calidad = calidadWifiSenal(senialDbm);
    final color = colorPorCalidad(calidad);
    final score = scoreWifi(senialDbm);
    final fallido = calidad == ItemCalidad.fallido;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF32324A),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: color, size: 22),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Red WiFi',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
                if (fallido)
                  const Text('Sin datos de señal',
                      style: TextStyle(color: Colors.grey, fontSize: 12))
                else
                  Text('$senialDbm dBm  ·  ${banda ?? '--'}',
                      style: TextStyle(color: color, fontSize: 12)),
              ],
            ),
          ),
          Text(
            '${score.toStringAsFixed(1)}/10',
            style: TextStyle(
                color: color, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _FibraResultItem extends StatelessWidget {

  const _FibraResultItem({required this.calidad, required this.subtitle});
  final ItemCalidad calidad;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final color = colorPorCalidad(calidad);
    final score = scoreFibra(calidad);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF32324A),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: color, size: 22),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Fibra óptica',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
                Text(subtitle, style: TextStyle(color: color, fontSize: 12)),
              ],
            ),
          ),
          Text(
            '${score.toStringAsFixed(1)}/10',
            style: TextStyle(
                color: color, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _LatenciaResultItem extends StatelessWidget {

  const _LatenciaResultItem({
    required this.calidad,
    required this.googleMs,
    required this.ispMs,
  });
  final ItemCalidad calidad;
  final int? googleMs;
  final int? ispMs;

  @override
  Widget build(BuildContext context) {
    final color = colorPorCalidad(calidad);
    final score = scoreLatencia(googleMs, ispMs);
    final fallido = calidad == ItemCalidad.fallido;
    final g = googleMs != null ? '$googleMs ms' : '--';
    final i = ispMs != null ? '$ispMs ms' : '--';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF32324A),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: color, size: 22),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Latencia y estabilidad',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
                if (fallido)
                  const Text('Sin acceso a internet',
                      style: TextStyle(color: Colors.grey, fontSize: 12))
                else
                  Text('Google: $g  ·  ISP: $i',
                      style: TextStyle(color: color, fontSize: 12)),
              ],
            ),
          ),
          Text(
            '${score.toStringAsFixed(1)}/10',
            style: TextStyle(
                color: color, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
