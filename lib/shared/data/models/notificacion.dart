import 'package:freezed_annotation/freezed_annotation.dart';

part 'notificacion.freezed.dart';
part 'notificacion.g.dart';

@freezed
class Notificacion with _$Notificacion {
  const factory Notificacion({
    required String id,
    required String titulo,
    required String mensaje,
    required DateTime fecha,
    required bool leido,
  }) = _Notificacion;

  factory Notificacion.fromJson(Map<String, dynamic> json) =>
      _$NotificacionFromJson(json);
}
