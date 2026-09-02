import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/core/domain/repositories/call_repository.dart';
import 'package:tvapp/core/infraestructure/repositories/call_noop_repository.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

/// Única decisión sobre quién origina la llamada.
///
/// Punto de cambio para conectar la central: se reemplaza esta instancia y la
/// pantalla no se entera.
final callRepositoryProvider =
    Provider<CallRepository>((ref) => CallNoopRepository());

/// Estado del pedido de llamada.
sealed class CallState {
  const CallState();
}

class CallIdle extends CallState {
  const CallIdle();
}

class CallRequesting extends CallState {
  const CallRequesting();
}

class CallRequested extends CallState {
  const CallRequested();
}

class CallFailed extends CallState {
  const CallFailed(this.error);
  final AppException error;
}

class CallNotifier extends Notifier<CallState> {
  @override
  CallState build() => const CallIdle();

  Future<void> requestCall() async {
    if (state is CallRequesting) return;

    state = const CallRequesting();
    final result = await ref.read(callRepositoryProvider).requestCall();
    result.fold(
      (error) => state = CallFailed(error),
      (_) => state = const CallRequested(),
    );
  }

  void reset() => state = const CallIdle();
}

final callProvider = NotifierProvider<CallNotifier, CallState>(
  CallNotifier.new,
);
