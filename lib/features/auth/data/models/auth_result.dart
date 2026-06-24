import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_result.freezed.dart';
part 'auth_result.g.dart';

/// Resultado de autenticación.
/// Fuente: POST /v1/auth/login  (AUTH-1)
@freezed
class AuthResult with _$AuthResult {
  const factory AuthResult({
    required String token,
    required String clienteId,
    required String nombre,
    required String apellido,
    required String email,
    required String role,
  }) = _AuthResult;

  factory AuthResult.fromJson(Map<String, dynamic> json) =>
      _$AuthResultFromJson(json);
}
