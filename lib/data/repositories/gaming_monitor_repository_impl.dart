import '../../domain/entities/game_server_metrics.dart';
import '../../domain/entities/network_metrics.dart';
import '../../domain/repositories/i_gaming_monitor_repository.dart';
import '../datasources/remote/gaming_monitor_datasource.dart';
import '../datasources/remote/ping_remote_datasource.dart';
import '../datasources/remote/game_server_datasource.dart';

class GamingMonitorRepositoryImpl implements IGamingMonitorRepository {
  final GamingMonitorDataSource _dataSource;

  GamingMonitorRepositoryImpl({
    required PingRemoteDataSource pingDataSource,
    required GameServerDataSource gameServerDataSource,
  }) : _dataSource = GamingMonitorDataSource(
          pingDataSource: pingDataSource,
          gameServerDataSource: gameServerDataSource,
        );

  @override
  Future<GameServerMetrics?> probeGame(String gameId) async {
    final result = await _dataSource.probeGame(gameId);
    if (!result.success || result.bestServer == null) return null;

    final pingMs = result.avgPing.toInt();
    return GameServerMetrics(
      id: gameId,
      gameName: gameId,
      ping: '$pingMs ms',
      loss: '${result.lossPercent.toStringAsFixed(1)}%',
      jitter: '${result.jitter.toInt()}ms',
      status: NetworkMetrics.fromPing(pingMs.toDouble()),
      serverName: result.bestServer!.name,
      serverLocation: result.bestServer!.location,
    );
  }

}
