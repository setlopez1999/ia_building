import 'package:tvapp/core/domain/entities/tools/wifi_info.dart';
import 'package:tvapp/core/infraestructure/datasource/tools/tools_api_client.dart';
import 'package:tvapp/storage/tools/local_storage.dart';

import 'wifi_repository.dart';

class WifiRepositoryImpl implements WifiRepository {

  WifiRepositoryImpl(this._api);
  final ToolsApiClient _api;

  @override
  Future<void> cambiarNombre(String nuevoNombre) async {
    final clienteId = LocalStorage.getClienteId() ?? '';
    final data = await _api.post(
      '/v1/wifi/nombre',
      body: {'cliente_id': clienteId, 'nuevo_nombre': nuevoNombre},
    );
    if (data['success'] != true) {
      throw Exception(data['mensaje'] ?? 'Error al cambiar nombre de red');
    }
  }

  @override
  Future<void> cambiarPassword(String nuevaPassword) async {
    final data = await _api.postForgiving(
      '/v1/wifi/password',
      body: {'nueva_password': nuevaPassword},
    );
    if (data['success'] == true) return;
    final msg = data['msg'] as String?
        ?? data['mensaje'] as String?
        ?? data['message'] as String?
        ?? (data['error'] is String ? data['error'] as String : null)
        ?? 'Error al cambiar contraseña';
    throw Exception(msg);
  }

  @override
  Future<String?> getSsid() async {
    final data = await _api.get('/v1/wifi/ssid');
    return data['ssid'] as String?;
  }

  @override
  Future<WifiInfo> getWifiStatus() async {
    final data = await _api.get('/v1/wifi/ssid');
    return WifiInfo(
      ssid: data['ssid'] as String?,
      signalStrengthDbm: (data['signal_dbm'] as num?)?.round(),
      bandOverride: data['band'] as String?,
      signalQualityOverride: data['signal_quality'] as String?,
    );
  }
}
