// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameImpl _$$GameImplFromJson(Map<String, dynamic> json) => _$GameImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  ping: json['ping'] as String,
  loss: json['loss'] as String,
  jitter: json['jitter'] as String,
  status: json['status'] as String,
  serverName: json['serverName'] as String,
  serverLocation: json['serverLocation'] as String,
);

Map<String, dynamic> _$$GameImplToJson(_$GameImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'ping': instance.ping,
      'loss': instance.loss,
      'jitter': instance.jitter,
      'status': instance.status,
      'serverName': instance.serverName,
      'serverLocation': instance.serverLocation,
    };
