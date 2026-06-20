import 'dart:async';
import '../../domain/entities/streaming_platform_metrics.dart';
import '../../domain/repositories/i_streaming_repository.dart';

class StreamingRepositoryImpl implements IStreamingRepository {
  final _platformsController =
      StreamController<List<StreamingPlatformMetrics>>.broadcast();

  final List<StreamingPlatformMetrics> _platforms = [
    const StreamingPlatformMetrics(
      id: 'netflix',
      name: 'Netflix',
      logoAsset: 'assets/logos/logo_netflix.png',
      downloadSpeed: '-- Mbps',
      uploadSpeed: '-- Mbps',
      serverName: 'AWS Virginia',
      serverLocation: 'USA',
    ),
    const StreamingPlatformMetrics(
      id: 'youtube',
      name: 'YouTube',
      logoAsset: 'assets/logos/logo_youtube.png',
      downloadSpeed: '-- Mbps',
      uploadSpeed: '-- Mbps',
      serverName: 'Google Santiago',
      serverLocation: 'Chile',
    ),
    const StreamingPlatformMetrics(
      id: 'disney',
      name: 'Disney+',
      logoAsset: 'assets/logos/logo_disneyplus.png',
      downloadSpeed: '-- Mbps',
      uploadSpeed: '-- Mbps',
      serverName: 'Cloudfront East',
      serverLocation: 'USA',
    ),
    const StreamingPlatformMetrics(
      id: 'hbomax',
      name: 'HBO Max',
      logoAsset: 'assets/logos/logo_hbomax.png',
      downloadSpeed: '-- Mbps',
      uploadSpeed: '-- Mbps',
      serverName: 'Azure Central',
      serverLocation: 'USA',
    ),
    const StreamingPlatformMetrics(
      id: 'prime',
      name: 'Prime Video',
      logoAsset: 'assets/logos/logo_primevideo.png',
      downloadSpeed: '-- Mbps',
      uploadSpeed: '-- Mbps',
      serverName: 'AWS Seattle',
      serverLocation: 'USA',
    ),
  ];

  StreamingRepositoryImpl() {
    scheduleMicrotask(() => _platformsController.add(_platforms));
  }

  @override
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

  @override
  Stream<List<StreamingPlatformMetrics>> watchPlatforms() =>
      _platformsController.stream;

  @override
  Stream<StreamingPlatformMetrics?> watchPlatform(String id) {
    return watchPlatforms().map(
      (platforms) => platforms.firstWhere(
        (p) => p.id == id,
        orElse: () => _platforms.firstWhere((p) => p.id == id),
      ),
    );
  }
}
