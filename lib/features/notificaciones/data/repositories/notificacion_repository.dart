import '../../../../shared/data/models/notificacion.dart';

abstract class NotificacionRepository {
  Future<List<Notificacion>> getNotificaciones();
}
