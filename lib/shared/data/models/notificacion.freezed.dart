// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notificacion.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Notificacion _$NotificacionFromJson(Map<String, dynamic> json) {
  return _Notificacion.fromJson(json);
}

/// @nodoc
mixin _$Notificacion {
  String get id => throw _privateConstructorUsedError;
  String get titulo => throw _privateConstructorUsedError;
  String get mensaje => throw _privateConstructorUsedError;
  DateTime get fecha => throw _privateConstructorUsedError;
  bool get leido => throw _privateConstructorUsedError;

  /// Serializes this Notificacion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Notificacion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificacionCopyWith<Notificacion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificacionCopyWith<$Res> {
  factory $NotificacionCopyWith(
    Notificacion value,
    $Res Function(Notificacion) then,
  ) = _$NotificacionCopyWithImpl<$Res, Notificacion>;
  @useResult
  $Res call({
    String id,
    String titulo,
    String mensaje,
    DateTime fecha,
    bool leido,
  });
}

/// @nodoc
class _$NotificacionCopyWithImpl<$Res, $Val extends Notificacion>
    implements $NotificacionCopyWith<$Res> {
  _$NotificacionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Notificacion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? titulo = null,
    Object? mensaje = null,
    Object? fecha = null,
    Object? leido = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            titulo: null == titulo
                ? _value.titulo
                : titulo // ignore: cast_nullable_to_non_nullable
                      as String,
            mensaje: null == mensaje
                ? _value.mensaje
                : mensaje // ignore: cast_nullable_to_non_nullable
                      as String,
            fecha: null == fecha
                ? _value.fecha
                : fecha // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            leido: null == leido
                ? _value.leido
                : leido // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NotificacionImplCopyWith<$Res>
    implements $NotificacionCopyWith<$Res> {
  factory _$$NotificacionImplCopyWith(
    _$NotificacionImpl value,
    $Res Function(_$NotificacionImpl) then,
  ) = __$$NotificacionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String titulo,
    String mensaje,
    DateTime fecha,
    bool leido,
  });
}

/// @nodoc
class __$$NotificacionImplCopyWithImpl<$Res>
    extends _$NotificacionCopyWithImpl<$Res, _$NotificacionImpl>
    implements _$$NotificacionImplCopyWith<$Res> {
  __$$NotificacionImplCopyWithImpl(
    _$NotificacionImpl _value,
    $Res Function(_$NotificacionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Notificacion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? titulo = null,
    Object? mensaje = null,
    Object? fecha = null,
    Object? leido = null,
  }) {
    return _then(
      _$NotificacionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        titulo: null == titulo
            ? _value.titulo
            : titulo // ignore: cast_nullable_to_non_nullable
                  as String,
        mensaje: null == mensaje
            ? _value.mensaje
            : mensaje // ignore: cast_nullable_to_non_nullable
                  as String,
        fecha: null == fecha
            ? _value.fecha
            : fecha // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        leido: null == leido
            ? _value.leido
            : leido // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificacionImpl implements _Notificacion {
  const _$NotificacionImpl({
    required this.id,
    required this.titulo,
    required this.mensaje,
    required this.fecha,
    required this.leido,
  });

  factory _$NotificacionImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificacionImplFromJson(json);

  @override
  final String id;
  @override
  final String titulo;
  @override
  final String mensaje;
  @override
  final DateTime fecha;
  @override
  final bool leido;

  @override
  String toString() {
    return 'Notificacion(id: $id, titulo: $titulo, mensaje: $mensaje, fecha: $fecha, leido: $leido)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificacionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.titulo, titulo) || other.titulo == titulo) &&
            (identical(other.mensaje, mensaje) || other.mensaje == mensaje) &&
            (identical(other.fecha, fecha) || other.fecha == fecha) &&
            (identical(other.leido, leido) || other.leido == leido));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, titulo, mensaje, fecha, leido);

  /// Create a copy of Notificacion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificacionImplCopyWith<_$NotificacionImpl> get copyWith =>
      __$$NotificacionImplCopyWithImpl<_$NotificacionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificacionImplToJson(this);
  }
}

abstract class _Notificacion implements Notificacion {
  const factory _Notificacion({
    required final String id,
    required final String titulo,
    required final String mensaje,
    required final DateTime fecha,
    required final bool leido,
  }) = _$NotificacionImpl;

  factory _Notificacion.fromJson(Map<String, dynamic> json) =
      _$NotificacionImpl.fromJson;

  @override
  String get id;
  @override
  String get titulo;
  @override
  String get mensaje;
  @override
  DateTime get fecha;
  @override
  bool get leido;

  /// Create a copy of Notificacion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificacionImplCopyWith<_$NotificacionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
