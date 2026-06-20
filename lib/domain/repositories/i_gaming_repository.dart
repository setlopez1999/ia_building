import 'dart:async';
import '../entities/game_server_metrics.dart';

abstract class IGamingRepository {
  Stream<List<GameServerMetrics>> watchGames();
  Stream<GameServerMetrics?> watchGame(String id);
  void updateGameMetrics({
    required String id,
    required double ping,
    required double loss,
    required double jitter,
    String? serverName,
    String? serverLocation,
  });
}
