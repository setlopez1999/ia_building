import '../entities/streaming_platform_metrics.dart';

abstract class IStreamingMonitorRepository {
  Future<StreamingPlatformMetrics?> probePlatform(String platformId);
}
