import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.white),
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
            _buildWifiStatusCard(context),
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
            _buildLastDiagnosticChip(),
            const SizedBox(height: 25),
            _buildMetricsGrid(context),
            const SizedBox(height: 30),
            _buildActionButton(context),
            const SizedBox(height: 30),
            _buildMenuGrid(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildWifiStatusCard(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/change_password'),
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00CC66), Color(0xFF00BEB6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
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
                    decoration: const BoxDecoration(
                      color: Color(0xFF7B61FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Conectado a Wifi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'CasaGonzalez3456',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLastDiagnosticChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF32324A),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.access_time, color: AppColors.textBody, size: 18),
          SizedBox(width: 10),
          Text(
            'Último diagnóstico: Hace 2 semanas',
            style: TextStyle(color: AppColors.textBody, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const _MetricItem(
          svgAsset: 'assets/check-square-svgrepo.svg',
          label: 'Activo',
          subLabel: 'Estado',
          color: Color(0xFF00D285),
        ),
        InkWell(
          onTap: () => context.push('/dispositivos'),
          borderRadius: BorderRadius.circular(15),
          child: const _MetricItem(
            svgAsset: 'assets/devices-svgrepo-com.svg',
            label: '8',
            subLabel: 'Dispositivos',
            color: Color(0xFF00D285),
          ),
        ),
        const _MetricItem(
          svgAsset: 'assets/loading-16-svgrepo-c.svg',
          label: '12 ms',
          subLabel: 'Latencia',
          color: Color(0xFF00D285),
        ),
        const _MetricItem(
          svgAsset: 'assets/clock_speed.svg',
          label: '248 Mbps',
          subLabel: 'Velocidad',
          color: Color(0xFF00D285),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/diagnostico'),
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
          svgAsset: 'assets/wifi-off.svg',
          title: 'Modo Offline',
          subtitle: 'Diagnóstico sin internet',
          onTap: () => context.push('/offline'),
        ),
        _MenuCard(
          svgAsset: 'assets/robot.svg',
          title: 'Chat',
          subtitle: 'Conversemos;',
          onTap: () => context.push('/chat'),
        ),
        _MenuCard(
          svgAsset: 'assets/help-circle-svgrepo-.svg',
          title: 'Asistencia',
          subtitle: 'Solución guiada',
          onTap: () => context.push('/asistencia'),
        ),
        _MenuCard(
          svgAsset: 'assets/doc-text-svgrepo-com.svg',
          title: 'Historial',
          subtitle: 'Ver diagnósticos',
          onTap: () => context.push('/historial'),
        ),
        _MenuCard(
          svgAsset: 'assets/doc-text-svgrepo-com.svg',
          title: 'Gaming & Streaming',
          subtitle: 'Latencia y servidores',
          onTap: () => context.push('/gaming'),
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

  const _MetricItem({
    required this.svgAsset,
    required this.label,
    required this.subLabel,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF32324A),
            borderRadius: BorderRadius.circular(15),
            //border: Border.all(color: color.withOpacity(0.5), width: 1),
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
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          subLabel,
          style: const TextStyle(color: AppColors.textBody, fontSize: 11),
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
        decoration: BoxDecoration(
          color: const Color(0xFF32324A),
          borderRadius: BorderRadius.circular(20),
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
