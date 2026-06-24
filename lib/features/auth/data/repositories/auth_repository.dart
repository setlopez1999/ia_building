import '../models/auth_result.dart';

abstract class AuthRepository {
  Future<AuthResult> login(String usuario, String password);
  Future<void> logout();
  String? getToken();
  String? getClienteId();
}
