import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tvapp/core/theme/app_colors.dart';
import 'package:tvapp/ui/shared/constants/app_assets.dart';
import 'package:tvapp/ui/screens/tools/offline/offline_result_screen.dart';

class OfflineScreen extends StatelessWidget {
  static const String name = 'Offline';

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
          onPressed: () => context.canPop() ? context.pop() : context.go('/'),
        ),
        title: const Text(
          'Modo Offline',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Modo Diagnóstico Offline',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Estas verificaciones no requieren conexión a internet',
                    style: TextStyle(color: AppColors.textBody, fontSize: 13),
                  ),
                  const SizedBox(height: 30),
                  _DiagnosticCard(
                    iconPath: AppAssets.toolsSmartphone,
                    title: 'Estado del dispositivo',
                    subtitle: 'WiFi activado, modo avión, Bluetooth',
                    onExecute: () => context.pushNamed(
                      OfflineResultScreen.name,
                      extra: 'device',
                    ),
                  ),
                  const SizedBox(height: 15),
                  _DiagnosticCard(
                    iconPath: AppAssets.toolsWifi,
                    title: 'Escaneo de Redes Wifi',
                    subtitle: 'Detectar redes cercanas, intensidad de señal',
                    onExecute: () => context.pushNamed(
                      OfflineResultScreen.name,
                      extra: 'wifi',
                    ),
                  ),
                  const SizedBox(height: 15),
                  _DiagnosticCard(
                    iconPath: AppAssets.toolsRouter,
                    title: 'Conexión al Router',
                    subtitle: 'Ping local, IP asignada, gateway',
                    onExecute: () => context.pushNamed(
                      OfflineResultScreen.name,
                      extra: 'router',
                    ),
                  ),
                  const SizedBox(height: 15),
                  _DiagnosticCard(
                    iconPath: AppAssets.toolsPc,
                    title: 'Dispositivos en Red Local',
                    subtitle: 'Contar dispositivos conectados al router',
                    onExecute: () => context.pushNamed(
                      OfflineResultScreen.name,
                      extra: 'devices',
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _ExecuteAllButton(
              onTap: () => context.pushNamed(
                OfflineResultScreen.name,
                extra: 'all',
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _DiagnosticCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final String subtitle;
  final VoidCallback onExecute;

  const _DiagnosticCard({
    required this.iconPath,
    required this.title,
    required this.subtitle,
    required this.onExecute,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.container,
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            iconPath,
            colorFilter: const ColorFilter.mode(AppColors.textBody, BlendMode.srcIn),
            width: 36,
            height: 36,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const Text(
                      'Disponible',
                      style: TextStyle(
                        color: AppColors.success,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: AppColors.textBody, fontSize: 12),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: onExecute,
                  child: const Text(
                    'Ejecutar ahora →',
                    style: TextStyle(
                      color: Color(0xFF8B8FC8),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
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

class _ExecuteAllButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ExecuteAllButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: const BoxDecoration(
          color: AppColors.success,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_forward, color: Colors.white),
            SizedBox(width: 12),
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
