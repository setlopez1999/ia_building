import 'package:tvapp/core/shared/exceptions/app_exception.dart';

/// Estados por los que pasa una llamada.
///
/// Viven en el dominio, no en la pantalla: la central de hoy (Asterisk) y la
/// de mañana (VICIdial) producen los mismos estados, y la UI no distingue
/// cuál está detrás.
sealed class CallSessionState {
  const CallSessionState();
}

/// Todavía no se habló con la central.
class CallDesconectada extends CallSessionState {
  const CallDesconectada();
}

/// Registrándose contra la central.
class CallRegistrando extends CallSessionState {
  const CallRegistrando();
}

/// Registrado y libre: se puede llamar y se pueden recibir llamadas.
class CallLista extends CallSessionState {
  const CallLista();
}

/// Llamada saliente en curso, esperando que atiendan del otro lado.
class CallSaliente extends CallSessionState {
  const CallSaliente();
}

/// Está entrando una llamada.
class CallEntrante extends CallSessionState {
  const CallEntrante(this.deQuien);

  /// Quién llama, tal como lo informa la central.
  final String deQuien;
}

/// Llamada establecida: hay audio en los dos sentidos.
class CallEnCurso extends CallSessionState {
  const CallEnCurso({required this.desde, required this.silenciado});

  /// Momento en que atendieron. La pantalla cuenta el tiempo desde acá.
  final DateTime desde;
  final bool silenciado;

  CallEnCurso copyWith({bool? silenciado}) => CallEnCurso(
        desde: desde,
        silenciado: silenciado ?? this.silenciado,
      );
}

/// La llamada terminó sin error. [motivo] es texto para mostrarle al usuario.
class CallFinalizada extends CallSessionState {
  const CallFinalizada(this.motivo);

  final String motivo;
}

/// Algo falló: no se pudo registrar, no se pudo llamar, se cayó la conexión.
class CallFallida extends CallSessionState {
  const CallFallida(this.error);

  final AppException error;
}
