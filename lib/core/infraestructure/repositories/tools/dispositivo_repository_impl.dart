import 'package:tvapp/core/domain/entities/tools/dispositivo.dart';
import 'package:tvapp/core/infraestructure/datasource/tools/tools_api_client.dart';

import 'dispositivo_repository.dart';

class DispositivoRepositoryImpl implements DispositivoRepository {

  DispositivoRepositoryImpl(this._api);
  final ToolsApiClient _api;

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
