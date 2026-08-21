import 'diagnostico_repository.dart';
import 'package:tvapp/core/domain/entities/tools/diagnostico.dart';
import 'package:tvapp/core/infraestructure/datasource/tools/tools_api_client.dart';

class DiagnosticoRepositoryImpl implements DiagnosticoRepository {
  final ToolsApiClient _api;

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
              latenciaGoogleMs: e['latencia_google_ms'] as int?,
              velocidadBajadaMbps: (e['velocidad_bajada_mbps'] as num).toDouble(),
              resultado: e['resultado'] as String,
              wifiSsid: e['wifi_ssid'] as String?,
              wifiSenialDbm: (e['wifi_signal_dbm'] as num?)?.round(),
              wifiBanda: e['wifi_banda'] as String?,
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
        'wifi_ssid': req.wifiSsid,
        'wifi_signal_dbm': req.wifiSenialDbm,
        'wifi_banda': req.wifiBanda,
      },
    );
    return DiagnosticoSaveResult(
      success: data['success'] as bool,
      diagnosticoId: data['diagnostico_id'] as String,
      resultado: data['resultado'] as String,
    );
  }
}
