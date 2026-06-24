// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'servidor_juego.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServidorJuegoImpl _$$ServidorJuegoImplFromJson(Map<String, dynamic> json) =>
    _$ServidorJuegoImpl(
      id: json['id'] as String,
      juego: json['juego'] as String,
      servidor: json['servidor'] as String,
      ubicacion: json['ubicacion'] as String,
      pingMs: (json['pingMs'] as num).toInt(),
      jitterMs: (json['jitterMs'] as num).toInt(),
      perdidaPaquetesPct: (json['perdidaPaquetesPct'] as num).toDouble(),
      estado: json['estado'] as String,
    );

Map<String, dynamic> _$$ServidorJuegoImplToJson(_$ServidorJuegoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'juego': instance.juego,
      'servidor': instance.servidor,
      'ubicacion': instance.ubicacion,
      'pingMs': instance.pingMs,
      'jitterMs': instance.jitterMs,
      'perdidaPaquetesPct': instance.perdidaPaquetesPct,
      'estado': instance.estado,
    };
