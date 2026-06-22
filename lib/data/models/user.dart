import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// Modelo de dominio: datos del usuario / cliente.
/// Fuente: GET /v1/user/profile  (PERFIL-1)
@freezed
class User with _$User {
  const factory User({
    required String clienteId,
    required String nombre,
    required String planContratado,
    required String email,
    required String telefono,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
