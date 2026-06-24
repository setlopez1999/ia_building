import 'diagnostico_repository.dart';
import '../../../../shared/data/models/diagnostico.dart';
import '../../../../shared/data/remote/api_client.dart';

class DiagnosticoRepositoryImpl implements DiagnosticoRepository {
  final ApiClient _api;

  DiagnosticoRepositoryImpl(this._api);

  @override
  Future<List<Diagnostico>> getHistorial() async {
    final data = await _api.get('/v1/diagnosticos');
    final list = data['historial'] as List<dynamic>;
    return list
        .map((e) => Diagnostico(
              id: e['id'] as String,
              fecha: DateTime.parse(e['fecha'] as String),
              latenciaIspMs: e['latencia_isp_ms'] as int,
              velocidadBajadaMbps: (e['velocidad_bajada_mbps'] as num).toDouble(),
              resultado: e['resultado'] as String,
            ))
        .toList();
  }

  @override
  Future<DiagnosticoSaveResult> saveDiagnostico(DiagnosticoRequest req) async {
    final data = await _api.post(
      '/v1/diagnosticos',
      body: {
        'cliente_id': req.clienteId,
        'latencia_google_ms': req.latenciaGoogleMs,
        'latencia_isp_ms': req.latenciaIspMs,
        'velocidad_bajada_mbps': req.velocidadBajadaMbps,
        'velocidad_subida_mbps': req.velocidadSubidaMbps,
        'fibra_potencia_dbm': req.fibraPotenciaDbm,
        'fibra_estado': req.fibraEstado,
      },
    );
    return DiagnosticoSaveResult(
      success: data['success'] as bool,
      diagnosticoId: data['diagnostico_id'] as String,
      resultado: data['resultado'] as String,
    );
  }
}
