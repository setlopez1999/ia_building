import 'package:freezed_annotation/freezed_annotation.dart';

part 'servidor_juego.freezed.dart';
part 'servidor_juego.g.dart';

@freezed
abstract class ServidorJuego with _$ServidorJuego {
  const factory ServidorJuego({
    required String id,
    required String juego,
    required String servidor,
    required String ubicacion,
    required String ip,
    @Default('') String logo,
    @Default(0) int pingMs,
    @Default(0) int jitterMs,
    @Default(0.0) double perdidaPaquetesPct,
    @Default('SIN_CONEXIÓN') String estado,
  }) = _ServidorJuego;

  factory ServidorJuego.fromJson(Map<String, dynamic> json) =>
      _$ServidorJuegoFromJson(json);
}
