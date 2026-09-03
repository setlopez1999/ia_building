import 'package:fpdart/fpdart.dart';
import 'package:tvapp/core/domain/entities/call/call_session_state.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

/// Teléfono del módulo Mascotas.
///
/// La pantalla depende solo de esta interfaz. La implementación de hoy habla
/// SIP contra el Asterisk de pruebas; la de mañana va a hablar contra el
/// VICIdial del cliente. Los estados que emite son los mismos, así que la
/// pantalla no cambia.
abstract class CallRepository {
  /// Estados de la llamada, en orden. La pantalla se dibuja con esto.
  Stream<CallSessionState> get cambios;

  CallSessionState get estadoActual;

  /// Se registra en la central. Hay que llamarlo antes de [llamar].
  Future<Either<AppException, void>> conectar();

  /// Llama al destino configurado (el veterinario).
  Future<Either<AppException, void>> llamar();

  /// Atiende una llamada entrante.
  Future<void> contestar();

  /// Corta. Sirve tanto para cancelar una saliente como para terminar una
  /// llamada en curso o rechazar una entrante.
  Future<void> colgar();

  /// Silencia o reactiva el micrófono.
  void silenciar(bool valor);

  /// Se da de baja de la central y libera los recursos.
  Future<void> desconectar();
}
