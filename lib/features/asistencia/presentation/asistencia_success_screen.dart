import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AsistenciaSuccessScreen extends StatelessWidget {
  const AsistenciaSuccessScreen({super.key});

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 60),
            _SuccessCard(),
            const SizedBox(height: 15),
            _DetailsCard(),
            const SizedBox(height: 20),
            const Text(
              'Tu problema debería resolverse en los próximos minutos',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFFB0B0C3), fontSize: 13),
            ),
            const Spacer(),
            _AcceptButton(onTap: () => context.go('/check_health')),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _SuccessCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(color: const Color(0xFF32324A), borderRadius: BorderRadius.circular(25)),
      child: const Column(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Color(0xFF00D285),
            child: Icon(Icons.check, color: Colors.white, size: 45),
          ),
          SizedBox(height: 25),
          Text(
            'Aplicando solución\nautomática',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(color: const Color(0xFF32324A), borderRadius: BorderRadius.circular(20)),
      child: const Column(
        children: [
          _StatusRow(label: 'Activar WIFI automáticamente', isDone: true),
          SizedBox(height: 15),
          _StatusRow(label: 'Recolectar a red guardada', isDone: true),
        ],
      ),
    );
  }
}

class _AcceptButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AcceptButton({required this.onTap});

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
            Text('Aceptar',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  final String label;
  final bool isDone;

  const _StatusRow({required this.label, required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isDone ? Icons.check_circle : Icons.circle_outlined,
          color: isDone ? const Color(0xFF00D285) : Colors.white30,
          size: 22,
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
}
