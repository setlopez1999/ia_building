import 'package:tvapp/core/domain/entities/modulos/modulos_entity.dart';

/// Contrato para extraer los flags de módulos del payload crudo `info`
/// que responde el backend en `/api/inicio`.
///
/// Cuando la jefa/backend confirme el formato real de los flags,
/// se implementa una nueva versión de esta interfaz (o se ajusta
/// [ModulosParserV1]) y NO se toca nada más del código.
abstract interface class ModulosParser {
  /// Devuelve null si el backend no envió el objeto de módulos.
  ModulosEntity? parse(Map<String, dynamic> info);
}
