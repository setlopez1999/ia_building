/// Contrato abstracto para gestión de la red WiFi del cliente.
/// POST /v1/wifi/nombre    (WIFI-1)
/// POST /v1/wifi/password  (WIFI-2)
abstract class WifiRepository {
  /// Cambia el nombre (SSID) de la red WiFi del cliente.
  Future<void> cambiarNombre(String clienteId, String nuevoNombre);

  /// Cambia la contraseña de la red WiFi del cliente.
  Future<void> cambiarPassword(String clienteId, String nuevaPassword);
}
