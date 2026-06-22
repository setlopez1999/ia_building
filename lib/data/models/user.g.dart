// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
  clienteId: json['clienteId'] as String,
  nombre: json['nombre'] as String,
  planContratado: json['planContratado'] as String,
  email: json['email'] as String,
  telefono: json['telefono'] as String,
);

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'clienteId': instance.clienteId,
      'nombre': instance.nombre,
      'planContratado': instance.planContratado,
      'email': instance.email,
      'telefono': instance.telefono,
    };
