import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tvapp/core/theme/app_colors.dart';
import 'package:tvapp/ui/shared/constants/app_assets.dart';
import 'package:tvapp/ui/providers/tools/wifi_notifier.dart';
import 'package:tvapp/core/domain/entities/tools/diagnostico.dart';
import 'package:tvapp/ui/providers/tools/dispositivos_providers.dart';
import 'package:tvapp/ui/providers/tools/fibra_providers.dart';
import 'package:tvapp/ui/providers/tools/diagnostico_providers.dart';
import 'package:tvapp/ui/screens/main/main.screen.dart';
import 'package:tvapp/ui/screens/tools/wifi_password/wifi_password_screen.dart';
import 'package:tvapp/ui/screens/tools/asistencia/asistencia_loading_screen.dart';
import 'package:tvapp/ui/screens/tools/chat/chat_screen.dart';
import 'package:tvapp/ui/screens/tools/diagnostico/diagnostico_screen.dart';
import 'package:tvapp/ui/screens/tools/dispositivos/devices_screen.dart';
import 'package:tvapp/ui/screens/tools/gaming/gaming_screen.dart';
import 'package:tvapp/ui/screens/tools/historial/historial_screen.dart';
import 'package:tvapp/ui/screens/tools/offline/offline_screen.dart';


class CheckHealthScreen extends ConsumerWidget {
  static const String name = 'Check Health';

  const CheckHealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dispositivosAsync = ref.watch(dispositivosProvider);
    final historialAsync = ref.watch(historialDiagnosticoProvider);
    final fibraAsync = ref.watch(fibraProvider);
    // Sin fallback: si la API no responde, la tarjeta debe reflejar "sin conexión".
    final ssid = ref.watch(wifiSsidProvider).maybeWhen(data: (s) => s, orElse: () => null);

    final deviceCount = dispositivosAsync.maybeWhen(data: (d) => d.length, orElse: () => 0);
    final ultimoDiagnostico = historialAsync.maybeWhen(
      data: (h) => h.isNotEmpty ? h.first : null,
      orElse: () => null,
    );
    final fibraEstado = fibraAsync.maybeWhen(data: (f) => f.estado, orElse: () => null);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.canPop() ? context.pop() : context.goNamed(MainScreen.name),
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
            _WifiStatusCard(fibraEstado: fibraEstado, ssid: ssid),
            const SizedBox(height: 30),
            const Text(
              'Diagnóstico de red',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Verifica la salud de tu conexión en tiempo real',
              style: TextStyle(color: AppColors.textBody, fontSize: 14),
            ),
            const SizedBox(height: 15),
            _LastDiagnosticChip(ultimo: ultimoDiagnostico),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _MetricsGrid(
                ultimo: ultimoDiagnostico,
                deviceCount: deviceCount,
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _DiagnosticActionButton(
                onTap: () => context.pushNamed(DiagnosticoScreen.name),
              ),
            ),
            const SizedBox(height: 30),
            _MenuGrid(onTapChat: () => context.pushNamed(ChatScreen.name)),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ── Widgets privados ──────────────────────────────────────────────────────────

class _WifiStatusCard extends StatelessWidget {
  final String? fibraEstado;
  final String? ssid;

  const _WifiStatusCard({this.fibraEstado, this.ssid});

  @override
  Widget build(BuildContext context) {
    final estado = fibraEstado ?? '';
    final conectado = estado == 'OK';
    final degradado = estado == 'DEGRADADO';

    final List<Color> gradientColors;
    final Color badgeColor;
    final IconData badgeIcon;

    if (conectado) {
      gradientColors = [AppColors.gradientOk1, AppColors.gradientOk2];
      badgeColor = AppColors.accentBlue;
      badgeIcon = Icons.check;
    } else if (degradado) {
      gradientColors = [AppColors.gradientDegradado1, AppColors.gradientDegradado2];
      badgeColor = AppColors.warning;
      badgeIcon = Icons.warning_amber_rounded;
    } else {
      gradientColors = [AppColors.gradientDesconectado1, AppColors.gradientDesconectado2];
      badgeColor = AppColors.error;
      badgeIcon = Icons.close;
    }

    final titulo = conectado
        ? 'Conectado'
        : degradado
            ? 'Señal degradada'
            : 'Sin internet';

    final localSsid = ssid;
    final subtitulo = (localSsid != null && localSsid.isNotEmpty) ? localSsid : 'Sin conexión';

    return InkWell(
      onTap: () => context.pushNamed(WifiPasswordScreen.name, extra: ssid ?? ''),
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
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
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: SvgPicture.asset(
                    AppAssets.toolsWifi,
                    colorFilter: const ColorFilter.mode(AppColors.success, BlendMode.srcIn),
                    width: 30,
                    height: 30,
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: badgeColor, shape: BoxShape.circle),
                    child: Icon(badgeIcon, color: Colors.white, size: 12),
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
                    titulo,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subtitulo,
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
}

class _LastDiagnosticChip extends StatelessWidget {
  final Diagnostico? ultimo;

  const _LastDiagnosticChip({this.ultimo});

  String _hora(DateTime fecha) {
    final h = fecha.hour.toString().padLeft(2, '0');
    final m = fecha.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String _tiempoRelativo(DateTime fecha) {
    final now = DateTime.now();
    final hoy = DateTime(now.year, now.month, now.day);
    final diaFecha = DateTime(fecha.year, fecha.month, fecha.day);
    final diff = hoy.difference(diaFecha).inDays;

    if (diff == 0) return 'Hoy ${_hora(fecha)}';
    if (diff == 1) return 'Ayer ${_hora(fecha)}';
    return 'Hace $diff días';
  }

  @override
  Widget build(BuildContext context) {
    final text = ultimo != null
        ? 'Último diagnóstico: ${_tiempoRelativo(ultimo!.fecha)}'
        : 'Sin diagnósticos previos';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: const BoxDecoration(
        color: AppColors.container,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.access_time, color: AppColors.textBody, size: 30),
          const SizedBox(width: 15),
          Text(text, style: const TextStyle(color: AppColors.textBody, fontSize: 12)),
        ],
      ),
    );
  }
}

class _MetricsGrid extends StatelessWidget {
  final Diagnostico? ultimo;
  final int deviceCount;

  const _MetricsGrid({this.ultimo, required this.deviceCount});

  // Mismos colores/umbrales que diagnostico_result_screen.dart e historial_screen.dart.
  Color _colorResultado(String r) {
    if (r.contains('EXCELENTE')) return const Color(0xFF00D285);
    if (r.contains('BUENO')) return const Color(0xFF8BC34A);
    if (r.contains('REGULAR')) return const Color(0xFFFFA726);
    if (r.isEmpty) return AppColors.containerDark;
    return const Color(0xFFF44336);
  }

  @override
  Widget build(BuildContext context) {
    final velocidad = ultimo?.velocidadBajadaMbps;
    final latenciaIsp = ultimo?.latenciaIspMs;
    final latenciaGoogle = ultimo?.latenciaGoogleMs;
    final resultado = ultimo?.resultado ?? '';

    return Row(
      children: [
        Expanded(child: _MetricItem(
          svgAsset: AppAssets.toolsCheckSquare,
          label: resultado.isNotEmpty ? resultado : 'Activo',
          subLabel: 'Estado',
          color: _colorResultado(resultado),
        )),
        Expanded(child: _MetricItem(
          svgAsset: AppAssets.toolsDevices,
          label: deviceCount.toString(),
          subLabel: 'Equipos',
          color: deviceCount > 0 ? AppColors.success : AppColors.containerDark,
          onTap: () => context.pushNamed(DevicesScreen.name),
        )),
        Expanded(child: _MetricItem(
          svgAsset: AppAssets.toolsLoading,
          label: latenciaIsp != null ? '$latenciaIsp ms' : '--',
          subLabel: 'Lat. ISP',
          color: latenciaIsp != null ? AppColors.success : AppColors.containerDark,
        )),
        Expanded(child: _MetricItem(
          svgAsset: AppAssets.toolsWifi,
          label: latenciaGoogle != null ? '$latenciaGoogle ms' : '--',
          subLabel: 'Lat. Google',
          color: latenciaGoogle != null ? AppColors.success : AppColors.containerDark,
        )),
        Expanded(child: _MetricItem(
          svgAsset: AppAssets.toolsClockSpeed,
          label: velocidad != null ? '${velocidad.toStringAsFixed(0)} Mbps' : '--',
          subLabel: 'Velocidad',
          color: velocidad != null ? AppColors.success : AppColors.containerDark,
        )),
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
              color: AppColors.container,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: SvgPicture.asset(
              svgAsset,
              colorFilter: ColorFilter.mode(
                color == AppColors.containerDark ? Colors.white : color,
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
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
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

class _DiagnosticActionButton extends StatelessWidget {
  final VoidCallback onTap;
  const _DiagnosticActionButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: const BoxDecoration(
          color: AppColors.success,
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
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuGrid extends StatelessWidget {
  final VoidCallback onTapChat;
  const _MenuGrid({required this.onTapChat});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 1.1,
      children: [
        _MenuCard(
          svgAsset: AppAssets.toolsWifiOff,
          title: 'Modo Offline',
          subtitle: 'Diagnóstico sin internet',
          onTap: () => context.pushNamed(OfflineScreen.name),
        ),
        _MenuCard(
          svgAsset: AppAssets.toolsRobot,
          title: 'Chat',
          subtitle: 'Conversemos',
          onTap: onTapChat,
        ),
        _MenuCard(
          svgAsset: AppAssets.toolsHelpCircle,
          title: 'Asistencia',
          subtitle: 'Solución guiada',
          onTap: () => context.pushNamed(AsistenciaLoadingScreen.name),
        ),
        _MenuCard(
          svgAsset: AppAssets.toolsDocText,
          title: 'Historial',
          subtitle: 'Ver diagnósticos',
          onTap: () => context.pushNamed(HistorialScreen.name),
        ),
        _MenuCard(
          svgAsset: AppAssets.toolsGamingPad,
          title: 'Gaming',
          subtitle: 'Latencia y servidores',
          onTap: () => context.pushNamed(GamingScreen.name),
        ),
      ],
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
          color: AppColors.container,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              svgAsset,
              colorFilter: const ColorFilter.mode(AppColors.iconSecondary, BlendMode.srcIn),
              width: 35,
              height: 35,
            ),
            const SizedBox(height: 15),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
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
