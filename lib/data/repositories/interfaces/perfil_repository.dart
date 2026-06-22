import '../../models/user.dart';

/// Contrato abstracto para perfil de usuario.
/// GET  /v1/user/profile  (PERFIL-1)
/// PUT  /v1/user/profile  (PERFIL-2)
abstract class PerfilRepository {
  /// Obtiene el perfil completo del usuario autenticado.
  Future<User> getProfile();

  /// Actualiza nombre y/o teléfono del usuario.
  Future<void> updateProfile(String nombre, String telefono);
}
