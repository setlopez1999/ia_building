import 'fibra_repository.dart';
import '../../../../shared/data/models/fibra.dart';
import '../../../../shared/data/remote/api_client.dart';

class FibraRepositoryImpl implements FibraRepository {
  final ApiClient _api;

  FibraRepositoryImpl(this._api);

  @override
  Future<Fibra> getFibra() async {
    final data = await _api.get('/v1/fibra');
    return Fibra(
      potenciaDbm: data['potencia_dbm'] as String,
      estado: data['estado'] as String,
    );
  }
}
