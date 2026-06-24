import 'dispositivo_repository.dart';
import '../../../../shared/data/models/dispositivo.dart';
import '../../../../shared/data/remote/api_client.dart';

class DispositivoRepositoryImpl implements DispositivoRepository {
  final ApiClient _api;

  DispositivoRepositoryImpl(this._api);

  @override
  Future<List<Dispositivo>> getDispositivos() async {
    final data = await _api.get('/v1/dispositivos');
    final list = data['dispositivos'] as List<dynamic>;
    return list
        .map((e) => Dispositivo(
              id: e['id'] as String,
              nombre: e['nombre'] as String,
              mac: e['mac'] as String,
              ipLocal: e['ip_local'] as String,
              tipo: e['tipo'] as String,
              conectado: e['conectado'] as bool,
            ))
        .toList();
  }
}
