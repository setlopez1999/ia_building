import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:tvapp/core/theme/app_colors.dart';
import 'package:tvapp/ui/providers/tools/diagnostico_notifier.dart';

class DiagnosticoScreen extends ConsumerStatefulWidget {
  static const String name = 'Diagnostico';

  const DiagnosticoScreen({super.key});

  @override
  ConsumerState<DiagnosticoScreen> createState() => _DiagnosticoScreenState();
}

class _DiagnosticoScreenState extends ConsumerState<DiagnosticoScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(diagnosticoNotifierProvider.notifier).reset();
      ref.read(diagnosticoNotifierProvider.notifier).iniciarDiagnostico();
    });
  }

  double _stepProgress(DiagnosticoStep step) {
    switch (step) {
      case DiagnosticoStep.idle:       return 0.0;
      case DiagnosticoStep.pingGoogle: return 0.1;
      case DiagnosticoStep.pingIsp:    return 0.25;
      case DiagnosticoStep.speedtest:  return 0.45;
      case DiagnosticoStep.wifiInfo:   return 0.65;
      case DiagnosticoStep.fibra:      return 0.8;
      case DiagnosticoStep.guardando:  return 0.92;
      case DiagnosticoStep.completado: return 1.0;
    }
  }

  String _stepLabel(DiagnosticoStep step) {
    switch (step) {
      case DiagnosticoStep.idle:       return 'Preparando diagnóstico';
      case DiagnosticoStep.pingGoogle: return 'Midiendo latencia...';
      case DiagnosticoStep.pingIsp:    return 'Analizando red local...';
      case DiagnosticoStep.speedtest:  return 'Midiendo velocidad de internet';
      case DiagnosticoStep.wifiInfo:   return 'Escaneando WiFi...';
      case DiagnosticoStep.fibra:      return 'Verificando fibra óptica...';
      case DiagnosticoStep.guardando:  return 'Guardando resultados...';
      case DiagnosticoStep.completado: return 'Completado';
    }
  }

  // ── Subtítulos ────────────────────────────────────────────────────────────

  /// Peor de las dos calidades — determina el color de la tarjeta combinada.
  ItemCalidad _peorCalidad(ItemCalidad a, ItemCalidad b) {
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

  String _subtitleLatencia(DiagnosticoState s) {
    final peor = _peorCalidad(s.calidadGoogle, s.calidadIsp);
    if (peor == ItemCalidad.cargando) return 'Midiendo latencia...';
    if (peor == ItemCalidad.pendiente) return 'Esperando...';
    if (s.calidadGoogle == ItemCalidad.fallido && s.calidadIsp == ItemCalidad.fallido) {
      return 'Sin acceso a internet';
    }
    final g = s.latenciaGoogleMs != null ? '${s.latenciaGoogleMs} ms' : '--';
    final i = s.latenciaIspMs != null ? '${s.latenciaIspMs} ms' : '--';
    return 'Google: $g  ·  ISP: $i';
  }

  /// Se resuelve solo cuando llega el dato real, pero muestra "cargando" desde
  /// el inicio (aunque su paso real todavía no arrancó) para dar la impresión
  /// de que las 4 tarjetas trabajan al mismo tiempo.
  ItemCalidad _calidadWifiSenal(DiagnosticoState s) {
    if (s.step == DiagnosticoStep.completado) {
      final dbm = s.wifiSenialDbm;
      if (dbm == null) return ItemCalidad.fallido;
      if (dbm >= -60) return ItemCalidad.bueno;
      if (dbm >= -70) return ItemCalidad.regular;
      return ItemCalidad.malo;
    }
    final dbm = s.wifiSenialDbm;
    if (dbm == null) return ItemCalidad.cargando;
    if (dbm >= -60) return ItemCalidad.bueno;
    if (dbm >= -70) return ItemCalidad.regular;
    return ItemCalidad.malo;
  }

  String _subtitleWifi(DiagnosticoState s) {
    final calidad = _calidadWifiSenal(s);
    if (calidad == ItemCalidad.cargando) return 'Escaneando WiFi...';
    if (calidad == ItemCalidad.pendiente) return 'Esperando...';
    if (calidad == ItemCalidad.fallido) return 'Sin datos de señal';
    final dbm = s.wifiSenialDbm != null ? '${s.wifiSenialDbm} dBm' : '--';
    final banda = s.wifiBanda ?? '--';
    return '$dbm  ·  $banda';
  }

  String _subtitleVelocidad(DiagnosticoState s) {
    if (s.calidadVelocidad == ItemCalidad.cargando) return 'Midiendo velocidad...';
    if (s.calidadVelocidad == ItemCalidad.pendiente) return 'Esperando...';
    if (s.calidadVelocidad == ItemCalidad.fallido) return 'Sin conexión a internet';
    final down = s.velocidadBajadaMbps?.toStringAsFixed(1) ?? '--';
    final up = s.velocidadSubidaMbps?.toStringAsFixed(1) ?? '--';
    return '↓ $down Mbps  ↑ $up Mbps';
  }

  String _subtitleFibra(DiagnosticoState s) {
    if (s.calidadFibra == ItemCalidad.cargando) return 'Verificando fibra...';
    if (s.calidadFibra == ItemCalidad.pendiente) return 'Esperando...';
    if (s.calidadFibra == ItemCalidad.fallido) return 'No se pudo verificar la fibra';
    if (s.calidadFibra == ItemCalidad.malo) return 'Estado: ${s.fibraEstado}';
    final potencia = s.fibraPotenciaDbm ?? '--';
    return '${s.fibraEstado}  ·  $potencia dBm';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(diagnosticoNotifierProvider);
    final progress = _stepProgress(state.step);

    ref.listen(diagnosticoNotifierProvider, (_, next) {
      if (next.step == DiagnosticoStep.completado) {
        context.pushReplacement('/check_health/diagnostico_result');
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Diagnóstico',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 30),
            _DiagnosticoProgress(progress: progress, label: _stepLabel(state.step)),
            const SizedBox(height: 50),
            _DiagnosticoStatusItem(
              title: 'Velocidad de internet',
              subtitle: _subtitleVelocidad(state),
              calidad: state.calidadVelocidad,
            ),
            const SizedBox(height: 15),
            _DiagnosticoStatusItem(
              title: 'Red WiFi',
              subtitle: _subtitleWifi(state),
              calidad: _calidadWifiSenal(state),
            ),
            const SizedBox(height: 15),
            _DiagnosticoStatusItem(
              title: 'Fibra óptica',
              subtitle: _subtitleFibra(state),
              calidad: state.calidadFibra,
            ),
            const SizedBox(height: 15),
            _DiagnosticoStatusItem(
              title: 'Latencia y estabilidad',
              subtitle: _subtitleLatencia(state),
              calidad: _peorCalidad(state.calidadGoogle, state.calidadIsp),
            ),
            const Spacer(),
            _CancelButton(onTap: () => context.pop()),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ── Widgets privados ──────────────────────────────────────────────────────────

class _DiagnosticoProgress extends StatelessWidget {
  final double progress;
  final String label;

  const _DiagnosticoProgress({required this.progress, required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 30,
              strokeCap: StrokeCap.round,
              backgroundColor: Colors.white12,
              color: const Color.fromARGB(255, 173, 170, 203),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${(progress * 100).toInt()}%',
                style: const TextStyle(
                  color: Color.fromARGB(255, 173, 170, 203),
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textBody, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DiagnosticoStatusItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final ItemCalidad calidad;

  const _DiagnosticoStatusItem({
    required this.title,
    required this.subtitle,
    required this.calidad,
  });

  Color get _color {
    switch (calidad) {
      case ItemCalidad.bueno:    return const Color(0xFF00D285);
      case ItemCalidad.regular:  return Colors.orange;
      case ItemCalidad.malo:     return const Color(0xFFF44336);
      case ItemCalidad.fallido:  return Colors.grey;
      case ItemCalidad.cargando: return const Color.fromARGB(255, 173, 170, 203);
      case ItemCalidad.pendiente: return AppColors.textBody;
    }
  }

  Widget get _icon {
    switch (calidad) {
      case ItemCalidad.bueno:
        return Icon(Icons.check_circle, color: _color, size: 24);
      case ItemCalidad.regular:
        return Icon(Icons.warning_amber_rounded, color: _color, size: 24);
      case ItemCalidad.malo:
        return Icon(Icons.cancel, color: _color, size: 24);
      case ItemCalidad.fallido:
        return const Icon(Icons.signal_wifi_off, color: Colors.grey, size: 24);
      case ItemCalidad.cargando:
        return SizedBox(
          width: 24,
          height: 24,
          child: LoadingIndicator(
            indicatorType: Indicator.lineSpinFadeLoader,
            colors: [_color],
            strokeWidth: 2,
          ),
        );
      case ItemCalidad.pendiente:
        return Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.textBody),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasBorder = calidad != ItemCalidad.pendiente;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF32324A),
        borderRadius: BorderRadius.circular(15),
        border: hasBorder ? Border.all(color: _color.withOpacity(0.6)) : null,
      ),
      child: Row(
        children: [
          SizedBox(width: 24, height: 24, child: _icon),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
                Text(subtitle, style: TextStyle(color: _color, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CancelButton extends StatelessWidget {
  final VoidCallback onTap;
  const _CancelButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          color: const Color(0xFFF44336).withOpacity(0.8),
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Center(
          child: Text(
            'Cancelar diagnóstico',
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
