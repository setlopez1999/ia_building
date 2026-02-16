import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/app_colors.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          'Modo Offline',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Modo Diagnóstico Offline',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Estas verificaciones no requieren conexión a internet',
              style: TextStyle(color: AppColors.textBody, fontSize: 13),
            ),
            const SizedBox(height: 30),
            _buildOfflineItem(
              icon: Icons.smartphone_outlined,
              title: 'Estado del dispositivo',
              subtitle: 'WiFi activado, modo avión, Bluetooth',
            ),
            const SizedBox(height: 15),
            _buildOfflineItem(
              icon: Icons.bar_chart_outlined,
              title: 'Escaneo de Redes Wifi',
              subtitle: 'Detectar redes cercanas, intensidad de señal',
            ),
            const SizedBox(height: 15),
            _buildOfflineItem(
              icon: Icons.router_outlined,
              title: 'Conexión al Router',
              subtitle: 'Ping local, IP asignada, gateway',
            ),
            const SizedBox(height: 15),
            _buildOfflineItem(
              icon: Icons.devices_other_outlined,
              title: 'Dispositivos en Red Local',
              subtitle: 'Contar dispositivos conectados al router',
            ),
            const SizedBox(height: 40),
            _buildExecuteButton(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildOfflineItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF32324A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textBody, size: 35),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const Text(
                      'Disponible',
                      style: TextStyle(color: Color(0xFF00D285), fontSize: 11),
                    ),
                  ],
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textBody,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Ejecutar ahora →',
                  style: TextStyle(color: Color(0xFF7B61FF), fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExecuteButton(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/offline_result'),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFF00D285),
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_forward, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'Ejecutar todas las verificaciones',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
