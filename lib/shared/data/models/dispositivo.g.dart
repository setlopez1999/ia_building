// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispositivo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DispositivoImpl _$$DispositivoImplFromJson(Map<String, dynamic> json) =>
    _$DispositivoImpl(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      mac: json['mac'] as String,
      ipLocal: json['ipLocal'] as String,
      tipo: json['tipo'] as String,
      conectado: json['conectado'] as bool,
    );

Map<String, dynamic> _$$DispositivoImplToJson(_$DispositivoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'mac': instance.mac,
      'ipLocal': instance.ipLocal,
      'tipo': instance.tipo,
      'conectado': instance.conectado,
    };
