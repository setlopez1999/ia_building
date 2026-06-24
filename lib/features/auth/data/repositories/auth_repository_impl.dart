import 'auth_repository.dart';
import '../models/auth_result.dart';
import '../../../../shared/data/remote/api_client.dart';
import '../../../../shared/data/local/local_storage.dart';

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

    final result = AuthResult(
      token: data['token'] as String,
      clienteId: data['cliente_id'] as String,
      nombre: data['user']['nombre'] as String,
      apellido: data['user']['apellido'] as String,
      email: data['user']['email'] as String,
      role: data['user']['role'] as String,
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
