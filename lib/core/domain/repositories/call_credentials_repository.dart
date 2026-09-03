import 'package:fpdart/fpdart.dart';
import 'package:tvapp/core/domain/entities/call/call_credentials.dart';
import 'package:tvapp/core/domain/repositories/call_repository.dart' show CallRepository;
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

/// De dónde salen los datos de la central.
///
/// Existe separado del [CallRepository] a propósito: el "cómo se llama" (SIP)
/// y el "contra qué central" son decisiones distintas y cambian por separado.
///
/// Hoy hay una implementación que lee el `.env`. Cuando el backend exponga el
/// endpoint, se agrega una implementación HTTP y ese es el único cambio para
/// que el teléfono apunte al VICIdial del cliente: celular → backend → central.
abstract class CallCredentialsRepository {
  Future<Either<AppException, CallCredentials>> obtener();
}
