import 'package:freezed_annotation/freezed_annotation.dart';

part 'fibra.freezed.dart';
part 'fibra.g.dart';

/// Modelo de dominio: estado de la fibra óptica.
/// Fuente: GET /v1/fibra  (FIBRA-1)
/// [estado] puede ser: "OK" | "FALLA" | "DEGRADADO"
@freezed
class Fibra with _$Fibra {
  const factory Fibra({
    required String potenciaDbm,
    required String estado,
  }) = _Fibra;

  factory Fibra.fromJson(Map<String, dynamic> json) => _$FibraFromJson(json);
}
