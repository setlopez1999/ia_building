import '../../models/servidor_juego.dart';

/// Contrato abstracto para servidores de juegos y métricas.
/// GET /v1/gaming/servers  (GAMING-1)
abstract class IGamingRepository {
  /// Devuelve la lista de servidores de juegos con sus métricas de red.
  Future<List<ServidorJuego>> getServidores();
}
