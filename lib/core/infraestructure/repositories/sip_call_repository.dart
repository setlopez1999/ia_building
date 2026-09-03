import 'dart:async';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sip_ua/sip_ua.dart';
import 'package:tvapp/core/domain/entities/call/call_credentials.dart';
import 'package:tvapp/core/domain/repositories/call_credentials_repository.dart';
import 'package:tvapp/core/domain/repositories/call_repository.dart';
import 'package:tvapp/core/domain/entities/call/call_session_state.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

/// Teléfono SIP real: el celular es un extremo de la llamada, no un botón que
/// le pide a un servidor que llame por él.
///
/// Eso es lo que permite saber si atendieron, cortar de los dos lados y
/// silenciar el micrófono: son estados de la llamada, y para tenerlos hay que
/// estar adentro de ella.
///
/// Contra qué central se registra lo decide [CallCredentialsRepository], no
/// esta clase.
class SipCallRepository implements CallRepository, SipUaHelperListener {
  SipCallRepository(this._credenciales);

  final CallCredentialsRepository _credenciales;

  final SIPUAHelper _helper = SIPUAHelper();
  final StreamController<CallSessionState> _estados =
      StreamController<CallSessionState>.broadcast();

  CallSessionState _estado = const CallDesconectada();
  Call? _llamada;
  Timer? _timerSinRespuesta;
  bool _atendieron = false;
  bool _silenciado = false;
  Completer<Either<AppException, void>>? _registro;

  /// Cuánto se espera a que atiendan antes de darla por no contestada.
  ///
  /// Es una red de seguridad: normalmente corta antes la central (el `Dial`
  /// del dialplan tiene su propio tiempo). Si la central no avisa, este timer
  /// evita que la pantalla quede colgada en "Llamando" para siempre.
  static const Duration _esperaMaxima = Duration(seconds: 45);

  @override
  Stream<CallSessionState> get cambios => _estados.stream;

  @override
  CallSessionState get estadoActual => _estado;

  void _emitir(CallSessionState nuevo) {
    _estado = nuevo;
    if (!_estados.isClosed) _estados.add(nuevo);
  }

  // ── Conexión ──────────────────────────────────────────────────────────────

  @override
  Future<Either<AppException, void>> conectar() async {
    if (_estado is CallLista || _estado is CallEnCurso) {
      return const Right(null);
    }

    final credenciales = await _credenciales.obtener();

    return credenciales.fold(Left.new, (datos) async {
      _emitir(const CallRegistrando());
      _helper.addSipUaHelperListener(this);

      final espera = Completer<Either<AppException, void>>();
      _registro = espera;

      try {
        await _helper.start(_ajustes(datos));
      } catch (error) {
        _registro = null;
        final falla = AppException(
          identifier: 'sip-start',
          statusCode: 0,
          message: 'No se pudo conectar con la central.',
          detail: '$error',
        );
        _emitir(CallFallida(falla));
        return Left(falla);
      }

      // Si la central no responde, no dejamos la pantalla esperando eterno.
      return espera.future.timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          final falla = AppException(
            identifier: 'sip-registro',
            statusCode: 0,
            message: 'La central no respondió.',
            detail: 'No hubo respuesta al registro contra ${datos.wsUrl}.',
          );
          _emitir(CallFallida(falla));
          return Left(falla);
        },
      );
    });
  }

  UaSettings _ajustes(CallCredentials datos) {
    return UaSettings()
      ..webSocketUrl = datos.wsUrl
      ..uri = datos.uri
      ..authorizationUser = datos.usuario
      ..password = datos.clave
      ..displayName = datos.displayName
      ..userAgent = 'OnePlay Mascotas'
      ..transportType = TransportType.WS
      ..register = true
      // La central es local: sin STUN la negociación es más rápida y no
      // depende de que haya internet.
      ..iceServers = <Map<String, String>>[];
  }

  @override
  Future<void> desconectar() async {
    _timerSinRespuesta?.cancel();
    _helper.removeSipUaHelperListener(this);
    try {
      await _helper.unregister();
    } catch (_) {
      // Si ya estaba caída la conexión no hay nada que dar de baja.
    }
    _helper.stop();
    _llamada = null;
    _emitir(const CallDesconectada());
  }

  // ── Llamada ───────────────────────────────────────────────────────────────

  @override
  Future<Either<AppException, void>> llamar() async {
    if (_estado is! CallLista && _estado is! CallFinalizada) {
      final conectado = await conectar();
      if (conectado.isLeft()) return conectado;
    }

    final credenciales = await _credenciales.obtener();

    return credenciales.fold(Left.new, (datos) async {
      _atendieron = false;
      _silenciado = false;
      _emitir(const CallSaliente());

      final salio = await _helper.call(datos.uriDestino, voiceOnly: true);
      if (!salio) {
        final falla = AppException(
          identifier: 'sip-llamar',
          statusCode: 0,
          message: 'No se pudo iniciar la llamada.',
          detail: 'La central rechazó el intento hacia ${datos.uriDestino}.',
        );
        _emitir(CallFallida(falla));
        return Left(falla);
      }

      _timerSinRespuesta?.cancel();
      _timerSinRespuesta = Timer(_esperaMaxima, () {
        if (!_atendieron) {
          _llamada?.hangup();
          _terminar('Nadie atendió la llamada.');
        }
      });

      return const Right(null);
    });
  }

  @override
  Future<void> contestar() async {
    final llamada = _llamada;
    if (llamada == null) return;
    llamada.answer(_helper.buildCallOptions(true));
  }

  @override
  Future<void> colgar() async {
    _timerSinRespuesta?.cancel();
    final llamada = _llamada;
    if (llamada == null) {
      _terminar('Llamada terminada.');
      return;
    }
    llamada.hangup();
  }

  @override
  void silenciar(bool valor) {
    final llamada = _llamada;
    if (llamada == null) return;

    valor ? llamada.mute(true, false) : llamada.unmute(true, false);
    _silenciado = valor;

    final actual = _estado;
    if (actual is CallEnCurso) {
      _emitir(actual.copyWith(silenciado: valor));
    }
  }

  void _terminar(String motivo) {
    _timerSinRespuesta?.cancel();
    _llamada = null;
    _emitir(CallFinalizada(motivo));
  }

  // ── Eventos de la central ─────────────────────────────────────────────────

  @override
  void registrationStateChanged(RegistrationState state) {
    switch (state.state) {
      case RegistrationStateEnum.REGISTERED:
        _registro?.complete(const Right(null));
        _registro = null;
        _emitir(const CallLista());
      case RegistrationStateEnum.UNREGISTERED:
      case RegistrationStateEnum.NONE:
        break;
      case RegistrationStateEnum.REGISTRATION_FAILED:
      case null:
        final falla = AppException(
          identifier: 'sip-registro',
          statusCode: state.cause?.status_code ?? 0,
          message: 'No se pudo registrar en la central.',
          detail: state.cause?.cause ?? 'Sin detalle de la central.',
        );
        _registro?.complete(Left(falla));
        _registro = null;
        _emitir(CallFallida(falla));
    }
  }

  @override
  void callStateChanged(Call call, CallState state) {
    _llamada = call;

    switch (state.state) {
      case CallStateEnum.CALL_INITIATION:
      case CallStateEnum.CONNECTING:
      case CallStateEnum.PROGRESS:
        if (call.direction == Direction.incoming) {
          _emitir(CallEntrante(call.remote_identity ?? 'Asistencia'));
        } else {
          _emitir(const CallSaliente());
        }

      case CallStateEnum.ACCEPTED:
      case CallStateEnum.CONFIRMED:
        _timerSinRespuesta?.cancel();
        _atendieron = true;
        // Sin esto el audio sale por el auricular y parece que no anda.
        Helper.setSpeakerphoneOn(true);
        _emitir(CallEnCurso(desde: DateTime.now(), silenciado: _silenciado));

      case CallStateEnum.MUTED:
        _silenciado = true;
        final enMute = _estado;
        if (enMute is CallEnCurso) _emitir(enMute.copyWith(silenciado: true));

      case CallStateEnum.UNMUTED:
        _silenciado = false;
        final sinMute = _estado;
        if (sinMute is CallEnCurso) {
          _emitir(sinMute.copyWith(silenciado: false));
        }

      case CallStateEnum.ENDED:
        // Distinguir "cortaron" de "no atendieron" no depende del código que
        // mande la central: si nunca llegó a establecerse, no atendieron.
        _terminar(
          _atendieron ? 'Llamada terminada.' : 'Nadie atendió la llamada.',
        );

      case CallStateEnum.FAILED:
        if (_atendieron) {
          _terminar('Llamada terminada.');
        } else {
          _terminar('Nadie atendió la llamada.');
        }

      case CallStateEnum.NONE:
      case CallStateEnum.STREAM:
      case CallStateEnum.REFER:
      case CallStateEnum.HOLD:
      case CallStateEnum.UNHOLD:
        break;
    }
  }

  @override
  void transportStateChanged(TransportState state) {
    if (state.state == TransportStateEnum.DISCONNECTED &&
        _estado is! CallDesconectada) {
      _emitir(
        CallFallida(
          AppException(
            identifier: 'sip-transporte',
            statusCode: 0,
            message: 'Se perdió la conexión con la central.',
            detail: 'El WebSocket se desconectó.',
          ),
        ),
      );
    }
  }

  @override
  void onNewMessage(SIPMessageRequest msg) {}

  @override
  void onNewNotify(Notify ntf) {}

  @override
  void onNewReinvite(ReInvite event) {}
}
