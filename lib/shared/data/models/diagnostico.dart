import 'package:freezed_annotation/freezed_annotation.dart';

part 'diagnostico.freezed.dart';
part 'diagnostico.g.dart';

@freezed
class Diagnostico with _$Diagnostico {
  const factory Diagnostico({
    required String id,
    required DateTime fecha,
    required int latenciaIspMs,
    required double velocidadBajadaMbps,
    required String resultado,
  }) = _Diagnostico;

  factory Diagnostico.fromJson(Map<String, dynamic> json) => _$DiagnosticoFromJson(json);
}

@freezed
class DiagnosticoRequest with _$DiagnosticoRequest {
  const factory DiagnosticoRequest({
    required String clienteId,
    required int latenciaGoogleMs,
    required int latenciaIspMs,
    required double velocidadBajadaMbps,
    required double velocidadSubidaMbps,
    required String fibraPotenciaDbm,
    required String fibraEstado,
  }) = _DiagnosticoRequest;

  factory DiagnosticoRequest.fromJson(Map<String, dynamic> json) =>
      _$DiagnosticoRequestFromJson(json);
}

@freezed
class DiagnosticoSaveResult with _$DiagnosticoSaveResult {
  const factory DiagnosticoSaveResult({
    required bool success,
    required String diagnosticoId,
    required String resultado,
  }) = _DiagnosticoSaveResult;

  factory DiagnosticoSaveResult.fromJson(Map<String, dynamic> json) =>
      _$DiagnosticoSaveResultFromJson(json);
}
