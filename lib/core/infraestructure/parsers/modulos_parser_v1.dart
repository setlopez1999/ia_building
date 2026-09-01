import 'package:tvapp/core/domain/entities/modulos/modulos_entity.dart';
import 'package:tvapp/core/domain/interfaces/modulos/modulos_parser.dart';

/// Implementación V1 del parseo de módulos.
///
/// Formato esperado (contrato propuesto, pendiente de confirmar con backend):
/// ```json
/// "info": {
///   "...": "...",
///   "modulos": {
///     "eventos": true,
///     "iptv": true,
///     "vod": false,
///     "camaras": true,
///     "club_descuentos": false,
///     "check_health": true
///   }
/// }
/// ```
///
/// Si el formato real cambia: modificar SOLO esta clase (o crear
/// ModulosParserV2) — el resto del código consume [ModulosParser].
class ModulosParserV1 implements ModulosParser {
  const ModulosParserV1();

  static const _key = 'modulos';

  @override
  ModulosEntity? parse(Map<String, dynamic> info) {
    final raw = info[_key];
    if (raw is! Map<String, dynamic>) return null;
    return ModulosEntity.fromJson(raw);
  }
}
