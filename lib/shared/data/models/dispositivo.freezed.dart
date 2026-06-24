// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dispositivo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Dispositivo _$DispositivoFromJson(Map<String, dynamic> json) {
  return _Dispositivo.fromJson(json);
}

/// @nodoc
mixin _$Dispositivo {
  String get id => throw _privateConstructorUsedError;
  String get nombre => throw _privateConstructorUsedError;
  String get mac => throw _privateConstructorUsedError;
  String get ipLocal => throw _privateConstructorUsedError;
  String get tipo => throw _privateConstructorUsedError;
  bool get conectado => throw _privateConstructorUsedError;

  /// Serializes this Dispositivo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Dispositivo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DispositivoCopyWith<Dispositivo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DispositivoCopyWith<$Res> {
  factory $DispositivoCopyWith(
    Dispositivo value,
    $Res Function(Dispositivo) then,
  ) = _$DispositivoCopyWithImpl<$Res, Dispositivo>;
  @useResult
  $Res call({
    String id,
    String nombre,
    String mac,
    String ipLocal,
    String tipo,
    bool conectado,
  });
}

/// @nodoc
class _$DispositivoCopyWithImpl<$Res, $Val extends Dispositivo>
    implements $DispositivoCopyWith<$Res> {
  _$DispositivoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Dispositivo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
    Object? mac = null,
    Object? ipLocal = null,
    Object? tipo = null,
    Object? conectado = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            nombre: null == nombre
                ? _value.nombre
                : nombre // ignore: cast_nullable_to_non_nullable
                      as String,
            mac: null == mac
                ? _value.mac
                : mac // ignore: cast_nullable_to_non_nullable
                      as String,
            ipLocal: null == ipLocal
                ? _value.ipLocal
                : ipLocal // ignore: cast_nullable_to_non_nullable
                      as String,
            tipo: null == tipo
                ? _value.tipo
                : tipo // ignore: cast_nullable_to_non_nullable
                      as String,
            conectado: null == conectado
                ? _value.conectado
                : conectado // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DispositivoImplCopyWith<$Res>
    implements $DispositivoCopyWith<$Res> {
  factory _$$DispositivoImplCopyWith(
    _$DispositivoImpl value,
    $Res Function(_$DispositivoImpl) then,
  ) = __$$DispositivoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String nombre,
    String mac,
    String ipLocal,
    String tipo,
    bool conectado,
  });
}

/// @nodoc
class __$$DispositivoImplCopyWithImpl<$Res>
    extends _$DispositivoCopyWithImpl<$Res, _$DispositivoImpl>
    implements _$$DispositivoImplCopyWith<$Res> {
  __$$DispositivoImplCopyWithImpl(
    _$DispositivoImpl _value,
    $Res Function(_$DispositivoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Dispositivo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
    Object? mac = null,
    Object? ipLocal = null,
    Object? tipo = null,
    Object? conectado = null,
  }) {
    return _then(
      _$DispositivoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        nombre: null == nombre
            ? _value.nombre
            : nombre // ignore: cast_nullable_to_non_nullable
                  as String,
        mac: null == mac
            ? _value.mac
            : mac // ignore: cast_nullable_to_non_nullable
                  as String,
        ipLocal: null == ipLocal
            ? _value.ipLocal
            : ipLocal // ignore: cast_nullable_to_non_nullable
                  as String,
        tipo: null == tipo
            ? _value.tipo
            : tipo // ignore: cast_nullable_to_non_nullable
                  as String,
        conectado: null == conectado
            ? _value.conectado
            : conectado // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DispositivoImpl implements _Dispositivo {
  const _$DispositivoImpl({
    required this.id,
    required this.nombre,
    required this.mac,
    required this.ipLocal,
    required this.tipo,
    required this.conectado,
  });

  factory _$DispositivoImpl.fromJson(Map<String, dynamic> json) =>
      _$$DispositivoImplFromJson(json);

  @override
  final String id;
  @override
  final String nombre;
  @override
  final String mac;
  @override
  final String ipLocal;
  @override
  final String tipo;
  @override
  final bool conectado;

  @override
  String toString() {
    return 'Dispositivo(id: $id, nombre: $nombre, mac: $mac, ipLocal: $ipLocal, tipo: $tipo, conectado: $conectado)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DispositivoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.mac, mac) || other.mac == mac) &&
            (identical(other.ipLocal, ipLocal) || other.ipLocal == ipLocal) &&
            (identical(other.tipo, tipo) || other.tipo == tipo) &&
            (identical(other.conectado, conectado) ||
                other.conectado == conectado));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, nombre, mac, ipLocal, tipo, conectado);

  /// Create a copy of Dispositivo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DispositivoImplCopyWith<_$DispositivoImpl> get copyWith =>
      __$$DispositivoImplCopyWithImpl<_$DispositivoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DispositivoImplToJson(this);
  }
}

abstract class _Dispositivo implements Dispositivo {
  const factory _Dispositivo({
    required final String id,
    required final String nombre,
    required final String mac,
    required final String ipLocal,
    required final String tipo,
    required final bool conectado,
  }) = _$DispositivoImpl;

  factory _Dispositivo.fromJson(Map<String, dynamic> json) =
      _$DispositivoImpl.fromJson;

  @override
  String get id;
  @override
  String get nombre;
  @override
  String get mac;
  @override
  String get ipLocal;
  @override
  String get tipo;
  @override
  bool get conectado;

  /// Create a copy of Dispositivo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DispositivoImplCopyWith<_$DispositivoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
