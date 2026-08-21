import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tvapp/core/theme/app_colors.dart';
import 'package:tvapp/core/domain/entities/tools/wifi_info.dart';
import 'package:tvapp/core/services/local_device_service.dart';

final _offlineScanProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final service = ref.read(localDeviceServiceProvider);
  final wifi = await service.getWifiInfo();
  final deviceInfo = await service.getDeviceInfo();
  final devices = await service.scanLocalDevices();
  final online = devices.any((d) => d.conectado);
  return {
    'wifi': wifi,
    'device': deviceInfo,
    'devices': devices,
    'online': online,
  };
});

class OfflineResultScreen extends ConsumerWidget {
  static const String name = 'Offline Result';

  final String type;

  const OfflineResultScreen({super.key, required this.type});

  String _title() => switch (type) {
        'device' => 'Estado del dispositivo',
        'wifi' => 'Escaneo Wifi',
        'router' => 'Conexión al Router',
        'devices' => 'Dispositivos en Red',
        _ => 'Resultado Offline',
      };

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
        title: Text(
          _title(),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: scanAsync.when(
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.success),
              SizedBox(height: 16),
              Text('Escaneando...', style: TextStyle(color: AppColors.textBody, fontSize: 14)),
            ],
          ),
        ),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text('Error: $err', style: const TextStyle(color: Colors.red)),
          ),
        ),
        data: (data) {
          final wifi = data['wifi'] as WifiInfo;
          final device = data['device'] as LocalDeviceInfo;
          final devices = data['devices'] as List<dynamic>;
          final online = data['online'] as bool;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _StatusBanner(online: online),
                const SizedBox(height: 24),
                if (type == 'device' || type == 'all') ...[
                  const _SectionTitle('Estado del dispositivo'),
                  _ResultItem(label: 'Modelo', value: device.model ?? '--'),
                  _ResultItem(label: 'Nombre', value: device.name ?? '--'),
                  _ResultItem(label: 'IP local', value: device.ipAddress ?? '--'),
                  const SizedBox(height: 20),
                ],
                if (type == 'wifi' || type == 'all') ...[
                  const _SectionTitle('Escaneo WiFi'),
                  _ResultItem(label: 'SSID', value: wifi.ssid ?? '--'),
                  _ResultItem(
                    label: 'Señal',
                    value: wifi.signalStrengthDbm != null
                        ? '${wifi.signalStrengthDbm} dBm'
                        : '--',
                  ),
                  _ResultItem(label: 'Calidad', value: wifi.signalQuality),
                  _ResultItem(label: 'Banda', value: wifi.band),
                  const SizedBox(height: 20),
                ],
                if (type == 'router' || type == 'all') ...[
                  const _SectionTitle('Conexión al Router'),
                  _ResultItem(label: 'IP Local', value: wifi.ipAddress ?? '--'),
                  _ResultItem(label: 'Gateway', value: wifi.gatewayAddress ?? '--'),
                  _ResultItem(label: 'Máscara', value: wifi.subnetMask ?? '--'),
                  const SizedBox(height: 20),
                ],
                if (type == 'devices' || type == 'all') ...[
                  const _SectionTitle('Dispositivos en Red Local'),
                  _ResultItem(
                    label: 'Equipos detectados',
                    value: devices.length.toString(),
                  ),
                  const SizedBox(height: 20),
                ],
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  final bool online;
  const _StatusBanner({required this.online});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: online
            ? AppColors.success.withValues(alpha: 0.15)
            : Colors.red.withValues(alpha: 0.15),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(
          color: online ? AppColors.success : Colors.redAccent,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            online ? Icons.check_circle : Icons.cancel,
            color: online ? AppColors.success : Colors.redAccent,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            online ? 'Red Local Activa' : 'Sin Conexión Local',
            style: TextStyle(
              color: online ? AppColors.success : Colors.redAccent,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            online
                ? 'Dispositivos detectados en red'
                : 'No se detectaron dispositivos',
            style: const TextStyle(color: AppColors.textBody, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ResultItem extends StatelessWidget {
  final String label;
  final String value;
  const _ResultItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: const BoxDecoration(
          color: AppColors.container,
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: AppColors.textBody, fontSize: 13)),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
