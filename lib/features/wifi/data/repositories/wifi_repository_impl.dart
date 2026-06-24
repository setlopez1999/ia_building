import 'wifi_repository.dart';
import '../../../../shared/data/remote/api_client.dart';

class WifiRepositoryImpl implements WifiRepository {
  final ApiClient _api;

  WifiRepositoryImpl(this._api);

  @override
  Future<void> cambiarNombre(String clienteId, String nuevoNombre) async {
    final data = await _api.post(
      '/v1/wifi/nombre',
      body: {'cliente_id': clienteId, 'nuevo_nombre': nuevoNombre},
    );
    if (data['success'] != true) {
      throw Exception(data['mensaje'] ?? 'Error al cambiar nombre de red');
    }
  }

  @override
  Future<void> cambiarPassword(String clienteId, String nuevaPassword) async {
    final data = await _api.post(
      '/v1/wifi/password',
      body: {'cliente_id': clienteId, 'nueva_password': nuevaPassword},
    );
    if (data['success'] != true) {
      throw Exception(data['mensaje'] ?? 'Error al cambiar contraseña');
    }
  }
}
