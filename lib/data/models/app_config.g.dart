// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NetworkTargetsImpl _$$NetworkTargetsImplFromJson(Map<String, dynamic> json) =>
    _$NetworkTargetsImpl(
      googlePingTarget: json['googlePingTarget'] as String,
      ispPingTarget: json['ispPingTarget'] as String,
    );

Map<String, dynamic> _$$NetworkTargetsImplToJson(
  _$NetworkTargetsImpl instance,
) => <String, dynamic>{
  'googlePingTarget': instance.googlePingTarget,
  'ispPingTarget': instance.ispPingTarget,
};

_$AppConfigImpl _$$AppConfigImplFromJson(Map<String, dynamic> json) =>
    _$AppConfigImpl(
      assetsVersion: json['assetsVersion'] as String,
      assetsCdnUrl: json['assetsCdnUrl'] as String,
      icons: Map<String, String>.from(json['icons'] as Map),
      networkTargets: NetworkTargets.fromJson(
        json['networkTargets'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$$AppConfigImplToJson(_$AppConfigImpl instance) =>
    <String, dynamic>{
      'assetsVersion': instance.assetsVersion,
      'assetsCdnUrl': instance.assetsCdnUrl,
      'icons': instance.icons,
      'networkTargets': instance.networkTargets,
    };

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
