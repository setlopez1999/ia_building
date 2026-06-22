import '../../models/app_config.dart';

/// Contrato abstracto para configuración de la app.
/// GET /v1/config  (CONFIG-1)
///
/// Flujo cache-first de assets:
///   1. GET /v1/config
///   2. Comparar assetsVersion recibida vs local
///   3. Si es mayor: borrar caché de iconos, descargar del CDN, actualizar versión
///   4. Si es igual: usar iconos cacheados
///   5. Guardar networkTargets en SharedPreferences
abstract class ConfigRepository {
  /// Obtiene la configuración del backend y aplica la lógica de caché de assets.
  Future<AppConfig> getConfig();

  /// Persiste los network targets en SharedPreferences.
  Future<void> saveNetworkTargets(NetworkTargets targets);

  /// Devuelve los network targets cacheados, o null si no existen.
  NetworkTargets? getCachedTargets();

  /// Compara versiones y descarga assets del CDN si la versión es mayor.
  Future<void> checkAndUpdateAssets(
    String newVersion,
    String cdnUrl,
    Map<String, String> icons,
  );
}
