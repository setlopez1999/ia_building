import 'package:flutter/material.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/core/application/states/content/content_state.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

/// Dibuja los tres estados de una llamada a API segun la Regla 1 de
/// `docs/REGLAS.md`: cargando, exito (con caso vacio) y error con reintento.
///
/// El detalle tecnico del error solo aparece con `APP_DEBUG_MODE=true`.
class ApiStateView<T> extends StatelessWidget {
  const ApiStateView({
    super.key,
    required this.state,
    required this.builder,
    this.onRetry,
    this.emptyMessage,
    this.isEmpty,
  });

  final ContentState<T> state;
  final Widget Function(T data) builder;
  final Future<void> Function()? onRetry;

  /// Mensaje cuando la llamada fue exitosa pero no trajo contenido.
  final String? emptyMessage;

  /// Como decidir si [T] esta vacio. Por defecto detecta listas vacias.
  final bool Function(T data)? isEmpty;

  bool _empty(T data) {
    if (isEmpty != null) return isEmpty!(data);
    if (data is Iterable) return data.isEmpty;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return state.when(
      initial: () => const _Loading(),
      loading: () => const _Loading(),
      error: (failure) => ApiErrorView(failure: failure, onRetry: onRetry),
      success: (data) {
        if (_empty(data)) {
          return _Message(
            icon: Icons.inbox_outlined,
            message: emptyMessage ?? 'No hay información para mostrar.',
            onRetry: onRetry,
          );
        }
        return builder(data);
      },
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

/// Error visible para el usuario. En debug agrega el detalle crudo debajo.
class ApiErrorView extends StatelessWidget {
  const ApiErrorView({super.key, required this.failure, this.onRetry, this.rawDetail});

  final AppException failure;
  final Future<void> Function()? onRetry;

  /// Detalle alternativo cuando no se dispone de un [AppException] completo.
  final String? rawDetail;

  @override
  Widget build(BuildContext context) {
    return _Message(
      icon: Icons.error_outline,
      message: failure.message,
      onRetry: onRetry,
      // Regla 1.b: el detalle tecnico jamas se muestra en release.
      debugDetail: Environment.appDebugMode
          ? (rawDetail ??
              failure.detail ??
              '[${failure.identifier}] código ${failure.statusCode}\n${failure.message}')
          : null,
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.icon,
    required this.message,
    this.onRetry,
    this.debugDetail,
  });

  final IconData icon;
  final String message;
  final Future<void> Function()? onRetry;
  final String? debugDetail;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.white38),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 15),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
            if (debugDetail != null) ...[
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orangeAccent.withValues(alpha: 0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'DEBUG — detalle de la respuesta',
                      style: TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    SelectableText(
                      debugDetail!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
