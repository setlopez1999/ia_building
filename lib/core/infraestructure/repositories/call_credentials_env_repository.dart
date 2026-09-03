import 'package:fpdart/fpdart.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/core/domain/entities/call/call_credentials.dart';
import 'package:tvapp/core/domain/repositories/call_credentials_repository.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

/// Credenciales de la central leídas del `.env`.
///
/// Es lo que corresponde mientras la central es el Asterisk de pruebas y todos
/// los teléfonos comparten la misma extensión. No sirve para producción: ahí
/// cada usuario necesita la suya, y eso lo tiene que decidir el backend.
class CallCredentialsEnvRepository implements CallCredentialsRepository {
  const CallCredentialsEnvRepository();

  @override
  Future<Either<AppException, CallCredentials>> obtener() async {
    final credenciales = CallCredentials(
      wsUrl: Environment.sipWsUrl,
      host: Environment.sipHost,
      usuario: Environment.sipUser,
      clave: Environment.sipPassword,
      destino: Environment.sipDestino,
      displayName: 'Mascotas',
    );

    if (!credenciales.esValida) {
      return Left(
        AppException(
          identifier: 'call-config',
          statusCode: 0,
          message: 'La telefonía no está configurada.',
          detail:
              'Faltan datos en el .env: revisá SIP_WS_URL, SIP_HOST, '
              'SIP_USER y SIP_DESTINO.',
        ),
      );
    }

    return Right(credenciales);
  }
}
