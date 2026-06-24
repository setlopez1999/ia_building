import '../interfaces/notificacion_repository.dart';
import '../../models/notificacion.dart';
import '../../sources/remote/api_client.dart';

class NotificacionRepositoryImpl implements NotificacionRepository {
  final ApiClient _api;

  NotificacionRepositoryImpl(this._api);

  @override
  Future<List<Notificacion>> getNotificaciones() async {
    final data = await _api.get('/v1/notifications');
    final list = data['notificaciones'] as List<dynamic>? ?? [];
    return list
        .map((e) => Notificacion(
              id: (e['id'] as String?) ?? '',
              titulo: (e['titulo'] as String?) ?? '',
              mensaje: (e['mensaje'] as String?) ?? '',
              fecha: DateTime.tryParse(e['fecha'] as String? ?? '') ?? DateTime.now(),
              leido: (e['leido'] as bool?) ?? false,
            ))
        .toList();
  }
}
