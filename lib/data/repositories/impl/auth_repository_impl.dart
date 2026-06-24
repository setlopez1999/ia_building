import '../interfaces/auth_repository.dart';
import '../../models/app_config.dart';
import '../../sources/remote/api_client.dart';
import '../../sources/local/local_storage.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _api;

  AuthRepositoryImpl(this._api);

  @override
  Future<AuthResult> login(String usuario, String password) async {
    final data = await _api.post(
      '/v1/auth/login',
      body: {'usuario': usuario, 'password': password},
    );

    if (data['error'] != 0) {
      throw Exception(data['msg'] ?? 'Error de autenticación');
    }

    final user = data['user'] as Map<String, dynamic>? ?? {};
    final result = AuthResult(
      token: (data['token'] as String?) ?? '',
      clienteId: (data['cliente_id'] as String?) ?? '',
      nombre: (user['nombre'] as String?) ?? '',
      apellido: (user['apellido'] as String?) ?? '',
      email: (user['email'] as String?) ?? '',
      role: (user['role'] as String?) ?? '',
    );

    await LocalStorage.setToken(result.token);
    await LocalStorage.setClienteId(result.clienteId);

    return result;
  }

  @override
  Future<void> logout() async {
    await LocalStorage.clearSession();
  }

  @override
  String? getToken() => LocalStorage.getToken();

  @override
  String? getClienteId() => LocalStorage.getClienteId();
}
