import 'package:fpdart/fpdart.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

/// Origen de una llamada de asistencia.
///
/// El botón del módulo Mascotas depende solo de esta interfaz. Hoy hay una
/// implementación que no hace nada; cuando el servicio de telefonía esté
/// levantado se agrega la implementación real y no se toca la pantalla.
abstract class CallRepository {
  /// Solicita que se origine una llamada hacia el usuario.
  ///
  /// Devuelve `Right(null)` si el servicio acepto la solicitud. Aceptar no es
  /// lo mismo que "el teléfono ya está sonando": el resultado final de la
  /// llamada lo maneja la central.
  Future<Either<AppException, void>> requestCall();
}
