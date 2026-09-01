import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';
part 'user_entity.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required int factor,
    required String icono,
    required String limit_movil,
    required String parentlockcode,
    required String timezone,
    required String token,
    @Default('') dynamic urlip,
    required String us_id,
    @Default(false) bool useurlip,
    required String usuario,
    required String devid,
    bool? enabledvod,
    String? vencimientoplan,
    String? plan,
    /// Flags de módulos del hub enviados por el backend dentro de `info`.
    /// Llega crudo; el parseo tipado lo hace [ModulosParser].
    Map<String, dynamic>? modulos,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
