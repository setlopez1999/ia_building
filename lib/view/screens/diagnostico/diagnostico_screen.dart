import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../../shared/app_colors.dart';
import '../../../logic/diagnostico/diagnostico_notifier.dart';

class DiagnosticoScreen extends ConsumerStatefulWidget {
  const DiagnosticoScreen({super.key});

  @override
  ConsumerState<DiagnosticoScreen> createState() => _DiagnosticoScreenState();
}

class _DiagnosticoScreenState extends ConsumerState<DiagnosticoScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(diagnosticoNotifierProvider.notifier).reset();
      ref.read(diagnosticoNotifierProvider.notifier).iniciarDiagnostico();
    });
  }

  double _stepProgress(DiagnosticoStep step) {
    switch (step) {
      case DiagnosticoStep.idle:
        return 0.0;
      case DiagnosticoStep.pingGoogle:
        return 0.1;
      case DiagnosticoStep.pingIsp:
        return 0.25;
      case DiagnosticoStep.speedtest:
        return 0.45;
      case DiagnosticoStep.wifiInfo:
        return 0.6;
      case DiagnosticoStep.fibra:
        return 0.75;
      case DiagnosticoStep.guardando:
        return 0.9;
      case DiagnosticoStep.completado:
        return 1.0;
      case DiagnosticoStep.error:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(diagnosticoNotifierProvider);
    final progress = _stepProgress(state.step);

    ref.listen(diagnosticoNotifierProvider, (prev, next) {
      if (next.step == DiagnosticoStep.completado) {
        context.pushReplacement('/check_health/diagnostico_result');
      }
      if (next.step == DiagnosticoStep.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${next.errorMsg}')),
        );
      }
    });

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 30,
                      strokeCap: StrokeCap.round,
                      backgroundColor: Colors.white12,
                      color: const Color.fromARGB(255, 173, 170, 203),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 173, 170, 203),
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _stepLabel(state.step),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.textBody,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            _buildStatusItem(
              'Velocidad de internet',
              state.velocidadBajadaMbps != null
                  ? 'Descarga: ${state.velocidadBajadaMbps!.toStringAsFixed(1)} Mbps / Subida: ${state.velocidadSubidaMbps?.toStringAsFixed(1) ?? '...'} Mbps'
                  : 'Analizando...',
              isDone: state.step.index >= DiagnosticoStep.speedtest.index,
              isLoading: state.step == DiagnosticoStep.speedtest,
            ),
            const SizedBox(height: 15),
            _buildStatusItem(
              'Red Wifi Doméstica',
              state.latenciaIspMs != null
                  ? '${state.latenciaIspMs} ms'
                  : 'Esperando...',
              isDone: state.step.index >= DiagnosticoStep.pingIsp.index,
              isLoading: state.step == DiagnosticoStep.pingIsp,
            ),
            const SizedBox(height: 15),
            _buildStatusItem(
              'Conexión WiFi',
              state.wifiSsid != null
                  ? '${state.wifiSsid} (${state.wifiBanda ?? '--'})'
                  : 'Analizando señal...',
              isDone: state.step.index >= DiagnosticoStep.wifiInfo.index,
              isLoading: state.step == DiagnosticoStep.wifiInfo,
            ),
            const SizedBox(height: 15),
            _buildStatusItem(
              'Fibra óptica',
              state.fibraEstado != null
                  ? 'Potencia: ${state.fibraPotenciaDbm}'
                  : 'Esperando...',
              isDone: state.step.index >= DiagnosticoStep.fibra.index,
              isLoading: state.step == DiagnosticoStep.fibra,
            ),
            const SizedBox(height: 15),
            _buildStatusItem(
              'Latencia y estabilidad',
              state.latenciaGoogleMs != null
                  ? '${state.latenciaGoogleMs}ms (Google)'
                  : 'Esperando...',
              isDone: state.step.index >= DiagnosticoStep.pingGoogle.index,
              isLoading: state.step == DiagnosticoStep.pingGoogle,
            ),
            const Spacer(),
            _buildCancelButton(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  String _stepLabel(DiagnosticoStep step) {
    switch (step) {
      case DiagnosticoStep.idle:
        return 'Preparando diagnóstico';
      case DiagnosticoStep.pingGoogle:
        return 'Midiendo latencia...';
      case DiagnosticoStep.pingIsp:
        return 'Analizando red local...';
      case DiagnosticoStep.speedtest:
        return 'Analizando velocidad de internet';
      case DiagnosticoStep.wifiInfo:
        return 'Escaneando WiFi...';
      case DiagnosticoStep.fibra:
        return 'Verificando fibra óptica...';
      case DiagnosticoStep.guardando:
        return 'Guardando resultados...';
      case DiagnosticoStep.completado:
        return 'Completado';
      case DiagnosticoStep.error:
        return 'Error en diagnóstico';
    }
  }

  Widget _buildStatusItem(
    String title,
    String subtitle, {
    required bool isDone,
    required bool isLoading,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF32324A),
        borderRadius: BorderRadius.circular(15),
        border: isDone || isLoading
            ? Border.all(
                color: isDone ? const Color(0xFF00D285) : AppColors.textBody,
              )
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            child: isDone
                ? const Icon(
                    Icons.check_circle,
                    color: Color(0xFF00D285),
                    size: 24,
                  )
                : isLoading
                    ? const LoadingIndicator(
                        indicatorType: Indicator.lineSpinFadeLoader,
                        colors: [AppColors.textBody],
                        strokeWidth: 2,
                      )
                    : Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.textBody,
                        ),
                      ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isDone
                        ? const Color(0xFF00D285)
                        : isLoading
                            ? const Color.fromARGB(255, 164, 164, 223)
                            : AppColors.textBody,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (isDone)
            const Icon(Icons.check_circle, color: Color(0xFF00D285), size: 18),
        ],
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/'),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          color: const Color(0xFFF44336).withOpacity(0.8),
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Center(
          child: Text(
            'Cancelar diagnóstico',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
