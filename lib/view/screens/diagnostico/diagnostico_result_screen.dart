import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/app_colors.dart';
import '../../../logic/diagnostico/diagnostico_notifier.dart';

class DiagnosticoResultScreen extends ConsumerWidget {
  const DiagnosticoResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(diagnosticoNotifierProvider);

    final isExito = state.resultadoFinal?.startsWith('EXCELENTE') ?? false;
    final isBueno = state.resultadoFinal?.startsWith('BUENO') ?? false;
    final isRegular = state.resultadoFinal?.startsWith('REGULAR') ?? false;
    final isMalo = state.resultadoFinal?.startsWith('MALO') ?? false;

    Color statusColor;
    String statusText;
    String statusDesc;

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

    final wifiDesc = state.wifiBanda != null
        ? '${state.wifiSsid ?? 'WiFi'} - ${state.wifiSenialDbm != null ? '${state.wifiSenialDbm} dBm' : '--'}'
        : 'No disponible';

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
          'Diagnóstico',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildSuccessCard(statusColor, statusText, statusDesc),
            const SizedBox(height: 20),
            _buildResultDetailCard(
              'Velocidad de internet',
              'Descarga',
              (state.velocidadBajadaMbps != null && state.velocidadBajadaMbps! > 0)
                  ? '${state.velocidadBajadaMbps!.toStringAsFixed(1)} Mbps'
                  : (state.velocidadBajadaMbps == 0 ? '0.0 Mbps' : '--'),
              'Subida',
              (state.velocidadSubidaMbps != null && state.velocidadSubidaMbps! > 0)
                  ? '${state.velocidadSubidaMbps!.toStringAsFixed(1)} Mbps'
                  : (state.velocidadSubidaMbps == 0 ? '0.0 Mbps' : '--'),
              _calcScore(state.velocidadBajadaMbps),
            ),
            const SizedBox(height: 15),
            _buildResultDetailCard(
              'Latencia',
              'Google',
              state.latenciaGoogleMs != null
                  ? '${state.latenciaGoogleMs} ms'
                  : '--',
              'ISP',
              state.latenciaIspMs != null
                  ? '${state.latenciaIspMs} ms'
                  : '--',
              _calcLatencyScore(state.latenciaIspMs ?? state.latenciaGoogleMs),
            ),
            const SizedBox(height: 15),
            _buildResultDetailCard(
              'WiFi',
              'Señal',
              state.wifiSenialDbm != null
                  ? '${state.wifiSenialDbm} dBm'
                  : '--',
              'Banda',
              state.wifiBanda ?? '--',
              _calcWifiScore(state.wifiSenialDbm),
            ),
            const SizedBox(height: 15),
            _buildResultDetailCard(
              'Fibra óptica',
              'Potencia',
              state.fibraPotenciaDbm ?? '--',
              'Estado',
              state.fibraEstado ?? '--',
              state.fibraEstado == 'OK' ? '10/10' : '5/10',
            ),
            const SizedBox(height: 25),
            _buildRecommendationsCard(),
            const SizedBox(height: 30),
            _buildNewDiagnosticButton(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  String _calcScore(double? velocidad) {
    if (velocidad == null) return '--';
    if (velocidad > 200) return '10/10';
    if (velocidad > 100) return '8/10';
    if (velocidad > 50) return '6/10';
    if (velocidad > 20) return '4/10';
    return '2/10';
  }

  String _calcLatencyScore(int? latencia) {
    if (latencia == null) return '--';
    if (latencia < 20) return '10/10';
    if (latencia < 50) return '8/10';
    if (latencia < 80) return '6/10';
    if (latencia < 150) return '4/10';
    return '2/10';
  }

  String _calcWifiScore(int? dbm) {
    if (dbm == null) return '--';
    if (dbm >= -50) return '10/10';
    if (dbm >= -60) return '8/10';
    if (dbm >= -70) return '6/10';
    return '4/10';
  }

  Widget _buildSuccessCard(
    Color color,
    String statusText,
    String statusDesc,
  ) {
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
            child: Icon(Icons.check, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 20),
          Text(
            statusText,
            style: TextStyle(
              color: color,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            statusDesc,
            style: const TextStyle(color: AppColors.textBody, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildResultDetailCard(
    String title,
    String label1,
    String val1,
    String label2,
    String val2,
    String score,
  ) {
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
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Text(
                score,
                style: const TextStyle(
                  color: Color(0xFF00D285),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              _buildDetailItem(label1, val1),
              _buildDetailItem(label2, val2),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.textBody, fontSize: 11),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsCard() {
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
          Text(
            'Recomendaciones',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Optimiza tu WIFI',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          Text(
            'Revisa la cantidad de dispositivos conectados. Considera desconectar los que no uses.',
            style: TextStyle(color: AppColors.textBody, fontSize: 12),
          ),
          SizedBox(height: 20),
          Text(
            'Ubicación',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          Text(
            'Tu señal WIFI podría mejorar reubicando el router en un lugar central.',
            style: TextStyle(color: AppColors.textBody, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildNewDiagnosticButton(BuildContext context) {
    return InkWell(
      onTap: () => context.pushReplacement('/check_health/diagnostico'),
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
              Text(
                'Nuevo diagnóstico',
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
