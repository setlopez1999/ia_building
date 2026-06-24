import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/wifi_info.dart';

class OfflineResultScreen extends StatelessWidget {
  const OfflineResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data =
        GoRouterState.of(context).extra as Map<String, dynamic>?;
    final wifi = data?['wifi'] as WifiInfo?;
    final device = data?['device'] as Map<String, dynamic>?;
    final devices = data?['devices'] as List<dynamic>?;
    final online = data?['online'] as bool? ?? true;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
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
          'Resultado Offline',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              _buildResultCard(online),
              const SizedBox(height: 15),
              _buildStatusListCard(wifi, device, devices),
              const SizedBox(height: 30),
              _buildAcceptButton(context),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(bool online) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: const Color(0xFF32324A),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor:
                online ? const Color(0xFF00D285) : Colors.orange,
            child: Icon(
              online ? Icons.check : Icons.warning,
              color: Colors.white,
              size: 45,
            ),
          ),
          const SizedBox(height: 25),
          Text(
            online ? 'Dispositivo OK' : 'Atención requerida',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusListCard(
    WifiInfo? wifi,
    Map<String, dynamic>? device,
    List<dynamic>? devices,
  ) {
    final modelName = device?['model'] ?? '--';
    final osVersion = device?['osVersion'] ?? '--';
    final ssid = wifi?.ssid ?? 'No disponible';
    final signalStr =
        wifi?.signalStrengthDbm != null
            ? '${wifi!.signalStrengthDbm} dBm'
            : '--';
    final band = wifi?.band ?? '--';
    final ip = wifi?.ipAddress ?? '--';
    final gateway = wifi?.gatewayAddress ?? '--';
    final deviceCount = devices?.length ?? 0;

    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFF32324A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _StatusRow(label: 'WiFi: Activado ($ssid)', isChecked: true),
          const SizedBox(height: 15),
          _StatusRow(label: 'Señal WiFi: $signalStr ($band)', isChecked: true),
          const SizedBox(height: 15),
          _StatusRow(label: 'IP: $ip · Gateway: $gateway', isChecked: true),
          const SizedBox(height: 15),
          _StatusRow(
            label: 'Dispositivos en red: $deviceCount',
            isChecked: deviceCount > 0,
          ),
          const SizedBox(height: 15),
          _StatusRow(
            label: 'Dispositivo: $modelName · $osVersion',
            isChecked: true,
          ),
        ],
      ),
    );
  }

  Widget _buildAcceptButton(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/check_health'),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          color: const Color(0xFF00D285),
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_forward, color: Colors.white),
              SizedBox(width: 10),
              Text(
                'Aceptar',
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
}

class _StatusRow extends StatelessWidget {
  final String label;
  final bool isChecked;

  const _StatusRow({required this.label, required this.isChecked});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isChecked ? Icons.check_circle : Icons.circle_outlined,
          color: isChecked ? const Color(0xFF00D285) : Colors.white30,
          size: 22,
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
