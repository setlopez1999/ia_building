import 'perfil_repository.dart';
import '../../../../shared/data/models/user.dart';
import '../../../../shared/data/remote/api_client.dart';

class PerfilRepositoryImpl implements PerfilRepository {
  final ApiClient _api;

  PerfilRepositoryImpl(this._api);

  @override
  Future<User> getProfile() async {
    final data = await _api.get('/v1/user/profile');
    return User(
      clienteId: data['cliente_id'] as String,
      nombre: data['nombre'] as String,
      planContratado: data['plan_contratado'] as String,
      email: data['email'] as String,
      telefono: data['telefono'] as String,
    );
  }

  @override
  Future<void> updateProfile(String nombre, String telefono) async {
    await _api.put('/v1/user/profile', body: {'nombre': nombre, 'telefono': telefono});
  }
}
