import '../../models/app_config.dart';

/// Contrato abstracto para autenticación.
/// POST /v1/auth/login  (AUTH-1)
abstract class AuthRepository {
  /// Realiza login con usuario (email o RUT) y contraseña.
  /// Guarda token y clienteId en SharedPreferences.
  Future<AuthResult> login(String usuario, String password);

  /// Elimina token y clienteId de SharedPreferences.
  Future<void> logout();

  /// Devuelve el JWT almacenado localmente, o null si no hay sesión.
  String? getToken();

  /// Devuelve el clienteId almacenado localmente, o null si no hay sesión.
  String? getClienteId();
}
