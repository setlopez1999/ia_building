import 'package:flutter_test/flutter_test.dart';
import 'package:tvapp/core/domain/entities/tools/servidor_juego.dart';
import 'package:tvapp/core/infraestructure/datasource/tools/i_tools_api_datasource.dart';
import 'package:tvapp/core/infraestructure/repositories/tools/gaming_api_repository_impl.dart';

// Fake inyectable para tests — no hace red, responde con datos controlados
class _FakeApi implements IToolsApiDatasource {
  final Map<String, dynamic> _response;
  int callCount = 0;

  _FakeApi(this._response);

  @override
  Future<Map<String, dynamic>> get(String path) async {
    callCount++;
    return _response;
  }
}

Map<String, dynamic> _apiResponse({List<Map<String, dynamic>>? servidores}) =>
    {
      'servidores': servidores ??
          [
            {
              'id': '1',
              'juego': 'Valorant',
              'servidor': 'LATAM South',
              'ubicacion': 'Santiago',
              'ip': '191.98.0.1',
              'logo': 'base64abc==',
            },
            {
              'id': '2',
              'juego': 'CS2',
              'servidor': 'SA East',
              'ubicacion': 'São Paulo',
              'ip': '177.0.0.1',
              'logo': '',
            },
          ]
    };

void main() {
  group('GamingApiRepositoryImpl — getServidores()', () {
    test('parsea id, juego, servidor, ubicacion, ip e logo', () async {
      final repo = GamingApiRepositoryImpl(_FakeApi(_apiResponse()));
      final list = await repo.getServidores();

      expect(list.length, equals(2));
      expect(list[0].id, equals('1'));
      expect(list[0].juego, equals('Valorant'));
      expect(list[0].ip, equals('191.98.0.1'));
      expect(list[0].logo, equals('base64abc=='));
      expect(list[1].id, equals('2'));
      expect(list[1].ip, equals('177.0.0.1'));
    });

    test('inicializa métricas a defaults (0 / SIN_CONEXIÓN)', () async {
      final repo = GamingApiRepositoryImpl(_FakeApi(_apiResponse()));
      final list = await repo.getServidores();

      expect(list[0].pingMs, equals(0));
      expect(list[0].jitterMs, equals(0));
      expect(list[0].perdidaPaquetesPct, equals(0.0));
      expect(list[0].estado, equals('SIN_CONEXIÓN'));
    });

    test('preserva métricas existentes en re-fetch', () async {
      final repo = GamingApiRepositoryImpl(_FakeApi(_apiResponse()));
      await repo.getServidores();

      // Simula que el monitor actualizó las métricas
      repo.updateMetrics(id: '1', pingMs: 25, jitterMs: 3, perdidaPaquetesPct: 0.0);

      // Re-fetch: la API sigue sin devolver métricas, pero deben conservarse
      await repo.getServidores();
      final sv = repo.getServidorById('1')!;

      expect(sv.pingMs, equals(25));
      expect(sv.jitterMs, equals(3));
      expect(sv.estado, equals('EXCELENTE'));
    });

    test('logo null en la API queda como string vacío', () async {
      final response = _apiResponse(servidores: [
        {
          'id': '3',
          'juego': 'LoL',
          'servidor': 'LAS',
          'ubicacion': 'Lima',
          'ip': '200.0.0.1',
          // 'logo' ausente → debe quedar ''
        }
      ]);
      final repo = GamingApiRepositoryImpl(_FakeApi(response));
      final list = await repo.getServidores();

      expect(list[0].logo, equals(''));
    });
  });

  group('GamingApiRepositoryImpl — updateMetrics() y _calcEstado', () {
    late GamingApiRepositoryImpl repo;

    setUp(() async {
      repo = GamingApiRepositoryImpl(_FakeApi(_apiResponse()));
      await repo.getServidores();
    });

    test('ping 0 → estado SIN_CONEXIÓN', () {
      repo.updateMetrics(id: '1', pingMs: 0, jitterMs: 0, perdidaPaquetesPct: 100);
      expect(repo.getServidorById('1')!.estado, equals('SIN_CONEXIÓN'));
    });

    test('ping 34 ms → estado EXCELENTE', () {
      repo.updateMetrics(id: '1', pingMs: 34, jitterMs: 2, perdidaPaquetesPct: 0);
      expect(repo.getServidorById('1')!.estado, equals('EXCELENTE'));
    });

    test('ping 35 ms (límite) → estado BUENO', () {
      repo.updateMetrics(id: '1', pingMs: 35, jitterMs: 4, perdidaPaquetesPct: 0);
      expect(repo.getServidorById('1')!.estado, equals('BUENO'));
    });

    test('ping 59 ms → estado BUENO', () {
      repo.updateMetrics(id: '1', pingMs: 59, jitterMs: 8, perdidaPaquetesPct: 0);
      expect(repo.getServidorById('1')!.estado, equals('BUENO'));
    });

    test('ping 60 ms (límite) → estado MALO', () {
      repo.updateMetrics(id: '1', pingMs: 60, jitterMs: 15, perdidaPaquetesPct: 5);
      expect(repo.getServidorById('1')!.estado, equals('MALO'));
    });

    test('ping 200 ms → estado MALO', () {
      repo.updateMetrics(id: '1', pingMs: 200, jitterMs: 40, perdidaPaquetesPct: 20);
      expect(repo.getServidorById('1')!.estado, equals('MALO'));
    });

    test('actualiza correctamente todos los campos de métricas', () {
      repo.updateMetrics(id: '2', pingMs: 45, jitterMs: 7, perdidaPaquetesPct: 2.5);
      final sv = repo.getServidorById('2')!;

      expect(sv.pingMs, equals(45));
      expect(sv.jitterMs, equals(7));
      expect(sv.perdidaPaquetesPct, equals(2.5));
    });

    test('updateMetrics con id desconocido no lanza excepción', () {
      expect(
        () => repo.updateMetrics(
            id: 'inexistente', pingMs: 10, jitterMs: 1, perdidaPaquetesPct: 0),
        returnsNormally,
      );
    });
  });

  group('GamingApiRepositoryImpl — getServidorById()', () {
    late GamingApiRepositoryImpl repo;

    setUp(() async {
      repo = GamingApiRepositoryImpl(_FakeApi(_apiResponse()));
      await repo.getServidores();
    });

    test('retorna el servidor correcto por id', () {
      final sv = repo.getServidorById('2');
      expect(sv, isNotNull);
      expect(sv!.juego, equals('CS2'));
    });

    test('retorna null para id inexistente', () {
      expect(repo.getServidorById('999'), isNull);
    });
  });

  group('GamingApiRepositoryImpl — currentServidores', () {
    test('retorna lista vacía antes del primer fetch', () {
      final repo = GamingApiRepositoryImpl(_FakeApi(_apiResponse()));
      expect(repo.currentServidores, isEmpty);
    });

    test('retorna copia de la lista (no referencia directa)', () async {
      final repo = GamingApiRepositoryImpl(_FakeApi(_apiResponse()));
      await repo.getServidores();
      final copy = repo.currentServidores;
      copy.clear(); // mutar la copia no debe afectar el estado interno
      expect(repo.currentServidores.length, equals(2));
    });
  });

  group('GamingApiRepositoryImpl — watchServidores() (stream)', () {
    test('emite estado actual inmediatamente para suscriptores tardíos', () async {
      final repo = GamingApiRepositoryImpl(_FakeApi(_apiResponse()));
      await repo.getServidores(); // datos ya en memoria

      // Suscriptor tardío: debe recibir el estado actual sin esperar
      final first = await repo.watchServidores().first;
      expect(first.length, equals(2));
    });

    test('emite actualización después de updateMetrics', () async {
      final repo = GamingApiRepositoryImpl(_FakeApi(_apiResponse()));
      await repo.getServidores();

      final events = <List<ServidorJuego>>[];
      final sub = repo.watchServidores().listen(events.add);

      // El generator async* emite el estado inicial y luego hace yield* al
      // broadcast stream. Esperamos a que esté suscrito antes de emitir update.
      await Future.delayed(const Duration(milliseconds: 30));

      repo.updateMetrics(id: '1', pingMs: 18, jitterMs: 1, perdidaPaquetesPct: 0);
      await Future.delayed(const Duration(milliseconds: 10));

      expect(events.length, greaterThanOrEqualTo(2));
      expect(events.last.firstWhere((s) => s.id == '1').pingMs, equals(18));

      await sub.cancel();
    });
  });
}
