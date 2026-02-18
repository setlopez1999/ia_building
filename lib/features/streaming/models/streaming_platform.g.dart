// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streaming_platform.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StreamingPlatformImpl _$$StreamingPlatformImplFromJson(
  Map<String, dynamic> json,
) => _$StreamingPlatformImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  logoAsset: json['logoAsset'] as String,
  downloadSpeed: json['downloadSpeed'] as String,
  uploadSpeed: json['uploadSpeed'] as String,
  serverName: json['serverName'] as String,
  serverLocation: json['serverLocation'] as String,
);

Map<String, dynamic> _$$StreamingPlatformImplToJson(
  _$StreamingPlatformImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'logoAsset': instance.logoAsset,
  'downloadSpeed': instance.downloadSpeed,
  'uploadSpeed': instance.uploadSpeed,
  'serverName': instance.serverName,
  'serverLocation': instance.serverLocation,
};
