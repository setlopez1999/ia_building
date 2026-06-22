import '../interfaces/config_repository.dart';
import '../../models/app_config.dart';
import '../../sources/remote/api_client.dart';
import '../../sources/local/local_storage.dart';

/// Implementación real de ConfigRepository.
/// GET /v1/config  (CONFIG-1)
///
/// Flujo cache-first de assets:
///   1. GET /v1/config
///   2. Comparar assetsVersion recibida vs local
///   3. Si es mayor → checkAndUpdateAssets (descarga del CDN)
///   4. Si es igual → usa iconos cacheados
///   5. Guarda networkTargets en SharedPreferences
class ConfigRepositoryImpl implements ConfigRepository {
  final ApiClient _api;

  ConfigRepositoryImpl(this._api);

  @override
  Future<AppConfig> getConfig() async {
    final data = await _api.get('/v1/config');

    final targets = NetworkTargets(
      googlePingTarget: data['network_targets']['google_ping_target'] as String,
      ispPingTarget: data['network_targets']['isp_ping_target'] as String,
    );

    final icons = Map<String, String>.from(data['icons'] as Map);
    final newVersion = data['assets_version'] as String;
    final cdnUrl = data['assets_cdn_url'] as String;

    // Persiste network targets para uso offline en diagnóstico
    await saveNetworkTargets(targets);

    // Compara versión de assets y descarga si es necesario
    await checkAndUpdateAssets(newVersion, cdnUrl, icons);

    return AppConfig(
      assetsVersion: newVersion,
      assetsCdnUrl: cdnUrl,
      icons: icons,
      networkTargets: targets,
    );
  }

  @override
  Future<void> saveNetworkTargets(NetworkTargets targets) async {
    await LocalStorage.setNetworkTargets(
      googlePingTarget: targets.googlePingTarget,
      ispPingTarget: targets.ispPingTarget,
    );
  }

  @override
  NetworkTargets? getCachedTargets() {
    final google = LocalStorage.getGooglePingTarget();
    final isp = LocalStorage.getIspPingTarget();
    if (google == null || isp == null) return null;
    return NetworkTargets(googlePingTarget: google, ispPingTarget: isp);
  }

  @override
  Future<void> checkAndUpdateAssets(
    String newVersion,
    String cdnUrl,
    Map<String, String> icons,
  ) async {
    final localVersion = LocalStorage.getAssetsVersion();

    if (localVersion == null || _isNewerVersion(newVersion, localVersion)) {
      // TODO: descargar iconos del CDN y guardar en directorio local de la app
      // Por ahora solo actualiza la versión en caché
      await LocalStorage.setAssetsVersion(newVersion);
    }
    // Si versión es igual → no hace nada (usa caché existente)
  }

  /// Compara versiones semánticas simples (v1.4.2 > v1.4.1).
  bool _isNewerVersion(String incoming, String local) {
    try {
      final a = incoming.replaceFirst('v', '').split('.').map(int.parse).toList();
      final b = local.replaceFirst('v', '').split('.').map(int.parse).toList();
      for (int i = 0; i < a.length && i < b.length; i++) {
        if (a[i] > b[i]) return true;
        if (a[i] < b[i]) return false;
      }
      return a.length > b.length;
    } catch (_) {
      return true; // Si no se puede comparar, descarga por seguridad
    }
  }
}
