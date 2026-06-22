import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_config.freezed.dart';
part 'app_config.g.dart';

/// IPs de destino para los pings nativos del diagnóstico.
/// Se cachean en SharedPreferences tras GET /v1/config.
@freezed
class NetworkTargets with _$NetworkTargets {
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
class AppConfig with _$AppConfig {
  const factory AppConfig({
    required String assetsVersion,
    required String assetsCdnUrl,
    required Map<String, String> icons,
    required NetworkTargets networkTargets,
  }) = _AppConfig;

  factory AppConfig.fromJson(Map<String, dynamic> json) =>
      _$AppConfigFromJson(json);
}

/// Resultado de autenticación.
/// Fuente: POST /v1/auth/login  (AUTH-1)
@freezed
class AuthResult with _$AuthResult {
  const factory AuthResult({
    required String token,
    required String clienteId,
    required String nombre,
    required String apellido,
    required String email,
    required String role,
  }) = _AuthResult;

  factory AuthResult.fromJson(Map<String, dynamic> json) =>
      _$AuthResultFromJson(json);
}
