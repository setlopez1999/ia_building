import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/network_analyzer_service.dart';
import '../../../core/services/local_device_service.dart';
import '../../../shared/data/models/diagnostico.dart';
import '../../../shared/data/local/local_storage.dart';
import 'diagnostico_providers.dart';
import '../../fibra/logic/fibra_providers.dart';

enum DiagnosticoStep {
  idle,
  pingGoogle,
  pingIsp,
  speedtest,
  wifiInfo,
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
  final String? wifiSsid;
  final int? wifiSenialDbm;
  final String? wifiBanda;
  final String? wifiGateway;
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
    this.wifiSsid,
    this.wifiSenialDbm,
    this.wifiBanda,
    this.wifiGateway,
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
    String? wifiSsid,
    int? wifiSenialDbm,
    String? wifiBanda,
    String? wifiGateway,
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
        wifiSsid: wifiSsid ?? this.wifiSsid,
        wifiSenialDbm: wifiSenialDbm ?? this.wifiSenialDbm,
        wifiBanda: wifiBanda ?? this.wifiBanda,
        wifiGateway: wifiGateway ?? this.wifiGateway,
        resultadoFinal: resultadoFinal ?? this.resultadoFinal,
        errorMsg: errorMsg ?? this.errorMsg,
      );
}

class DiagnosticoNotifier extends StateNotifier<DiagnosticoState> {
  final Ref _ref;

  DiagnosticoNotifier(this._ref) : super(const DiagnosticoState());

  Future<void> iniciarDiagnostico() async {
    try {
      final googleTarget = LocalStorage.getGooglePingTarget() ?? '8.8.8.8';
      final ispTarget = LocalStorage.getIspPingTarget() ?? '1.1.1.1';

      final networkService = _ref.read(networkAnalyzerServiceProvider);
      final localDevice = _ref.read(localDeviceServiceProvider);

      state = state.copyWith(step: DiagnosticoStep.pingGoogle);
      final pingGoogle = await networkService.ping(googleTarget);

      state = state.copyWith(
        step: DiagnosticoStep.pingIsp,
        latenciaGoogleMs: pingGoogle.avgMs.round(),
      );
      final pingIsp = await networkService.ping(ispTarget);

      state = state.copyWith(
        step: DiagnosticoStep.speedtest,
        latenciaIspMs: pingIsp.avgMs.round(),
      );
      final speed = await networkService.runSpeedTest(serverBaseUrl: AppConstants.baseUrl);

      state = state.copyWith(
        step: DiagnosticoStep.wifiInfo,
        velocidadBajadaMbps: speed.downloadMbps,
        velocidadSubidaMbps: speed.uploadMbps,
      );
      final wifiInfo = await localDevice.getWifiInfo();

      state = state.copyWith(
        step: DiagnosticoStep.fibra,
        wifiSsid: wifiInfo.ssid,
        wifiSenialDbm: wifiInfo.signalStrengthDbm,
        wifiBanda: wifiInfo.band,
        wifiGateway: wifiInfo.gatewayAddress,
      );
      final fibra = await _ref.read(fibraRepositoryProvider).getFibra();

      state = state.copyWith(
        step: DiagnosticoStep.guardando,
        fibraPotenciaDbm: fibra.potenciaDbm,
        fibraEstado: fibra.estado,
      );

      final clienteId = LocalStorage.getClienteId() ?? '';
      final result = await _ref.read(diagnosticoRepositoryProvider).saveDiagnostico(
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

      state = state.copyWith(
        step: DiagnosticoStep.completado,
        resultadoFinal: result.resultado,
      );

      _ref.invalidate(historialDiagnosticoProvider);
    } catch (e) {
      state = state.copyWith(step: DiagnosticoStep.error, errorMsg: e.toString());
    }
  }

  void reset() => state = const DiagnosticoState();
}

final diagnosticoNotifierProvider =
    StateNotifierProvider<DiagnosticoNotifier, DiagnosticoState>(
  (ref) => DiagnosticoNotifier(ref),
);
