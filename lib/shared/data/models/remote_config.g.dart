// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_config.dart';

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

_$AppRemoteConfigImpl _$$AppRemoteConfigImplFromJson(
  Map<String, dynamic> json,
) => _$AppRemoteConfigImpl(
  assetsVersion: json['assetsVersion'] as String,
  assetsCdnUrl: json['assetsCdnUrl'] as String,
  icons: Map<String, String>.from(json['icons'] as Map),
  networkTargets: NetworkTargets.fromJson(
    json['networkTargets'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$$AppRemoteConfigImplToJson(
  _$AppRemoteConfigImpl instance,
) => <String, dynamic>{
  'assetsVersion': instance.assetsVersion,
  'assetsCdnUrl': instance.assetsCdnUrl,
  'icons': instance.icons,
  'networkTargets': instance.networkTargets,
};
