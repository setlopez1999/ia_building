import '../interfaces/fibra_repository.dart';
import '../../models/fibra.dart';
import '../../sources/remote/api_client.dart';

class FibraRepositoryImpl implements FibraRepository {
  final ApiClient _api;

  FibraRepositoryImpl(this._api);

  @override
  Future<Fibra> getFibra() async {
    final data = await _api.get('/v1/fibra');
    return Fibra(
      potenciaDbm: (data['potencia_dbm'] as String?) ?? '-18.5',
      estado: (data['estado'] as String?) ?? 'OK',
    );
  }
}
