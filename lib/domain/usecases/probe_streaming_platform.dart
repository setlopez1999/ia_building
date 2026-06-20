import '../repositories/i_streaming_repository.dart';
import '../repositories/i_streaming_monitor_repository.dart';

class ProbeStreamingPlatform {
  final IStreamingRepository streamingRepository;
  final IStreamingMonitorRepository monitorRepository;

  ProbeStreamingPlatform({
    required this.streamingRepository,
    required this.monitorRepository,
  });

  Future<void> call(String platformId) async {
    final result = await monitorRepository.probePlatform(platformId);
    if (result != null) {
      final speed = double.tryParse(result.downloadSpeed.replaceAll(' Mbps', '')) ?? 0;
      final upload = double.tryParse(result.uploadSpeed.replaceAll(' Mbps', '')) ?? 0;

      streamingRepository.updatePlatformMetrics(
        id: platformId,
        speed: speed,
        upload: upload,
      );
    }
  }
}
