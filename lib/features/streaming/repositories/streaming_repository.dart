import 'dart:async';
import '../models/streaming_platform.dart';

class StreamingRepository {
  final _platformsController =
      StreamController<List<StreamingPlatform>>.broadcast();

  List<StreamingPlatform> _platforms = [
    const StreamingPlatform(
      id: 'netflix',
      name: 'Netflix',
      logoAsset: 'assets/logos/logo_netflix.png',
      downloadSpeed: '-- Mbps',
      uploadSpeed: '-- Mbps',
      serverName: 'AWS Virginia',
      serverLocation: 'USA',
    ),
    const StreamingPlatform(
      id: 'youtube',
      name: 'YouTube',
      logoAsset: 'assets/logos/logo_youtube.png',
      downloadSpeed: '-- Mbps',
      uploadSpeed: '-- Mbps',
      serverName: 'Google Santiago',
      serverLocation: 'Chile',
    ),
    const StreamingPlatform(
      id: 'disney',
      name: 'Disney+',
      logoAsset: 'assets/logos/logo_disneyplus.png',
      downloadSpeed: '-- Mbps',
      uploadSpeed: '-- Mbps',
      serverName: 'Cloudfront East',
      serverLocation: 'USA',
    ),
    const StreamingPlatform(
      id: 'hbomax',
      name: 'HBO Max',
      logoAsset: 'assets/logos/logo_hbomax.png',
      downloadSpeed: '-- Mbps',
      uploadSpeed: '-- Mbps',
      serverName: 'Azure Central',
      serverLocation: 'USA',
    ),
    const StreamingPlatform(
      id: 'prime',
      name: 'Prime Video',
      logoAsset: 'assets/logos/logo_primevideo.png',
      downloadSpeed: '-- Mbps',
      uploadSpeed: '-- Mbps',
      serverName: 'AWS Seattle',
      serverLocation: 'USA',
    ),
  ];

  StreamingRepository() {
    scheduleMicrotask(() => _platformsController.add(_platforms));
  }

  void updatePlatformMetrics({
    required String id,
    required double speed,
    required double upload,
  }) {
    final index = _platforms.indexWhere((p) => p.id == id);
    if (index != -1) {
      _platforms[index] = _platforms[index].copyWith(
        downloadSpeed: '${speed.toStringAsFixed(1)} Mbps',
        uploadSpeed: '${upload.toStringAsFixed(1)} Mbps',
      );
      _platformsController.add(List.from(_platforms));
    }
  }

  Stream<List<StreamingPlatform>> watchPlatforms() =>
      _platformsController.stream;

  Stream<StreamingPlatform?> watchPlatform(String id) {
    return watchPlatforms().map(
      (platforms) => platforms.firstWhere(
        (p) => p.id == id,
        orElse: () => _platforms.firstWhere((p) => p.id == id),
      ),
    );
  }
}
