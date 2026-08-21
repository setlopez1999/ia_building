import 'package:tvapp/core/domain/entities/tools/remote_config.dart';

abstract class ConfigRepository {
  Future<AppRemoteConfig> getConfig();
  Future<void> saveNetworkTargets(NetworkTargets targets);
  NetworkTargets? getCachedTargets();
  Future<void> checkAndUpdateAssets(String newVersion, String cdnUrl, Map<String, String> icons);
}
