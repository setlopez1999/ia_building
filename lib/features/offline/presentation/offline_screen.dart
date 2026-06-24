import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/local_device_service.dart';
import '../../../shared/data/models/wifi_info.dart';

final _offlineScanProvider = FutureProvider.autoDispose((ref) async {
  final service = ref.watch(localDeviceServiceProvider);
  final wifiInfo = await service.getWifiInfo();
  final deviceInfo = await service.getDeviceInfo();
  final devices = await service.scanLocalDevices();
  final online = devices.any((d) => d.conectado);
  return {'wifi': wifiInfo, 'device': deviceInfo, 'devices': devices, 'online': online};
});

class OfflineScreen extends ConsumerWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scanAsync = ref.watch(_offlineScanProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.canPop() ? context.pop() : context.go('/'),
        ),
        title: const Text('Modo Offline', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: scanAsync.when(
          data: (data) {
            final wifi = data['wifi'] as WifiInfo;
            final device = data['device'] as Map<String, dynamic>;
            final devices = data['devices'] as List<dynamic>;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text('Modo Diagnóstico Offline',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const Text('Verificaciones locales sin conexión al servidor',
                    style: TextStyle(color: AppColors.textBody, fontSize: 13)),
                const SizedBox(height: 30),
                _OfflineItem(
                  iconPath: 'assets/smartphone.svg',
                  title: 'Estado del dispositivo',
                  subtitle: '${device['model'] ?? '--'} · ${device['osVersion'] ?? '--'}',
                ),
                const SizedBox(height: 15),
                _OfflineItem(
                  iconPath: 'assets/wifi.svg',
                  title: 'Red WiFi',
                  subtitle: wifi.ssid != null
                      ? '${wifi.ssid} · ${wifi.signalStrengthDbm ?? '--'} dBm (${wifi.band})'
                      : 'No disponible',
                ),
                const SizedBox(height: 15),
                _OfflineItem(
                  iconPath: 'assets/router.svg',
                  title: 'Conexión al Router',
                  subtitle: wifi.gatewayAddress != null
                      ? 'IP: ${wifi.ipAddress ?? '--'} · Gateway: ${wifi.gatewayAddress}'
                      : 'No disponible',
                ),
                const SizedBox(height: 15),
                _OfflineItem(
                  iconPath: 'assets/pc.svg',
                  title: 'Dispositivos en Red Local',
                  subtitle: '${devices.length} dispositivo${devices.length == 1 ? '' : 's'} conectado${devices.length == 1 ? '' : 's'}',
                ),
                const SizedBox(height: 40),
                _ExecuteButton(
                  onTap: () => context.push('/check_health/offline/result', extra: data),
                ),
                const SizedBox(height: 40),
              ],
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.only(top: 80),
            child: Center(child: CircularProgressIndicator(color: Color(0xFF00D285))),
          ),
          error: (err, _) => Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
          ),
        ),
      ),
    );
  }
}

class _OfflineItem extends StatelessWidget {
  final String iconPath;
  final String title;
  final String subtitle;

  const _OfflineItem({required this.iconPath, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF32324A),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: SvgPicture.asset(
              iconPath,
              colorFilter: const ColorFilter.mode(AppColors.textBody, BlendMode.srcIn),
              width: 35,
              height: 35,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    const Text('Disponible', style: TextStyle(color: Color(0xFF00D285), fontSize: 11)),
                  ],
                ),
                Text(subtitle, style: const TextStyle(color: AppColors.textBody, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExecuteButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ExecuteButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: const BoxDecoration(
          color: Color(0xFF00D285),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_forward, color: Colors.white),
            SizedBox(width: 10),
            Text('Ejecutar todas las verificaciones',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
