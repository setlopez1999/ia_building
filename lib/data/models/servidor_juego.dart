import 'package:freezed_annotation/freezed_annotation.dart';

part 'servidor_juego.freezed.dart';
part 'servidor_juego.g.dart';

/// Modelo de dominio: servidor de juego con métricas de red.
/// Fuente: GET /v1/gaming/servers  (GAMING-1)
/// [estado] puede ser: "EXCELENTE" | "BUENO" | "MALO" | "SIN_CONEXIÓN"
@freezed
class ServidorJuego with _$ServidorJuego {
  const factory ServidorJuego({
    required String id,
    required String juego,
    required String servidor,
    required String ubicacion,
    required int pingMs,
    required int jitterMs,
    required double perdidaPaquetesPct,
    required String estado,
  }) = _ServidorJuego;

  factory ServidorJuego.fromJson(Map<String, dynamic> json) =>
      _$ServidorJuegoFromJson(json);
}
