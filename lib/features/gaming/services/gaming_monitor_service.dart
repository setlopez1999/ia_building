import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/services/network_analyzer_service.dart';
import '../providers/gaming_provider.dart';

part 'gaming_monitor_service.g.dart';

class GameServer {
  final String target;
  final String name;
  final String location;

  const GameServer({
    required this.target,
    required this.name,
    required this.location,
  });
}

@riverpod
class GamingMonitor extends _$GamingMonitor {
  Timer? _timer;
  final _analyzer = NetworkAnalyzerService();

  // Mapeo de juegos a sus listas de servidores con metadata real del script de Python
  final Map<String, List<GameServer>> _gameTargets = {
    'cs2': [
      const GameServer(
        target: '155.133.244.51',
        name: 'Valve Lima',
        location: 'Lima',
      ),
      const GameServer(
        target: '155.133.249.179',
        name: 'Valve Santiago',
        location: 'Santiago',
      ),
      const GameServer(
        target: '155.133.227.67',
        name: 'Valve Sao Paulo',
        location: 'Sao Paulo',
      ),
      const GameServer(
        target: '155.133.255.254',
        name: 'Valve Buenos Aires',
        location: 'Buenos Aires',
      ),
      const GameServer(
        target: '205.196.6.210',
        name: 'Valve Seattle',
        location: 'Seattle',
      ),
      const GameServer(
        target: '162.254.193.71',
        name: 'Valve Chicago',
        location: 'Chicago',
      ),
      const GameServer(
        target: '162.254.194.54',
        name: 'Valve Dallas',
        location: 'Dallas',
      ),
    ],
    'valorant': [
      const GameServer(
        target: 'ae1.er01.mex01.riotdirect.net',
        name: 'Bogotá Edge',
        location: 'Bogota',
      ),
      const GameServer(
        target: 'te-0-0-0-35-0.er02.sao02.riotdirect.net',
        name: 'BR Sao Paulo',
        location: 'Sao Paulo',
      ),
      const GameServer(
        target: 'te-0-0-0-20-0.er01.scl02.riotdirect.net',
        name: 'Santiago Edge',
        location: 'Santiago',
      ),
      const GameServer(
        target: 'er01.mia02.riotdirect.net',
        name: 'US Miami',
        location: 'Miami',
      ),
      const GameServer(
        target: 'ae1.er02.bog01.riotdirect.net',
        name: 'Mexico City',
        location: 'Mexico City',
      ),
    ],
    'dota2': [
      const GameServer(
        target: 'dynamodb.us-east-1.amazonaws.com',
        name: 'US East',
        location: 'Virginia',
      ),
      const GameServer(
        target: 'dynamodb.us-west-1.amazonaws.com',
        name: 'US West',
        location: 'California',
      ),
      const GameServer(
        target: 'dynamodb.eu-central-1.amazonaws.com',
        name: 'Europe West',
        location: 'Frankfurt',
      ),
      const GameServer(
        target: 'dynamodb.sa-east-1.amazonaws.com',
        name: 'Brasil',
        location: 'Sao Paulo',
      ),
    ],
    'fortnite': [
      const GameServer(
        target: 'ec2-52-67-110-115.sa-east-1.compute.amazonaws.com',
        name: 'AWS Sao Paulo',
        location: 'Sao Paulo',
      ),
      const GameServer(
        target: 'ec2-3-231-193-126.compute-1.amazonaws.com',
        name: 'US East (Virginia)',
        location: 'Virginia',
      ),
      const GameServer(
        target: 'ec2-18-116-102-234.us-east-2.compute.amazonaws.com',
        name: 'US East (Ohio)',
        location: 'Ohio',
      ),
      const GameServer(
        target: 'ec2-44-240-118-24.us-west-2.compute.amazonaws.com',
        name: 'US West (Oregon)',
        location: 'Oregon',
      ),
    ],
    'pubg': [
      const GameServer(
        target: 'ec2-52-67-110-115.sa-east-1.compute.amazonaws.com',
        name: 'PUBG SA',
        location: 'Sao Paulo',
      ),
      const GameServer(
        target: 'dynamodb.us-east-1.amazonaws.com',
        name: 'PUBG NA',
        location: 'Iowa',
      ),
    ],
  };

  @override
  void build() {
    _startMonitoring();
    ref.onDispose(() => _timer?.cancel());
  }

  void _startMonitoring() {
    _timer?.cancel();
    _performAnalysis();
    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _performAnalysis(),
    );
  }

  Future<void> _performAnalysis() async {
    final repository = ref.read(gamingRepositoryProvider);

    final futures = _gameTargets.entries.map((entry) async {
      final gameId = entry.key;
      final servers = entry.value;

      // PASO 1: Quick Probe (1 ping rápido a TODOS los servidores en paralelo)
      final probeResults = await Future.wait(
        servers.map((s) => _analyzer.analyze(s.target, count: 1)),
      );

      // PASO 2: Encontrar el mejor servidor basado en latencia
      GameServer? bestServer;
      double minPing = 99999;

      for (int i = 0; i < servers.length; i++) {
        final result = probeResults[i];
        if (result.success && result.avgPing < minPing) {
          minPing = result.avgPing;
          bestServer = servers[i];
        }
      }

      // Si no encontramos ninguno exitoso, usamos el primero por defecto para el reintento profundo
      bestServer ??= servers.first;

      // PASO 3: Análisis Profundo (4 pings) al mejor servidor encontrado
      final deepResult = await _analyzer.analyze(bestServer.target, count: 4);

      if (deepResult.success) {
        repository.updateGameMetrics(
          id: gameId,
          ping: deepResult.avgPing,
          loss: deepResult.lossPercent,
          jitter: deepResult.jitter,
          serverName: bestServer.name,
          serverLocation: bestServer.location,
        );
      } else {
        repository.updateGameMetrics(
          id: gameId,
          ping: 0,
          loss: 100,
          jitter: 0,
          serverName: bestServer.name,
          serverLocation: bestServer.location,
        );
      }
    });

    await Future.wait(futures);
  }
}
