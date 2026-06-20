import '../entities/game_server_metrics.dart';

abstract class IGamingMonitorRepository {
  Future<GameServerMetrics?> probeGame(String gameId);
}
