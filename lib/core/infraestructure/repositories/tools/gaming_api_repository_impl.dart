import 'dart:async';
import 'i_gaming_repository.dart';
import 'package:tvapp/core/domain/entities/tools/servidor_juego.dart';
import 'package:tvapp/core/infraestructure/datasource/tools/i_tools_api_datasource.dart';

class GamingApiRepositoryImpl implements IGamingRepository {
  final IToolsApiDatasource _api;
  final _streamController = StreamController<List<ServidorJuego>>.broadcast();
  List<ServidorJuego> _servidores = [];

  GamingApiRepositoryImpl(this._api);

  @override
  Future<List<ServidorJuego>> getServidores() async {
    final data = await _api.get('/v1/gaming/servers');
    final list = data['servidores'] as List<dynamic>;
    _servidores = list.map((e) {
      final id = e['id'] as String;
      final existing = _servidores.firstWhere(
        (s) => s.id == id,
        orElse: () => ServidorJuego(id: id, juego: '', servidor: '', ubicacion: '', ip: ''),
      );
      return ServidorJuego(
        id: id,
        juego: e['juego'] as String,
        servidor: e['servidor'] as String,
        ubicacion: e['ubicacion'] as String,
        ip: e['ip'] as String,
        logo: e['logo'] as String? ?? '',
        pingMs: existing.pingMs,
        jitterMs: existing.jitterMs,
        perdidaPaquetesPct: existing.perdidaPaquetesPct,
        estado: existing.estado,
      );
    }).toList();
    _streamController.add(List.from(_servidores));
    return _servidores;
  }

  List<ServidorJuego> get currentServidores => List.from(_servidores);

  ServidorJuego? getServidorById(String id) {
    try {
      return _servidores.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
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

  Stream<List<ServidorJuego>> watchServidores() async* {
    if (_servidores.isNotEmpty) yield List.from(_servidores);
    yield* _streamController.stream;
  }

  String _calcEstado(int pingMs) {
    if (pingMs == 0) return 'SIN_CONEXIÓN';
    if (pingMs < 35) return 'EXCELENTE';
    if (pingMs < 60) return 'BUENO';
    return 'MALO';
  }

  void dispose() => _streamController.close();
}
