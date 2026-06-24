abstract class WifiRepository {
  Future<void> cambiarNombre(String clienteId, String nuevoNombre);
  Future<void> cambiarPassword(String clienteId, String nuevaPassword);
}
