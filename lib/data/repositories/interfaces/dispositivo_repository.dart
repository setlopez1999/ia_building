import '../../models/dispositivo.dart';

/// Contrato abstracto para dispositivos conectados a la red.
/// GET /v1/dispositivos  (DISP-1)
abstract class DispositivoRepository {
  /// Devuelve la lista de dispositivos conectados a la red del cliente.
  Future<List<Dispositivo>> getDispositivos();
}
