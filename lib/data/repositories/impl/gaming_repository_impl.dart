import 'dart:async';
import '../interfaces/gaming_repository.dart';
import '../../models/servidor_juego.dart';
import '../../sources/remote/api_client.dart';

class GamingRepositoryImpl implements IGamingRepository {
  final ApiClient _api;
  final _streamController = StreamController<List<ServidorJuego>>.broadcast();
  List<ServidorJuego> _servidores = [];

  GamingRepositoryImpl(this._api);

  @override
  Future<List<ServidorJuego>> getServidores() async {
    final data = await _api.get('/v1/gaming/servers');
    final list = data['servidores'] as List<dynamic>? ?? [];
    _servidores = list
        .map((e) => ServidorJuego(
              id: (e['id'] as String?) ?? '',
              juego: (e['juego'] as String?) ?? '',
              servidor: (e['servidor'] as String?) ?? '',
              ubicacion: (e['ubicacion'] as String?) ?? '',
              pingMs: (e['ping_ms'] as int?) ?? 0,
              jitterMs: (e['jitter_ms'] as int?) ?? 0,
              perdidaPaquetesPct:
                  ((e['perdida_paquetes_pct'] as num?) ?? 0).toDouble(),
              estado: (e['estado'] as String?) ?? 'SIN_CONEXIÓN',
            ))
        .toList();
    _streamController.add(List.from(_servidores));
    return _servidores;
  }

  void updateMetrics({
    required String id,
    required int pingMs,
    required int jitterMs,
    required double perdidaPaquetesPct,
  }) {
    final idx = _servidores.indexWhere((s) => s.id == id);
    if (idx != -1) {
      _servidores[idx] = _servidores[idx].copyWith(
        pingMs: pingMs,
        jitterMs: jitterMs,
        perdidaPaquetesPct: perdidaPaquetesPct,
        estado: _calcEstado(pingMs),
      );
      _streamController.add(List.from(_servidores));
    }
  }

  Stream<List<ServidorJuego>> watchServidores() => _streamController.stream;

  String _calcEstado(int pingMs) {
    if (pingMs == 0) return 'SIN_CONEXIÓN';
    if (pingMs < 35) return 'EXCELENTE';
    if (pingMs < 60) return 'BUENO';
    return 'MALO';
  }

  void dispose() => _streamController.close();
}
