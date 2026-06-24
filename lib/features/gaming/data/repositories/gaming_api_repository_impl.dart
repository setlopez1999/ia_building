import 'dart:async';
import 'i_gaming_repository.dart';
import '../../../../shared/data/models/servidor_juego.dart';
import '../../../../shared/data/remote/api_client.dart';

class GamingApiRepositoryImpl implements IGamingRepository {
  final ApiClient _api;
  final _streamController = StreamController<List<ServidorJuego>>.broadcast();
  List<ServidorJuego> _servidores = [];

  GamingApiRepositoryImpl(this._api);

  @override
  Future<List<ServidorJuego>> getServidores() async {
    final data = await _api.get('/v1/gaming/servers');
    final list = data['servidores'] as List<dynamic>;
    _servidores = list
        .map((e) => ServidorJuego(
              id: e['id'] as String,
              juego: e['juego'] as String,
              servidor: e['servidor'] as String,
              ubicacion: e['ubicacion'] as String,
              pingMs: e['ping_ms'] as int,
              jitterMs: e['jitter_ms'] as int,
              perdidaPaquetesPct: (e['perdida_paquetes_pct'] as num).toDouble(),
              estado: e['estado'] as String,
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
