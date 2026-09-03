import 'package:tvapp/core/domain/entities/tools/fibra.dart';
import 'package:tvapp/core/infraestructure/datasource/tools/tools_api_client.dart';

import 'fibra_repository.dart';

class FibraRepositoryImpl implements FibraRepository {

  FibraRepositoryImpl(this._api);
  final ToolsApiClient _api;

  @override
  Future<Fibra> getFibra() async {
    final data = await _api.get('/v1/fibra');
    return Fibra(
      potenciaDbm: data['potencia_dbm'] as String,
      estado: data['estado'] as String,
    );
  }
}
