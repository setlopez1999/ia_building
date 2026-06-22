import '../../models/fibra.dart';

/// Contrato abstracto para estado de fibra óptica.
/// GET /v1/fibra  (FIBRA-1)
abstract class FibraRepository {
  /// Devuelve potencia (dBm) y estado de la fibra óptica.
  Future<Fibra> getFibra();
}
