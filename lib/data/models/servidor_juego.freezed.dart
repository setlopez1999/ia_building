// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'servidor_juego.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ServidorJuego _$ServidorJuegoFromJson(Map<String, dynamic> json) {
  return _ServidorJuego.fromJson(json);
}

/// @nodoc
mixin _$ServidorJuego {
  String get id => throw _privateConstructorUsedError;
  String get juego => throw _privateConstructorUsedError;
  String get servidor => throw _privateConstructorUsedError;
  String get ubicacion => throw _privateConstructorUsedError;
  int get pingMs => throw _privateConstructorUsedError;
  int get jitterMs => throw _privateConstructorUsedError;
  double get perdidaPaquetesPct => throw _privateConstructorUsedError;
  String get estado => throw _privateConstructorUsedError;

  /// Serializes this ServidorJuego to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ServidorJuego
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServidorJuegoCopyWith<ServidorJuego> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServidorJuegoCopyWith<$Res> {
  factory $ServidorJuegoCopyWith(
    ServidorJuego value,
    $Res Function(ServidorJuego) then,
  ) = _$ServidorJuegoCopyWithImpl<$Res, ServidorJuego>;
  @useResult
  $Res call({
    String id,
    String juego,
    String servidor,
    String ubicacion,
    int pingMs,
    int jitterMs,
    double perdidaPaquetesPct,
    String estado,
  });
}

/// @nodoc
class _$ServidorJuegoCopyWithImpl<$Res, $Val extends ServidorJuego>
    implements $ServidorJuegoCopyWith<$Res> {
  _$ServidorJuegoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServidorJuego
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? juego = null,
    Object? servidor = null,
    Object? ubicacion = null,
    Object? pingMs = null,
    Object? jitterMs = null,
    Object? perdidaPaquetesPct = null,
    Object? estado = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            juego: null == juego
                ? _value.juego
                : juego // ignore: cast_nullable_to_non_nullable
                      as String,
            servidor: null == servidor
                ? _value.servidor
                : servidor // ignore: cast_nullable_to_non_nullable
                      as String,
            ubicacion: null == ubicacion
                ? _value.ubicacion
                : ubicacion // ignore: cast_nullable_to_non_nullable
                      as String,
            pingMs: null == pingMs
                ? _value.pingMs
                : pingMs // ignore: cast_nullable_to_non_nullable
                      as int,
            jitterMs: null == jitterMs
                ? _value.jitterMs
                : jitterMs // ignore: cast_nullable_to_non_nullable
                      as int,
            perdidaPaquetesPct: null == perdidaPaquetesPct
                ? _value.perdidaPaquetesPct
                : perdidaPaquetesPct // ignore: cast_nullable_to_non_nullable
                      as double,
            estado: null == estado
                ? _value.estado
                : estado // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ServidorJuegoImplCopyWith<$Res>
    implements $ServidorJuegoCopyWith<$Res> {
  factory _$$ServidorJuegoImplCopyWith(
    _$ServidorJuegoImpl value,
    $Res Function(_$ServidorJuegoImpl) then,
  ) = __$$ServidorJuegoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String juego,
    String servidor,
    String ubicacion,
    int pingMs,
    int jitterMs,
    double perdidaPaquetesPct,
    String estado,
  });
}

/// @nodoc
class __$$ServidorJuegoImplCopyWithImpl<$Res>
    extends _$ServidorJuegoCopyWithImpl<$Res, _$ServidorJuegoImpl>
    implements _$$ServidorJuegoImplCopyWith<$Res> {
  __$$ServidorJuegoImplCopyWithImpl(
    _$ServidorJuegoImpl _value,
    $Res Function(_$ServidorJuegoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ServidorJuego
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? juego = null,
    Object? servidor = null,
    Object? ubicacion = null,
    Object? pingMs = null,
    Object? jitterMs = null,
    Object? perdidaPaquetesPct = null,
    Object? estado = null,
  }) {
    return _then(
      _$ServidorJuegoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        juego: null == juego
            ? _value.juego
            : juego // ignore: cast_nullable_to_non_nullable
                  as String,
        servidor: null == servidor
            ? _value.servidor
            : servidor // ignore: cast_nullable_to_non_nullable
                  as String,
        ubicacion: null == ubicacion
            ? _value.ubicacion
            : ubicacion // ignore: cast_nullable_to_non_nullable
                  as String,
        pingMs: null == pingMs
            ? _value.pingMs
            : pingMs // ignore: cast_nullable_to_non_nullable
                  as int,
        jitterMs: null == jitterMs
            ? _value.jitterMs
            : jitterMs // ignore: cast_nullable_to_non_nullable
                  as int,
        perdidaPaquetesPct: null == perdidaPaquetesPct
            ? _value.perdidaPaquetesPct
            : perdidaPaquetesPct // ignore: cast_nullable_to_non_nullable
                  as double,
        estado: null == estado
            ? _value.estado
            : estado // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ServidorJuegoImpl implements _ServidorJuego {
  const _$ServidorJuegoImpl({
    required this.id,
    required this.juego,
    required this.servidor,
    required this.ubicacion,
    required this.pingMs,
    required this.jitterMs,
    required this.perdidaPaquetesPct,
    required this.estado,
  });

  factory _$ServidorJuegoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServidorJuegoImplFromJson(json);

  @override
  final String id;
  @override
  final String juego;
  @override
  final String servidor;
  @override
  final String ubicacion;
  @override
  final int pingMs;
  @override
  final int jitterMs;
  @override
  final double perdidaPaquetesPct;
  @override
  final String estado;

  @override
  String toString() {
    return 'ServidorJuego(id: $id, juego: $juego, servidor: $servidor, ubicacion: $ubicacion, pingMs: $pingMs, jitterMs: $jitterMs, perdidaPaquetesPct: $perdidaPaquetesPct, estado: $estado)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServidorJuegoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.juego, juego) || other.juego == juego) &&
            (identical(other.servidor, servidor) ||
                other.servidor == servidor) &&
            (identical(other.ubicacion, ubicacion) ||
                other.ubicacion == ubicacion) &&
            (identical(other.pingMs, pingMs) || other.pingMs == pingMs) &&
            (identical(other.jitterMs, jitterMs) ||
                other.jitterMs == jitterMs) &&
            (identical(other.perdidaPaquetesPct, perdidaPaquetesPct) ||
                other.perdidaPaquetesPct == perdidaPaquetesPct) &&
            (identical(other.estado, estado) || other.estado == estado));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    juego,
    servidor,
    ubicacion,
    pingMs,
    jitterMs,
    perdidaPaquetesPct,
    estado,
  );

  /// Create a copy of ServidorJuego
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServidorJuegoImplCopyWith<_$ServidorJuegoImpl> get copyWith =>
      __$$ServidorJuegoImplCopyWithImpl<_$ServidorJuegoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServidorJuegoImplToJson(this);
  }
}

abstract class _ServidorJuego implements ServidorJuego {
  const factory _ServidorJuego({
    required final String id,
    required final String juego,
    required final String servidor,
    required final String ubicacion,
    required final int pingMs,
    required final int jitterMs,
    required final double perdidaPaquetesPct,
    required final String estado,
  }) = _$ServidorJuegoImpl;

  factory _ServidorJuego.fromJson(Map<String, dynamic> json) =
      _$ServidorJuegoImpl.fromJson;

  @override
  String get id;
  @override
  String get juego;
  @override
  String get servidor;
  @override
  String get ubicacion;
  @override
  int get pingMs;
  @override
  int get jitterMs;
  @override
  double get perdidaPaquetesPct;
  @override
  String get estado;

  /// Create a copy of ServidorJuego
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServidorJuegoImplCopyWith<_$ServidorJuegoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
