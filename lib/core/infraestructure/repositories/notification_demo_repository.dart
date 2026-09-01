import 'package:fpdart/fpdart.dart';
import 'package:tvapp/core/domain/entities/notification/notification_entity.dart';
import 'package:tvapp/core/infraestructure/repositories/notification_http_repository.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

/// Notificaciones de muestra para revisar el maquetado.
///
/// ⚠️ Se usa **solo** con `DEMO=true` en el `.env`. Con el flag apagado la app
/// consume la API real y no queda ni rastro de estos datos.
/// Extiende la implementación real y solo reemplaza la lectura y el marcado:
/// el resto del contrato sigue funcionando igual.
class NotificationDemoRepository extends NotificationHttpRepository {
  static String _hoy(int diasAtras) {
    final d = DateTime.now().subtract(Duration(days: diasAtras));
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '${d.year}-$mm-$dd 10:30:00';
  }

  @override
  Future<Either<AppException, List<NotificationEntity>>> getNotifications(
      String userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    return Right([
      NotificationEntity(
        id: 1,
        title: 'Nuevo Evento agregado',
        text: 'Disfruta de la Copa Femenina De fútbol Concacaf',
        read: 0,
        created_at: _hoy(0),
        updated_at: _hoy(0),
      ),
      NotificationEntity(
        id: 2,
        title: 'Nuevo Evento agregado',
        text: 'Disfruta de la Copa Femenina De fútbol Concacaf',
        read: 0,
        created_at: _hoy(1),
        updated_at: _hoy(1),
      ),
      NotificationEntity(
        id: 3,
        title: 'Nuevo Evento agregado',
        text: 'Disfruta de la Copa Femenina De fútbol Concacaf',
        read: 1,
        created_at: _hoy(2),
        updated_at: _hoy(2),
      ),
      NotificationEntity(
        id: 4,
        title: 'Actualización de tu plan',
        text: 'Revisa los canales que se sumaron a tu paquete este mes',
        read: 1,
        created_at: _hoy(4),
        updated_at: _hoy(4),
      ),
    ]);
  }

  @override
  Future<void> markAsRead(
      NotificationEntity notification, String userID) async {
    // En demo no hay servidor al que avisarle.
  }
}
