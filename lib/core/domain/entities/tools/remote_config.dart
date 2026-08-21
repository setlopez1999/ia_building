import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_config.freezed.dart';
part 'remote_config.g.dart';

/// IPs de destino para los pings nativos del diagnóstico.
@freezed
abstract class NetworkTargets with _$NetworkTargets {
  const factory NetworkTargets({
    required String googlePingTarget,
    required String ispPingTarget,
  }) = _NetworkTargets;

  factory NetworkTargets.fromJson(Map<String, dynamic> json) =>
      _$NetworkTargetsFromJson(json);
}

/// Configuración global de la app obtenida del backend.
/// Fuente: GET /v1/config  (CONFIG-1)
@freezed
abstract class AppRemoteConfig with _$AppRemoteConfig {
  const factory AppRemoteConfig({
    required String assetsVersion,
    required String assetsCdnUrl,
    required Map<String, String> icons,
    required NetworkTargets networkTargets,
  }) = _AppRemoteConfig;

  factory AppRemoteConfig.fromJson(Map<String, dynamic> json) =>
      _$AppRemoteConfigFromJson(json);
}
