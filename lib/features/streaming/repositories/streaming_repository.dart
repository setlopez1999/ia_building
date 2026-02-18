import 'dart:async';
import 'dart:math';
import '../models/streaming_platform.dart';

class StreamingRepository {
  List<StreamingPlatform> _platforms = [
    const StreamingPlatform(
      id: 'netflix',
      name: 'Netflix',
      logoAsset: 'assets/logos/logo_netflix.png',
      downloadSpeed: '45.2 Mbps',
      uploadSpeed: '12.5 Mbps',
      serverName: 'AWS Virginia',
      serverLocation: 'USA',
    ),
    const StreamingPlatform(
      id: 'youtube',
      name: 'YouTube',
      logoAsset: 'assets/logos/logo_youtube.png',
      downloadSpeed: '62.8 Mbps',
      uploadSpeed: '18.2 Mbps',
      serverName: 'Google Santiago',
      serverLocation: 'Chile',
    ),
    const StreamingPlatform(
      id: 'disney',
      name: 'Disney+',
      logoAsset: 'assets/logos/logo_disneyplus.png',
      downloadSpeed: '40.0 Mbps',
      uploadSpeed: '11.0 Mbps',
      serverName: 'Cloudfront East',
      serverLocation: 'USA',
    ),
    const StreamingPlatform(
      id: 'hbomax',
      name: 'HBO Max',
      logoAsset: 'assets/logos/logo_hbomax.png',
      downloadSpeed: '35.1 Mbps',
      uploadSpeed: '8.4 Mbps',
      serverName: 'Azure Central',
      serverLocation: 'USA',
    ),
    const StreamingPlatform(
      id: 'prime',
      name: 'Prime Video',
      logoAsset: 'assets/logos/logo_primevideo.png',
      downloadSpeed: '38.0 Mbps',
      uploadSpeed: '9.0 Mbps',
      serverName: 'AWS Seattle',
      serverLocation: 'USA',
    ),
  ];

  Stream<List<StreamingPlatform>> watchPlatforms() async* {
    while (true) {
      final random = Random();
      _platforms = _platforms.map((p) {
        final currentSpeed = double.parse(p.downloadSpeed.split(' ')[0]);
        // Volatility for clearly visible changes
        final volatility = (random.nextDouble() * 5) - 2.5; // -2.5 to +2.5
        final newSpeed = (currentSpeed + volatility).clamp(10.0, 150.0);

        return p.copyWith(downloadSpeed: '${newSpeed.toStringAsFixed(1)} Mbps');
      }).toList();

      yield _platforms;
      await Future.delayed(const Duration(milliseconds: 1500));
    }
  }

  Stream<StreamingPlatform?> watchPlatform(String id) async* {
    await for (final platforms in watchPlatforms()) {
      yield platforms.firstWhere(
        (p) => p.id == id,
        orElse: () => _platforms.firstWhere((p) => p.id == id),
      );
    }
  }
}
