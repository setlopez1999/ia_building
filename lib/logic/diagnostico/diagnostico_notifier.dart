import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/providers.dart';
import '../../core/services/network_analyzer_service.dart';
import '../../data/models/diagnostico.dart';
import '../../data/sources/local/local_storage.dart';

/// Estado del flujo de diagnóstico paso a paso.
/// Ver §14 del plan técnico para el flujo completo.
enum DiagnosticoStep {
  idle,
  pingGoogle,
  pingIsp,
  speedtest,
  fibra,
  guardando,
  completado,
  error,
}

class DiagnosticoState {
  final DiagnosticoStep step;
  final int? latenciaGoogleMs;
  final int? latenciaIspMs;
  final double? velocidadBajadaMbps;
  final double? velocidadSubidaMbps;
  final String? fibraPotenciaDbm;
  final String? fibraEstado;
  final String? resultadoFinal;
  final String? errorMsg;

  const DiagnosticoState({
    this.step = DiagnosticoStep.idle,
    this.latenciaGoogleMs,
    this.latenciaIspMs,
    this.velocidadBajadaMbps,
    this.velocidadSubidaMbps,
    this.fibraPotenciaDbm,
    this.fibraEstado,
    this.resultadoFinal,
    this.errorMsg,
  });

  DiagnosticoState copyWith({
    DiagnosticoStep? step,
    int? latenciaGoogleMs,
    int? latenciaIspMs,
    double? velocidadBajadaMbps,
    double? velocidadSubidaMbps,
    String? fibraPotenciaDbm,
    String? fibraEstado,
    String? resultadoFinal,
    String? errorMsg,
  }) =>
      DiagnosticoState(
        step: step ?? this.step,
        latenciaGoogleMs: latenciaGoogleMs ?? this.latenciaGoogleMs,
        latenciaIspMs: latenciaIspMs ?? this.latenciaIspMs,
        velocidadBajadaMbps: velocidadBajadaMbps ?? this.velocidadBajadaMbps,
        velocidadSubidaMbps: velocidadSubidaMbps ?? this.velocidadSubidaMbps,
        fibraPotenciaDbm: fibraPotenciaDbm ?? this.fibraPotenciaDbm,
        fibraEstado: fibraEstado ?? this.fibraEstado,
        resultadoFinal: resultadoFinal ?? this.resultadoFinal,
        errorMsg: errorMsg ?? this.errorMsg,
      );
}

/// Notifier que orquesta el flujo completo de diagnóstico (§14 del plan).
///
/// Flujo:
///   [1] Leer IPs de ping de SharedPreferences (sin llamada API)
///   [2] Ping nativo → google_ping_target  → latencia_google_ms
///   [3] Ping nativo → isp_ping_target     → latencia_isp_ms
///   [4] Speedtest librería local          → bajada + subida Mbps
///   [5] GET /v1/fibra                     → potencia + estado
///   [6] POST /v1/diagnosticos             → guarda resultado
///   [7] Muestra resultado final
class DiagnosticoNotifier extends StateNotifier<DiagnosticoState> {
  final Ref _ref;

  DiagnosticoNotifier(this._ref) : super(const DiagnosticoState());

  /// Inicia el diagnóstico completo paso a paso.
  Future<void> iniciarDiagnostico() async {
    try {
      // [1] Leer IPs de ping de SharedPreferences (CU - sin llamada API)
      final googleTarget =
          LocalStorage.getGooglePingTarget() ?? '8.8.8.8';
      final ispTarget =
          LocalStorage.getIspPingTarget() ?? '1.1.1.1';

      final networkService = _ref.read(networkAnalyzerServiceProvider);

      // [2] Ping Google
      state = state.copyWith(step: DiagnosticoStep.pingGoogle);
      final pingGoogle = await networkService.ping(googleTarget);

      // [3] Ping ISP
      state = state.copyWith(
        step: DiagnosticoStep.pingIsp,
        latenciaGoogleMs: pingGoogle.avgMs.round(),
      );
      final pingIsp = await networkService.ping(ispTarget);

      // [4] Speedtest
      state = state.copyWith(
        step: DiagnosticoStep.speedtest,
        latenciaIspMs: pingIsp.avgMs.round(),
      );
      final speed = await networkService.runSpeedTest();

      // [5] GET /v1/fibra
      state = state.copyWith(
        step: DiagnosticoStep.fibra,
        velocidadBajadaMbps: speed.downloadMbps,
        velocidadSubidaMbps: speed.uploadMbps,
      );
      final fibra = await _ref.read(fibraRepositoryProvider).getFibra();

      // [6] POST /v1/diagnosticos
      state = state.copyWith(
        step: DiagnosticoStep.guardando,
        fibraPotenciaDbm: fibra.potenciaDbm,
        fibraEstado: fibra.estado,
      );

      final clienteId = LocalStorage.getClienteId() ?? '';
      final result = await _ref
          .read(diagnosticoRepositoryProvider)
          .saveDiagnostico(
            DiagnosticoRequest(
              clienteId: clienteId,
              latenciaGoogleMs: pingGoogle.avgMs.round(),
              latenciaIspMs: pingIsp.avgMs.round(),
              velocidadBajadaMbps: speed.downloadMbps,
              velocidadSubidaMbps: speed.uploadMbps,
              fibraPotenciaDbm: fibra.potenciaDbm,
              fibraEstado: fibra.estado,
            ),
          );

      // [7] Resultado final
      state = state.copyWith(
        step: DiagnosticoStep.completado,
        resultadoFinal: result.resultado,
      );

      // Invalida el historial para que se recargue
      _ref.invalidate(historialDiagnosticoProvider);
    } catch (e) {
      state = state.copyWith(
        step: DiagnosticoStep.error,
        errorMsg: e.toString(),
      );
    }
  }

  /// Reinicia el estado para permitir un nuevo diagnóstico.
  void reset() => state = const DiagnosticoState();
}

/// Provider global del DiagnosticoNotifier.
final diagnosticoNotifierProvider =
    StateNotifierProvider<DiagnosticoNotifier, DiagnosticoState>(
  (ref) => DiagnosticoNotifier(ref),
);
