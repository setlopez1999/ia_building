import 'dart:async';
import '../../domain/entities/game_server_metrics.dart';
import '../../domain/entities/network_metrics.dart';
import '../../domain/repositories/i_gaming_repository.dart';

class GamingRepositoryImpl implements IGamingRepository {
  final _gamesController = StreamController<List<GameServerMetrics>>.broadcast();

  final List<GameServerMetrics> _games = [
    GameServerMetrics(
      id: 'cs2',
      gameName: 'Counter Strike 2',
      ping: '-- ms',
      loss: '0.0%',
      jitter: '0ms',
      status: 'Esperando...',
      serverName: 'LAS 1',
      serverLocation: 'Santiago, Chile',
      logoAsset: 'assets/logos/logo_cs2.png',
    ),
    GameServerMetrics(
      id: 'valorant',
      gameName: 'Valorant',
      ping: '-- ms',
      loss: '0.0%',
      jitter: '0ms',
      status: 'Esperando...',
      serverName: 'BR 1',
      serverLocation: 'Sao Paulo, Brazil',
      logoAsset: 'assets/logos/logo_valorant.png',
    ),
    GameServerMetrics(
      id: 'fortnite',
      gameName: 'Fortnite',
      ping: '-- ms',
      loss: '0.0%',
      jitter: '0ms',
      status: 'Esperando...',
      serverName: 'NAE 2',
      serverLocation: 'Virginia, USA',
      logoAsset: 'assets/logos/logo_fortnite.png',
    ),
    GameServerMetrics(
      id: 'pubg',
      gameName: 'PUBG',
      ping: '-- ms',
      loss: '0.0%',
      jitter: '0ms',
      status: 'Esperando...',
      serverName: 'LAS 2',
      serverLocation: 'Santiago, Chile',
      logoAsset: 'assets/logos/logo_pubg.png',
    ),
    GameServerMetrics(
      id: 'dota2',
      gameName: 'Dota 2',
      ping: '-- ms',
      loss: '0.0%',
      jitter: '0ms',
      status: 'Esperando...',
      serverName: 'BR 2',
      serverLocation: 'Sao Paulo, Brazil',
      logoAsset: 'assets/logos/logo_dota2.png',
    ),
  ];

  GamingRepositoryImpl() {
    scheduleMicrotask(() => _gamesController.add(_games));
  }

  @override
  void updateGameMetrics({
    required String id,
    required double ping,
    required double loss,
    required double jitter,
    String? serverName,
    String? serverLocation,
  }) {
    final index = _games.indexWhere((g) => g.id == id);
    if (index != -1) {
      final status = NetworkMetrics.fromPing(ping);
      _games[index] = _games[index].copyWith(
        ping: '${ping.toInt()} ms',
        loss: '${loss.toStringAsFixed(1)}%',
        jitter: '${jitter.toInt()}ms',
        status: status,
        serverName: serverName ?? _games[index].serverName,
        serverLocation: serverLocation ?? _games[index].serverLocation,
      );
      _gamesController.add(List.from(_games));
    }
  }

  @override
  Stream<List<GameServerMetrics>> watchGames() => _gamesController.stream;

  @override
  Stream<GameServerMetrics?> watchGame(String id) {
    return watchGames().map(
      (games) => games.firstWhere(
        (g) => g.id == id,
        orElse: () => _games.firstWhere((g) => g.id == id),
      ),
    );
  }
}
