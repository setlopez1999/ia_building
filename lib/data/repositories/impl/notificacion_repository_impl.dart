import '../interfaces/notificacion_repository.dart';
import '../../models/notificacion.dart';
import '../../sources/remote/api_client.dart';

/// Implementación real de NotificacionRepository.
/// GET /v1/notifications  (NOTIF-1)
class NotificacionRepositoryImpl implements NotificacionRepository {
  final ApiClient _api;

  NotificacionRepositoryImpl(this._api);

  @override
  Future<List<Notificacion>> getNotificaciones() async {
    final data = await _api.get('/v1/notifications');
    final list = data['notificaciones'] as List<dynamic>;
    return list
        .map((e) => Notificacion(
              id: e['id'] as String,
              titulo: e['titulo'] as String,
              mensaje: e['mensaje'] as String,
              fecha: DateTime.parse(e['fecha'] as String),
              leido: e['leido'] as bool,
            ))
        .toList();
  }
}
