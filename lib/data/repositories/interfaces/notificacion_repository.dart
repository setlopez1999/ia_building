import '../../models/notificacion.dart';

/// Contrato abstracto para notificaciones del ISP.
/// GET /v1/notifications  (NOTIF-1)
abstract class NotificacionRepository {
  /// Devuelve la lista de notificaciones del usuario.
  Future<List<Notificacion>> getNotificaciones();
}
