import 'package:fpdart/fpdart.dart';
import 'package:tvapp/core/domain/repositories/call_repository.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

/// Implementación provisional: **no llama a nadie**.
///
/// El módulo Mascotas se entrega con la pantalla y el botón funcionando, pero
/// sin servicio de telefonía detrás todavía. Informa que el servicio no está
/// disponible en vez de simular que la llamada salió (Regla 4 de
/// `docs/REGLAS.md`).
///
/// Cuando la central este levantada: crear la implementación real y cambiar
/// `callRepositoryProvider`. Esta clase queda como respaldo.
class CallNoopRepository implements CallRepository {
  @override
  Future<Either<AppException, void>> requestCall() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    return Left(AppException(
      identifier: 'Llamada',
      message: 'El servicio de asistencia telefónica todavía no está '
          'disponible. Intenta más tarde.',
      statusCode: 7001,
      detail: 'CallNoopRepository: no hay central de telefonía configurada.',
    ));
  }
}
