import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/core/domain/entities/call/call_session_state.dart';
import 'package:tvapp/core/domain/repositories/call_credentials_repository.dart';
import 'package:tvapp/core/domain/repositories/call_repository.dart';
import 'package:tvapp/core/infraestructure/repositories/call_credentials_env_repository.dart';
import 'package:tvapp/core/infraestructure/repositories/sip_call_repository.dart';

/// De dónde salen los datos de la central.
///
/// PUNTO DE CAMBIO para el VICIdial: cuando el backend exponga el endpoint,
/// se reemplaza por una implementación HTTP y queda la cadena
/// celular → backend → central. Nada más se toca.
final callCredentialsProvider = Provider<CallCredentialsRepository>(
  (ref) => const CallCredentialsEnvRepository(),
);

/// El teléfono. Vive mientras viva la app: una llamada no se puede cortar
/// porque el usuario navegó a otra pantalla.
final callRepositoryProvider = Provider<CallRepository>((ref) {
  final repositorio = SipCallRepository(ref.watch(callCredentialsProvider));
  ref.onDispose(repositorio.desconectar);
  return repositorio;
});

/// Estado de la llamada para la pantalla.
class CallNotifier extends Notifier<CallSessionState> {
  StreamSubscription<CallSessionState>? _suscripcion;

  @override
  CallSessionState build() {
    final repositorio = ref.watch(callRepositoryProvider);

    _suscripcion = repositorio.cambios.listen((nuevo) => state = nuevo);
    ref.onDispose(() => _suscripcion?.cancel());

    return repositorio.estadoActual;
  }

  CallRepository get _repositorio => ref.read(callRepositoryProvider);

  /// Se registra en la central. La pantalla lo llama al abrirse para que el
  /// teléfono ya esté listo cuando el usuario toque el botón.
  Future<void> conectar() => _repositorio.conectar();

  Future<void> llamar() async {
    if (state is CallSaliente || state is CallEnCurso) return;
    await _repositorio.llamar();
  }

  Future<void> contestar() => _repositorio.contestar();

  Future<void> colgar() => _repositorio.colgar();

  void silenciar(bool valor) => _repositorio.silenciar(valor);
}

final callProvider = NotifierProvider<CallNotifier, CallSessionState>(
  CallNotifier.new,
);
