import 'package:freezed_annotation/freezed_annotation.dart';

part 'dispositivo.freezed.dart';
part 'dispositivo.g.dart';

@freezed
abstract class Dispositivo with _$Dispositivo {
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
