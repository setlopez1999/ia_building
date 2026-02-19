import 'dart:async';
import '../models/game.dart';

class GamingRepository {
  final _gamesController = StreamController<List<Game>>.broadcast();

  List<Game> _games = [
    const Game(
      id: 'cs2',
      name: 'Counter Strike 2',
      ping: '-- ms',
      loss: '0.0%',
      jitter: '0ms',
      status: 'Esperando...',
      serverName: 'LAS 1',
      serverLocation: 'Santiago, Chile',
    ),
    const Game(
      id: 'valorant',
      name: 'Valorant',
      ping: '-- ms',
      loss: '0.0%',
      jitter: '0ms',
      status: 'Esperando...',
      serverName: 'BR 1',
      serverLocation: 'São Paulo, Brazil',
    ),
    const Game(
      id: 'fortnite',
      name: 'Fortnite',
      ping: '-- ms',
      loss: '0.0%',
      jitter: '0ms',
      status: 'Esperando...',
      serverName: 'NAE 2',
      serverLocation: 'Virginia, USA',
    ),
    const Game(
      id: 'pubg',
      name: 'PUBG',
      ping: '-- ms',
      loss: '0.0%',
      jitter: '0ms',
      status: 'Esperando...',
      serverName: 'LAS 2',
      serverLocation: 'Santiago, Chile',
    ),
    const Game(
      id: 'dota2',
      name: 'Dota 2',
      ping: '-- ms',
      loss: '0.0%',
      jitter: '0ms',
      status: 'Esperando...',
      serverName: 'BR 2',
      serverLocation: 'São Paulo, Brazil',
    ),
  ];

  GamingRepository() {
    // Emitimos el estado inicial
    scheduleMicrotask(() => _gamesController.add(_games));
  }

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
      final status = _getPingStatusText(ping);
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

  String _getPingStatusText(double pingMs) {
    if (pingMs == 0) return "Sin Conexión";
    if (pingMs < 35) return "Excelente";
    if (pingMs < 60) return "Muy Bueno";
    if (pingMs < 100) return "Bueno";
    if (pingMs < 150) return "Regular";
    return "Malo";
  }

  Stream<List<Game>> watchGames() => _gamesController.stream;

  Stream<Game?> watchGame(String id) {
    return watchGames().map(
      (games) => games.firstWhere(
        (g) => g.id == id,
        orElse: () => _games.firstWhere((g) => g.id == id),
      ),
    );
  }
}
