import 'dart:async';
import 'dart:math';
import '../models/game.dart';

class GamingRepository {
  List<Game> _games = [
    const Game(
      id: 'lol',
      name: 'Counter Strike 2',
      ping: '12 ms',
      loss: '0.0%',
      jitter: '2ms',
      status: 'Excelente',
      serverName: 'LAS 1',
      serverLocation: 'Santiago, Chile',
    ),
    const Game(
      id: 'valorant',
      name: 'Valorant',
      ping: '28 ms',
      loss: '0.1%',
      jitter: '1ms',
      status: 'Excelente',
      serverName: 'BR 1',
      serverLocation: 'São Paulo, Brazil',
    ),
    const Game(
      id: 'fortnite',
      name: 'Fortnite',
      ping: '56 ms',
      loss: '0.5%',
      jitter: '4ms',
      status: 'Estable',
      serverName: 'NAE 2',
      serverLocation: 'Virginia, USA',
    ),
    const Game(
      id: 'pubg',
      name: 'PUBG',
      ping: '45 ms',
      loss: '0.0%',
      jitter: '3ms',
      status: 'Excelente',
      serverName: 'LAS 2',
      serverLocation: 'Santiago, Chile',
    ),
    const Game(
      id: 'dota2',
      name: 'Dota 2',
      ping: '35 ms',
      loss: '0.2%',
      jitter: '2ms',
      status: 'Excelente',
      serverName: 'BR 2',
      serverLocation: 'São Paulo, Brazil',
    ),
  ];

  // Esto cambiar a futuro para que consuma un api y no dats aleatorios
  // ver si en vez de DIO usamos WebSocketChannel para la sincronizacion
  /*
class GamingRepository {
  final Dio _dio = Dio(); // Cliente para conectar con el backend
  Stream<List<Game>> watchGames() async* {
    while (true) {
      try {
        // 1. Haces la petición a tu API real
        final response = await _dio.get('https://tu-api.com/v1/games-status');
        
        // 2. Conviertes la respuesta JSON a tu modelo de Freezed
        final List<dynamic> data = response.data;
        final games = data.map((json) => Game.fromJson(json)).toList();
        
        // 3. Emites los datos reales a la UI
        yield games;
      } catch (e) {
        print('Error conectando con el backend: $e');
      }
      
      // 4. Esperas un tiempo para la siguiente actualización (ej. cada 30 seg)
      await Future.delayed(const Duration(seconds: 30));
    }
  }
}


*/

  Stream<List<Game>> watchGames() async* {
    while (true) {
      final random = Random();
      _games = _games.map((g) {
        final currentPing = int.parse(g.ping.split(' ')[0]);
        final volatility = random.nextInt(9) - 4; // -4 to +4
        final newPing = (currentPing + volatility).clamp(15, 120);

        return g.copyWith(
          ping: '$newPing ms',
          jitter: '${random.nextInt(5) + 1}ms',
        );
      }).toList();

      yield _games;
      await Future.delayed(const Duration(milliseconds: 1500));
    }
  }

  Stream<Game?> watchGame(String id) async* {
    await for (final games in watchGames()) {
      yield games.firstWhere(
        (g) => g.id == id,
        orElse: () => _games.firstWhere((g) => g.id == id),
      );
    }
  }
}
