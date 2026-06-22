import '../interfaces/fibra_repository.dart';
import '../../models/fibra.dart';
import '../../sources/remote/api_client.dart';

/// Implementación real de FibraRepository.
/// GET /v1/fibra  (FIBRA-1)
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
