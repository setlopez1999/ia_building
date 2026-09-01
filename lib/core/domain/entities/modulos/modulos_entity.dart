import 'package:freezed_annotation/freezed_annotation.dart';

part 'modulos_entity.freezed.dart';
part 'modulos_entity.g.dart';

/// Flags de módulos del hub que el backend debe enviar dentro de `info`
/// en la respuesta de `/api/inicio` (y de `/{token}/inicio.json`).
///
/// Cada campo es nullable: `null` significa "el backend no envió ese flag".
/// En release, un módulo solo se muestra si su flag es exactamente `true`.
@freezed
abstract class ModulosEntity with _$ModulosEntity {
  const factory ModulosEntity({
    bool? eventos,
    bool? iptv,
    bool? vod,
    bool? camaras,
    @JsonKey(name: 'club_descuentos') bool? clubDescuentos,
    @JsonKey(name: 'check_health') bool? checkHealth,
  }) = _ModulosEntity;

  factory ModulosEntity.fromJson(Map<String, dynamic> json) =>
      _$ModulosEntityFromJson(json);
}
