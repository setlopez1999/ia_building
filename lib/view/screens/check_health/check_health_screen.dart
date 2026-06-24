import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/app_colors.dart';
import '../../../core/providers/providers.dart';
import '../../../core/services/local_device_service.dart';
import '../../../data/models/diagnostico.dart';

final _lastWifiInfoProvider = FutureProvider.autoDispose((ref) async {
  final service = ref.read(localDeviceServiceProvider);
  return service.getWifiInfo();
});

class CheckHealthScreen extends ConsumerWidget {
  const CheckHealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dispositivosAsync = ref.watch(dispositivosProvider);
    final historialAsync = ref.watch(historialDiagnosticoProvider);
    final fibraAsync = ref.watch(fibraProvider);
    final wifiAsync = ref.watch(_lastWifiInfoProvider);

    final deviceCount = dispositivosAsync.maybeWhen(
      data: (d) => d.length,
      orElse: () => 0,
    );
    final ultimoDiagnostico = historialAsync.maybeWhen(
      data: (h) => h.isNotEmpty ? h.first : null,
      orElse: () => null,
    );
    final fibraEstado = fibraAsync.maybeWhen(
      data: (f) => f.estado,
      orElse: () => null,
    );
    final wifiInfo = wifiAsync.maybeWhen(
      data: (w) => w,
      orElse: () => null,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/'),
        ),
        title: const Text(
          'Check Health',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildWifiStatusCard(context, fibraEstado, wifiInfo),
            const SizedBox(height: 30),
            const Text(
              'Diagnóstico de red',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Verifica la salud de tu conexión en tiempo real',
              style: TextStyle(color: AppColors.textBody, fontSize: 14),
            ),
            const SizedBox(height: 15),
            _buildLastDiagnosticChip(ultimoDiagnostico),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildMetricsGrid(
                context,
                ultimoDiagnostico,
                deviceCount,
                wifiInfo,
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildActionButton(context),
            ),
            const SizedBox(height: 30),
            _buildMenuGrid(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildWifiStatusCard(
    BuildContext context,
    String? fibraEstado,
    dynamic wifiInfo,
  ) {
    final conectado = fibraEstado == 'OK';
    return InkWell(
      onTap: () => context.push('/check_health/change_password'),
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: conectado
                ? [const Color(0xFF00CC66), const Color(0xFF00BEB6)]
                : [Colors.grey.shade700, Colors.grey.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(25)),
        ),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    'assets/wifi.svg',
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF00D285),
                      BlendMode.srcIn,
                    ),
                    width: 30,
                    height: 30,
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: conectado
                          ? const Color(0xFF7B61FF)
                          : Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      conectado ? Icons.check : Icons.close,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    wifiInfo?.ssid != null
                        ? '${wifiInfo.ssid}'
                        : conectado
                            ? 'Conectado a WiFi'
                            : 'Desconectado',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    wifiInfo != null
                        ? '${wifiInfo.signalQuality} (${wifiInfo.signalStrengthDbm ?? '--'} dBm) · ${wifiInfo.band}'
                        : conectado
                            ? 'Fibra óptica: OK'
                            : 'Fibra: $fibraEstado',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLastDiagnosticChip(Diagnostico? ultimo) {
    final text = ultimo != null
        ? 'Último diagnóstico: ${_tiempoRelativo(ultimo.fecha)}'
        : 'Sin diagnósticos previos';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: const BoxDecoration(
        color: Color(0xFF32324A),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.access_time, color: AppColors.textBody, size: 30),
          const SizedBox(width: 15),
          Text(
            text,
            style: const TextStyle(color: AppColors.textBody, fontSize: 12),
          ),
        ],
      ),
    );
  }

  String _tiempoRelativo(DateTime fecha) {
    final diff = DateTime.now().difference(fecha);
    if (diff.inMinutes < 1) return 'Ahora';
    if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Hace ${diff.inHours} h';
    if (diff.inDays == 1) return 'Ayer';
    return 'Hace ${diff.inDays} días';
  }

  Widget _buildMetricsGrid(
    BuildContext context,
    Diagnostico? ultimo,
    int deviceCount,
    dynamic wifiInfo,
  ) {
    final velocidad = ultimo?.velocidadBajadaMbps;
    final latenciaIsp = ultimo?.latenciaIspMs;
    final resultado = ultimo?.resultado ?? '';
    final isExito = resultado.startsWith('EXCELENTE');

    final senialDbm = wifiInfo?.signalStrengthDbm;
    final latenciaGoogle = ultimo?.latenciaIspMs;
    final senialStr = senialDbm != null ? '${senialDbm} dBm' : '--';

    return Row(
      children: [
        Expanded(
          child: _MetricItem(
            svgAsset: 'assets/check-square-svgrepo.svg',
            label: isExito
                ? 'Excelente'
                : resultado.isNotEmpty
                    ? resultado
                    : 'Activo',
            subLabel: 'Estado',
            color: isExito
                ? const Color(0xFF00D285)
                : const Color(0xFF2C2C3E),
          ),
        ),
        Expanded(
          child: _MetricItem(
            svgAsset: 'assets/devices-svgrepo-com.svg',
            label: deviceCount.toString(),
            subLabel: 'Equipos',
            color: deviceCount > 0
                ? const Color(0xFF00D285)
                : const Color(0xFF2C2C3E),
            onTap: () => context.push('/check_health/dispositivos'),
          ),
        ),
        Expanded(
          child: _MetricItem(
            svgAsset: 'assets/loading-16-svgrepo-c.svg',
            label: latenciaIsp != null ? '$latenciaIsp ms' : '--',
            subLabel: 'Lat. ISP',
            color: latenciaIsp != null
                ? const Color(0xFF00D285)
                : const Color(0xFF2C2C3E),
          ),
        ),
        Expanded(
          child: _MetricItem(
            svgAsset: 'assets/wifi.svg',
            label: senialStr,
            subLabel: 'Señal WiFi',
            color: wifiInfo != null
                ? const Color(0xFF00D285)
                : const Color(0xFF2C2C3E),
            onTap: () => context.push('/check_health/offline'),
          ),
        ),
        Expanded(
          child: _MetricItem(
            svgAsset: 'assets/clock_speed.svg',
            label: velocidad != null
                ? '${velocidad.toStringAsFixed(0)} Mbps'
                : '--',
            subLabel: 'Velocidad',
            color: velocidad != null
                ? const Color(0xFF00D285)
                : const Color(0xFF2C2C3E),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/check_health/diagnostico'),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          color: const Color(0xFF00D285),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_forward, color: Colors.white),
              SizedBox(width: 10),
              Text(
                'Iniciar diagnóstico',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 1.1,
      children: [
        _MenuCard(
          svgAsset: 'assets/wifi_off.svg',
          title: 'Modo Offline',
          subtitle: 'Diagnóstico sin internet',
          onTap: () => context.push('/check_health/offline'),
        ),
        _MenuCard(
          svgAsset: 'assets/robot.svg',
          title: 'Chat',
          subtitle: 'Conversemos;',
          onTap: () => context.push('/check_health/chat'),
        ),
        _MenuCard(
          svgAsset: 'assets/help-circle-svgrepo-.svg',
          title: 'Asistencia',
          subtitle: 'Solución guiada',
          onTap: () => context.push('/check_health/asistencia'),
        ),
        _MenuCard(
          svgAsset: 'assets/doc-text-svgrepo-com.svg',
          title: 'Historial',
          subtitle: 'Ver diagnósticos',
          onTap: () => context.go('/historial'),
        ),
        _MenuCard(
          svgAsset: 'assets/gaming_pad.svg',
          title: 'Gaming',
          subtitle: 'Latencia y servidores',
          onTap: () => context.push('/check_health/gaming'),
        ),
      ],
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String svgAsset;
  final String label;
  final String subLabel;
  final Color color;
  final VoidCallback? onTap;

  const _MetricItem({
    required this.svgAsset,
    required this.label,
    required this.subLabel,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFF32324A),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: SvgPicture.asset(
              svgAsset,
              colorFilter: ColorFilter.mode(
                color == const Color(0xFF2C2C3E) ? Colors.white : color,
                BlendMode.srcIn,
              ),
              width: 24,
              height: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          Text(
            subLabel,
            textAlign: TextAlign.center,
            softWrap: false,
            overflow: TextOverflow.visible,
            style: const TextStyle(color: AppColors.textBody, fontSize: 9),
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String svgAsset;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuCard({
    required this.svgAsset,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
          color: Color(0xFF32324A),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              svgAsset,
              colorFilter: const ColorFilter.mode(
                Colors.white70,
                BlendMode.srcIn,
              ),
              width: 35,
              height: 35,
            ),
            const SizedBox(height: 15),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textBody, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
