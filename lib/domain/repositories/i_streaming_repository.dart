import 'dart:async';
import '../entities/streaming_platform_metrics.dart';

abstract class IStreamingRepository {
  Stream<List<StreamingPlatformMetrics>> watchPlatforms();
  Stream<StreamingPlatformMetrics?> watchPlatform(String id);
  void updatePlatformMetrics({
    required String id,
    required double speed,
    required double upload,
  });
}
