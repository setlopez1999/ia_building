import 'dart:math';
import '../../domain/entities/streaming_platform_metrics.dart';
import '../../domain/repositories/i_streaming_monitor_repository.dart';
import '../datasources/remote/streaming_monitor_datasource.dart';
import '../datasources/remote/ping_remote_datasource.dart';
import '../datasources/remote/streaming_datasource.dart';

class StreamingMonitorRepositoryImpl implements IStreamingMonitorRepository {
  final StreamingMonitorDataSource _dataSource;

  StreamingMonitorRepositoryImpl({
    required PingRemoteDataSource pingDataSource,
    required StreamingDataSource streamingDataSource,
    Random? random,
  }) : _dataSource = StreamingMonitorDataSource(
          pingDataSource: pingDataSource,
          streamingDataSource: streamingDataSource,
          random: random,
        );

  @override
  Future<StreamingPlatformMetrics?> probePlatform(String platformId) async {
    final result = await _dataSource.probePlatform(platformId);
    if (!result.success) return null;

    return StreamingPlatformMetrics(
      id: platformId,
      name: platformId,
      logoAsset: 'assets/logos/logo_$platformId.png',
      downloadSpeed: '${result.speed.toStringAsFixed(1)} Mbps',
      uploadSpeed: '${result.upload.toStringAsFixed(1)} Mbps',
      serverName: '',
      serverLocation: '',
    );
  }
}
