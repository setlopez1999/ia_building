import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../utils/app_colors.dart';

class AsistenciaIntroScreen extends StatelessWidget {
  const AsistenciaIntroScreen({super.key});

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
          'Asistencia',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              '¿Qué problema experimentas?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Selecciona la opción que mejor describe tu situación',
              style: TextStyle(color: AppColors.textBody, fontSize: 13),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView(
                children: [
                  _buildProblemCard(
                    context,
                    svgAsset: 'assets/wifi_off.svg',
                    title: 'No hay Wifi',
                    subtitle: 'No puedo conectarme a la red WIFI',
                  ),
                  const SizedBox(height: 15),
                  _buildProblemCard(
                    context,
                    svgAsset: 'assets/internet_slow.svg',
                    title: 'Internet lento',
                    subtitle: 'Conexión muy lenta o inestable',
                  ),
                  const SizedBox(height: 15),
                  _buildProblemCard(
                    context,
                    svgAsset: 'assets/bad_sign.svg',
                    title: 'Mala cobertura',
                    subtitle: 'Señal WIFI débil en algunas zonas',
                  ),
                  const SizedBox(height: 15),
                  _buildProblemCard(
                    context,
                    svgAsset: 'assets/internet.svg',
                    title: 'Sin internet',
                    subtitle: 'WIFI conectado pero no navega',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProblemCard(
    BuildContext context, {
    String? svgAsset,
    IconData? assetIcon,
    required String title,
    required String subtitle,
  }) {
    return InkWell(
      onTap: () => context.push('/asistencia_diagnostic'),
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(
          color: Color(0xFF32324A),
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              alignment: Alignment.center,
              child: svgAsset != null
                  ? SvgPicture.asset(
                      svgAsset,
                      colorFilter: const ColorFilter.mode(
                        Colors.white70,
                        BlendMode.srcIn,
                      ),
                      width: 45,
                      height: 45,
                    )
                  : assetIcon != null
                  ? Icon(assetIcon, color: Colors.white70, size: 45)
                  : null,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textBody,
                      fontSize: 12,
                    ),
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
