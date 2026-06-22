import 'package:freezed_annotation/freezed_annotation.dart';

part 'dispositivo.freezed.dart';
part 'dispositivo.g.dart';

/// Modelo de dominio: dispositivo conectado a la red WiFi.
/// Fuente: GET /v1/dispositivos  (DISP-1)
/// [tipo] puede ser: "smartphone" | "tv" | "laptop" | "pc" | "router" | etc.
@freezed
class Dispositivo with _$Dispositivo {
  const factory Dispositivo({
    required String id,
    required String nombre,
    required String mac,
    required String ipLocal,
    required String tipo,
    required bool conectado,
  }) = _Dispositivo;

  factory Dispositivo.fromJson(Map<String, dynamic> json) =>
      _$DispositivoFromJson(json);
}
