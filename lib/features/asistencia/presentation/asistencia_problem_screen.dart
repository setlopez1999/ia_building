import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class AsistenciaProblemScreen extends StatelessWidget {
  const AsistenciaProblemScreen({super.key});

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
        title: const Text('Asistencia', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Icon(Icons.wifi_off, color: Colors.white30, size: 100),
            const SizedBox(height: 20),
            const Text('Problema: No hay conexión WiFi',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Hemos identificado que tu dispositivo no puede conectarse a la red WiFi',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textBody, fontSize: 13),
              ),
            ),
            const SizedBox(height: 30),
            const _RecommendationsCard(),
            const SizedBox(height: 20),
            const _AutoActionsCard(),
            const SizedBox(height: 30),
            _ApplyButton(onTap: () => context.push('/check_health/asistencia/success')),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _RecommendationsCard extends StatelessWidget {
  const _RecommendationsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(color: const Color(0xFF32324A), borderRadius: BorderRadius.circular(20)),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pasos recomendados',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          _Step(number: '1', title: 'Verificar.', subtitle: 'WiFi activado en tu dispositivo'),
          SizedBox(height: 15),
          _Step(number: '2', title: 'Reiniciar', subtitle: 'WiFi desactivando y activando nuevamente'),
          SizedBox(height: 15),
          _Step(number: '3', title: 'Olvidar red', subtitle: 'Eliminar la red guardada y volver a conectar'),
          SizedBox(height: 15),
          _Step(number: '4', title: 'Reiniciar router', subtitle: 'Desenchufar 30 segundos y volver a conectar'),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final String number;
  final String title;
  final String subtitle;

  const _Step({required this.number, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$number. $title',
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        Text(subtitle, style: const TextStyle(color: AppColors.textBody, fontSize: 12)),
      ],
    );
  }
}

class _AutoActionsCard extends StatelessWidget {
  const _AutoActionsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(color: const Color(0xFF32324A), borderRadius: BorderRadius.circular(20)),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Acciones automáticas disponibles',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          _Toggle(label: 'Activar WiFi automáticamente', isChecked: true),
          SizedBox(height: 10),
          _Toggle(label: 'Reconectar a red guardada', isChecked: true),
        ],
      ),
    );
  }
}

class _Toggle extends StatelessWidget {
  final String label;
  final bool isChecked;

  const _Toggle({required this.label, required this.isChecked});

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
        Text(label,
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _ApplyButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ApplyButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(color: const Color(0xFF00D285), borderRadius: BorderRadius.circular(15)),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_forward, color: Colors.white),
            SizedBox(width: 10),
            Text('Aplicar solución automática',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
