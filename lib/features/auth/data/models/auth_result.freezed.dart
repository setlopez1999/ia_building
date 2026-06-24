// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AuthResult _$AuthResultFromJson(Map<String, dynamic> json) {
  return _AuthResult.fromJson(json);
}

/// @nodoc
mixin _$AuthResult {
  String get token => throw _privateConstructorUsedError;
  String get clienteId => throw _privateConstructorUsedError;
  String get nombre => throw _privateConstructorUsedError;
  String get apellido => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;

  /// Serializes this AuthResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthResultCopyWith<AuthResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthResultCopyWith<$Res> {
  factory $AuthResultCopyWith(
    AuthResult value,
    $Res Function(AuthResult) then,
  ) = _$AuthResultCopyWithImpl<$Res, AuthResult>;
  @useResult
  $Res call({
    String token,
    String clienteId,
    String nombre,
    String apellido,
    String email,
    String role,
  });
}

/// @nodoc
class _$AuthResultCopyWithImpl<$Res, $Val extends AuthResult>
    implements $AuthResultCopyWith<$Res> {
  _$AuthResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? clienteId = null,
    Object? nombre = null,
    Object? apellido = null,
    Object? email = null,
    Object? role = null,
  }) {
    return _then(
      _value.copyWith(
            token: null == token
                ? _value.token
                : token // ignore: cast_nullable_to_non_nullable
                      as String,
            clienteId: null == clienteId
                ? _value.clienteId
                : clienteId // ignore: cast_nullable_to_non_nullable
                      as String,
            nombre: null == nombre
                ? _value.nombre
                : nombre // ignore: cast_nullable_to_non_nullable
                      as String,
            apellido: null == apellido
                ? _value.apellido
                : apellido // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AuthResultImplCopyWith<$Res>
    implements $AuthResultCopyWith<$Res> {
  factory _$$AuthResultImplCopyWith(
    _$AuthResultImpl value,
    $Res Function(_$AuthResultImpl) then,
  ) = __$$AuthResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String token,
    String clienteId,
    String nombre,
    String apellido,
    String email,
    String role,
  });
}

/// @nodoc
class __$$AuthResultImplCopyWithImpl<$Res>
    extends _$AuthResultCopyWithImpl<$Res, _$AuthResultImpl>
    implements _$$AuthResultImplCopyWith<$Res> {
  __$$AuthResultImplCopyWithImpl(
    _$AuthResultImpl _value,
    $Res Function(_$AuthResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? clienteId = null,
    Object? nombre = null,
    Object? apellido = null,
    Object? email = null,
    Object? role = null,
  }) {
    return _then(
      _$AuthResultImpl(
        token: null == token
            ? _value.token
            : token // ignore: cast_nullable_to_non_nullable
                  as String,
        clienteId: null == clienteId
            ? _value.clienteId
            : clienteId // ignore: cast_nullable_to_non_nullable
                  as String,
        nombre: null == nombre
            ? _value.nombre
            : nombre // ignore: cast_nullable_to_non_nullable
                  as String,
        apellido: null == apellido
            ? _value.apellido
            : apellido // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthResultImpl implements _AuthResult {
  const _$AuthResultImpl({
    required this.token,
    required this.clienteId,
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.role,
  });

  factory _$AuthResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthResultImplFromJson(json);

  @override
  final String token;
  @override
  final String clienteId;
  @override
  final String nombre;
  @override
  final String apellido;
  @override
  final String email;
  @override
  final String role;

  @override
  String toString() {
    return 'AuthResult(token: $token, clienteId: $clienteId, nombre: $nombre, apellido: $apellido, email: $email, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthResultImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.clienteId, clienteId) ||
                other.clienteId == clienteId) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.apellido, apellido) ||
                other.apellido == apellido) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, token, clienteId, nombre, apellido, email, role);

  /// Create a copy of AuthResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthResultImplCopyWith<_$AuthResultImpl> get copyWith =>
      __$$AuthResultImplCopyWithImpl<_$AuthResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthResultImplToJson(this);
  }
}

abstract class _AuthResult implements AuthResult {
  const factory _AuthResult({
    required final String token,
    required final String clienteId,
    required final String nombre,
    required final String apellido,
    required final String email,
    required final String role,
  }) = _$AuthResultImpl;

  factory _AuthResult.fromJson(Map<String, dynamic> json) =
      _$AuthResultImpl.fromJson;

  @override
  String get token;
  @override
  String get clienteId;
  @override
  String get nombre;
  @override
  String get apellido;
  @override
  String get email;
  @override
  String get role;

  /// Create a copy of AuthResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthResultImplCopyWith<_$AuthResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
