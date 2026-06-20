import '../../models/game_server_target_dto.dart';
import 'ping_remote_datasource.dart';
import 'game_server_datasource.dart';

class GamingMonitorDataSource {
  final PingRemoteDataSource _pingDataSource;
  final GameServerDataSource _gameServerDataSource;

  GamingMonitorDataSource({
    required PingRemoteDataSource pingDataSource,
    required GameServerDataSource gameServerDataSource,
  })  : _pingDataSource = pingDataSource,
        _gameServerDataSource = gameServerDataSource;

  Future<GamingProbeResult> probeGame(String gameId) async {
    // Se prueban solo los 3 primeros servidores por juego para reducir
    // el uso de CPU y bateria. El mejor servidor suele ser el mismo
    // durante toda la sesion, no cambia cada 4 segundos.
    final servers = _gameServerDataSource.getTargets(gameId);
    final candidates = servers.take(3).toList();
    if (candidates.isEmpty) {
      return GamingProbeResult(
        avgPing: 0,
        lossPercent: 100,
        jitter: 0,
        success: false,
        bestServer: null,
      );
    }

    final probeResults = await Future.wait(
      candidates.map((s) => _pingDataSource.analyze(s.target, count: 1)),
    );

    GameServerTargetDto? bestServer;
    double minPing = 99999;
    for (int i = 0; i < candidates.length; i++) {
      final result = probeResults[i];
      if (result.success && result.avgPing < minPing) {
        minPing = result.avgPing;
        bestServer = candidates[i];
      }
    }
    bestServer ??= candidates.first;

    final deepResult = await _pingDataSource.analyze(bestServer.target, count: 3);

    return GamingProbeResult(
      avgPing: deepResult.avgPing,
      lossPercent: deepResult.lossPercent,
      jitter: deepResult.jitter,
      success: deepResult.success,
      bestServer: bestServer,
    );
  }
}

class GamingProbeResult {
  final double avgPing;
  final double lossPercent;
  final double jitter;
  final bool success;
  final GameServerTargetDto? bestServer;

  GamingProbeResult({
    required this.avgPing,
    required this.lossPercent,
    required this.jitter,
    required this.success,
    this.bestServer,
  });
}
