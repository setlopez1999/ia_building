import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../logic/diagnostico_notifier.dart';

class DiagnosticoResultScreen extends ConsumerWidget {
  const DiagnosticoResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(diagnosticoNotifierProvider);

    final isExito = state.resultadoFinal?.startsWith('EXCELENTE') ?? false;
    final isBueno = state.resultadoFinal?.startsWith('BUENO') ?? false;
    final isRegular = state.resultadoFinal?.startsWith('REGULAR') ?? false;
    final isMalo = state.resultadoFinal?.startsWith('MALO') ?? false;

    final Color statusColor;
    final String statusText;
    final String statusDesc;

    if (isExito) {
      statusColor = const Color(0xFF00D285);
      statusText = 'Excelente';
      statusDesc = 'Tu conexión está funcionando perfectamente';
    } else if (isBueno) {
      statusColor = const Color(0xFF2196F3);
      statusText = 'Bueno';
      statusDesc = 'Tu conexión funciona bien';
    } else if (isRegular) {
      statusColor = const Color(0xFFFF9800);
      statusText = 'Regular';
      statusDesc = 'Tu conexión presenta algunas variaciones';
    } else if (isMalo) {
      statusColor = const Color(0xFFF44336);
      statusText = 'Malo';
      statusDesc = 'Tu conexión necesita atención';
    } else {
      statusColor = const Color(0xFF00D285);
      statusText = state.resultadoFinal ?? 'Completado';
      statusDesc = 'Diagnóstico finalizado';
    }

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
          'Diagnóstico',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _StatusCard(color: statusColor, text: statusText, desc: statusDesc),
            const SizedBox(height: 20),
            _ResultCard(
              title: 'Velocidad de internet',
              label1: 'Descarga',
              val1: state.velocidadBajadaMbps != null
                  ? '${state.velocidadBajadaMbps!.toStringAsFixed(1)} Mbps'
                  : '--',
              label2: 'Subida',
              val2: state.velocidadSubidaMbps != null
                  ? '${state.velocidadSubidaMbps!.toStringAsFixed(1)} Mbps'
                  : '--',
              score: _calcScore(state.velocidadBajadaMbps),
            ),
            const SizedBox(height: 15),
            _ResultCard(
              title: 'Latencia',
              label1: 'Google',
              val1: state.latenciaGoogleMs != null ? '${state.latenciaGoogleMs} ms' : '--',
              label2: 'ISP',
              val2: state.latenciaIspMs != null ? '${state.latenciaIspMs} ms' : '--',
              score: _calcLatencyScore(state.latenciaIspMs ?? state.latenciaGoogleMs),
            ),
            const SizedBox(height: 15),
            _ResultCard(
              title: 'WiFi',
              label1: 'Señal',
              val1: state.wifiSenialDbm != null ? '${state.wifiSenialDbm} dBm' : '--',
              label2: 'Banda',
              val2: state.wifiBanda ?? '--',
              score: _calcWifiScore(state.wifiSenialDbm),
            ),
            const SizedBox(height: 15),
            _ResultCard(
              title: 'Fibra óptica',
              label1: 'Potencia',
              val1: state.fibraPotenciaDbm ?? '--',
              label2: 'Estado',
              val2: state.fibraEstado ?? '--',
              score: state.fibraEstado == 'OK' ? '10/10' : '5/10',
            ),
            const SizedBox(height: 25),
            const _RecommendationsCard(),
            const SizedBox(height: 30),
            _NewDiagnosticButton(onTap: () => context.pushReplacement('/check_health/diagnostico')),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  String _calcScore(double? v) {
    if (v == null) return '--';
    if (v > 200) return '10/10';
    if (v > 100) return '8/10';
    if (v > 50) return '6/10';
    if (v > 20) return '4/10';
    return '2/10';
  }

  String _calcLatencyScore(int? l) {
    if (l == null) return '--';
    if (l < 20) return '10/10';
    if (l < 50) return '8/10';
    if (l < 80) return '6/10';
    if (l < 150) return '4/10';
    return '2/10';
  }

  String _calcWifiScore(int? dbm) {
    if (dbm == null) return '--';
    if (dbm >= -50) return '10/10';
    if (dbm >= -60) return '8/10';
    if (dbm >= -70) return '6/10';
    return '4/10';
  }
}

class _StatusCard extends StatelessWidget {
  final Color color;
  final String text;
  final String desc;

  const _StatusCard({required this.color, required this.text, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        color: const Color(0xFF32324A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: const Icon(Icons.check, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 20),
          Text(text, style: TextStyle(color: color, fontSize: 32, fontWeight: FontWeight.bold)),
          Text(desc, style: const TextStyle(color: AppColors.textBody, fontSize: 13)),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final String title;
  final String label1;
  final String val1;
  final String label2;
  final String val2;
  final String score;

  const _ResultCard({
    required this.title,
    required this.label1,
    required this.val1,
    required this.label2,
    required this.val2,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF32324A),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 12,
                    backgroundColor: Color(0xFF00D285),
                    child: Icon(Icons.check, size: 14, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
              Text(score,
                  style: const TextStyle(
                      color: Color(0xFF00D285), fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              _DetailItem(label: label1, value: val1),
              _DetailItem(label: label2, value: val2),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;

  const _DetailItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textBody, fontSize: 11)),
          Text(value,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF32324A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recomendaciones',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 20),
          Text('Optimiza tu WIFI',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          Text(
            'Revisa la cantidad de dispositivos conectados. Considera desconectar los que no uses.',
            style: TextStyle(color: AppColors.textBody, fontSize: 12),
          ),
          SizedBox(height: 20),
          Text('Ubicación',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          Text(
            'Tu señal WIFI podría mejorar reubicando el router en un lugar central.',
            style: TextStyle(color: AppColors.textBody, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _NewDiagnosticButton extends StatelessWidget {
  final VoidCallback onTap;
  const _NewDiagnosticButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
              Icon(Icons.refresh, color: Colors.white),
              SizedBox(width: 10),
              Text('Nuevo diagnóstico',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
