// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificacion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificacionImpl _$$NotificacionImplFromJson(Map<String, dynamic> json) =>
    _$NotificacionImpl(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      mensaje: json['mensaje'] as String,
      fecha: DateTime.parse(json['fecha'] as String),
      leido: json['leido'] as bool,
    );

Map<String, dynamic> _$$NotificacionImplToJson(_$NotificacionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'titulo': instance.titulo,
      'mensaje': instance.mensaje,
      'fecha': instance.fecha.toIso8601String(),
      'leido': instance.leido,
    };
