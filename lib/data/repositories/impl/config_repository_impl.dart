import '../interfaces/config_repository.dart';
import '../../models/app_config.dart';
import '../../sources/remote/api_client.dart';
import '../../sources/local/local_storage.dart';

class ConfigRepositoryImpl implements ConfigRepository {
  final ApiClient _api;

  ConfigRepositoryImpl(this._api);

  @override
  Future<AppConfig> getConfig() async {
    final data = await _api.get('/v1/config');
    final netTargets = data['network_targets'] as Map<String, dynamic>? ?? {};

    final targets = NetworkTargets(
      googlePingTarget: (netTargets['google_ping_target'] as String?) ?? '',
      ispPingTarget: (netTargets['isp_ping_target'] as String?) ?? '',
    );

    final icons = Map<String, String>.from(data['icons'] as Map? ?? {});
    final newVersion = (data['assets_version'] as String?) ?? '';
    final cdnUrl = (data['assets_cdn_url'] as String?) ?? '';

    await saveNetworkTargets(targets);
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
      await LocalStorage.setAssetsVersion(newVersion);
    }
  }

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
      return true;
    }
  }
}
