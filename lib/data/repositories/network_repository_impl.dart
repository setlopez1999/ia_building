import '../../domain/entities/network_metrics.dart';
import '../../domain/repositories/i_network_repository.dart';
import '../datasources/remote/ping_remote_datasource.dart';

class NetworkRepositoryImpl implements INetworkRepository {
  final PingRemoteDataSource dataSource;

  NetworkRepositoryImpl(this.dataSource);

  @override
  Future<NetworkMetrics> analyze(String host, {int count = 4}) async {
    final result = await dataSource.analyze(host, count: count);
    return NetworkMetrics(
      avgPing: result.avgPing,
      lossPercent: result.lossPercent,
      jitter: result.jitter,
      success: result.success,
    );
  }
}
