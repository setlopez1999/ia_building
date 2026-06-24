// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthResultImpl _$$AuthResultImplFromJson(Map<String, dynamic> json) =>
    _$AuthResultImpl(
      token: json['token'] as String,
      clienteId: json['clienteId'] as String,
      nombre: json['nombre'] as String,
      apellido: json['apellido'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$$AuthResultImplToJson(_$AuthResultImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'clienteId': instance.clienteId,
      'nombre': instance.nombre,
      'apellido': instance.apellido,
      'email': instance.email,
      'role': instance.role,
    };
