// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diagnostico.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Diagnostico _$DiagnosticoFromJson(Map<String, dynamic> json) {
  return _Diagnostico.fromJson(json);
}

/// @nodoc
mixin _$Diagnostico {
  String get id => throw _privateConstructorUsedError;
  DateTime get fecha => throw _privateConstructorUsedError;
  int get latenciaIspMs => throw _privateConstructorUsedError;
  double get velocidadBajadaMbps => throw _privateConstructorUsedError;
  String get resultado => throw _privateConstructorUsedError;

  /// Serializes this Diagnostico to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Diagnostico
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DiagnosticoCopyWith<Diagnostico> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiagnosticoCopyWith<$Res> {
  factory $DiagnosticoCopyWith(
    Diagnostico value,
    $Res Function(Diagnostico) then,
  ) = _$DiagnosticoCopyWithImpl<$Res, Diagnostico>;
  @useResult
  $Res call({
    String id,
    DateTime fecha,
    int latenciaIspMs,
    double velocidadBajadaMbps,
    String resultado,
  });
}

/// @nodoc
class _$DiagnosticoCopyWithImpl<$Res, $Val extends Diagnostico>
    implements $DiagnosticoCopyWith<$Res> {
  _$DiagnosticoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Diagnostico
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fecha = null,
    Object? latenciaIspMs = null,
    Object? velocidadBajadaMbps = null,
    Object? resultado = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            fecha: null == fecha
                ? _value.fecha
                : fecha // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            latenciaIspMs: null == latenciaIspMs
                ? _value.latenciaIspMs
                : latenciaIspMs // ignore: cast_nullable_to_non_nullable
                      as int,
            velocidadBajadaMbps: null == velocidadBajadaMbps
                ? _value.velocidadBajadaMbps
                : velocidadBajadaMbps // ignore: cast_nullable_to_non_nullable
                      as double,
            resultado: null == resultado
                ? _value.resultado
                : resultado // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DiagnosticoImplCopyWith<$Res>
    implements $DiagnosticoCopyWith<$Res> {
  factory _$$DiagnosticoImplCopyWith(
    _$DiagnosticoImpl value,
    $Res Function(_$DiagnosticoImpl) then,
  ) = __$$DiagnosticoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    DateTime fecha,
    int latenciaIspMs,
    double velocidadBajadaMbps,
    String resultado,
  });
}

/// @nodoc
class __$$DiagnosticoImplCopyWithImpl<$Res>
    extends _$DiagnosticoCopyWithImpl<$Res, _$DiagnosticoImpl>
    implements _$$DiagnosticoImplCopyWith<$Res> {
  __$$DiagnosticoImplCopyWithImpl(
    _$DiagnosticoImpl _value,
    $Res Function(_$DiagnosticoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Diagnostico
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fecha = null,
    Object? latenciaIspMs = null,
    Object? velocidadBajadaMbps = null,
    Object? resultado = null,
  }) {
    return _then(
      _$DiagnosticoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        fecha: null == fecha
            ? _value.fecha
            : fecha // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        latenciaIspMs: null == latenciaIspMs
            ? _value.latenciaIspMs
            : latenciaIspMs // ignore: cast_nullable_to_non_nullable
                  as int,
        velocidadBajadaMbps: null == velocidadBajadaMbps
            ? _value.velocidadBajadaMbps
            : velocidadBajadaMbps // ignore: cast_nullable_to_non_nullable
                  as double,
        resultado: null == resultado
            ? _value.resultado
            : resultado // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DiagnosticoImpl implements _Diagnostico {
  const _$DiagnosticoImpl({
    required this.id,
    required this.fecha,
    required this.latenciaIspMs,
    required this.velocidadBajadaMbps,
    required this.resultado,
  });

  factory _$DiagnosticoImpl.fromJson(Map<String, dynamic> json) =>
      _$$DiagnosticoImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime fecha;
  @override
  final int latenciaIspMs;
  @override
  final double velocidadBajadaMbps;
  @override
  final String resultado;

  @override
  String toString() {
    return 'Diagnostico(id: $id, fecha: $fecha, latenciaIspMs: $latenciaIspMs, velocidadBajadaMbps: $velocidadBajadaMbps, resultado: $resultado)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiagnosticoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fecha, fecha) || other.fecha == fecha) &&
            (identical(other.latenciaIspMs, latenciaIspMs) ||
                other.latenciaIspMs == latenciaIspMs) &&
            (identical(other.velocidadBajadaMbps, velocidadBajadaMbps) ||
                other.velocidadBajadaMbps == velocidadBajadaMbps) &&
            (identical(other.resultado, resultado) ||
                other.resultado == resultado));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    fecha,
    latenciaIspMs,
    velocidadBajadaMbps,
    resultado,
  );

  /// Create a copy of Diagnostico
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiagnosticoImplCopyWith<_$DiagnosticoImpl> get copyWith =>
      __$$DiagnosticoImplCopyWithImpl<_$DiagnosticoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DiagnosticoImplToJson(this);
  }
}

abstract class _Diagnostico implements Diagnostico {
  const factory _Diagnostico({
    required final String id,
    required final DateTime fecha,
    required final int latenciaIspMs,
    required final double velocidadBajadaMbps,
    required final String resultado,
  }) = _$DiagnosticoImpl;

  factory _Diagnostico.fromJson(Map<String, dynamic> json) =
      _$DiagnosticoImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get fecha;
  @override
  int get latenciaIspMs;
  @override
  double get velocidadBajadaMbps;
  @override
  String get resultado;

  /// Create a copy of Diagnostico
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiagnosticoImplCopyWith<_$DiagnosticoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DiagnosticoRequest _$DiagnosticoRequestFromJson(Map<String, dynamic> json) {
  return _DiagnosticoRequest.fromJson(json);
}

/// @nodoc
mixin _$DiagnosticoRequest {
  String get clienteId => throw _privateConstructorUsedError;
  int get latenciaGoogleMs => throw _privateConstructorUsedError;
  int get latenciaIspMs => throw _privateConstructorUsedError;
  double get velocidadBajadaMbps => throw _privateConstructorUsedError;
  double get velocidadSubidaMbps => throw _privateConstructorUsedError;
  String get fibraPotenciaDbm => throw _privateConstructorUsedError;
  String get fibraEstado => throw _privateConstructorUsedError;

  /// Serializes this DiagnosticoRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DiagnosticoRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DiagnosticoRequestCopyWith<DiagnosticoRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiagnosticoRequestCopyWith<$Res> {
  factory $DiagnosticoRequestCopyWith(
    DiagnosticoRequest value,
    $Res Function(DiagnosticoRequest) then,
  ) = _$DiagnosticoRequestCopyWithImpl<$Res, DiagnosticoRequest>;
  @useResult
  $Res call({
    String clienteId,
    int latenciaGoogleMs,
    int latenciaIspMs,
    double velocidadBajadaMbps,
    double velocidadSubidaMbps,
    String fibraPotenciaDbm,
    String fibraEstado,
  });
}

/// @nodoc
class _$DiagnosticoRequestCopyWithImpl<$Res, $Val extends DiagnosticoRequest>
    implements $DiagnosticoRequestCopyWith<$Res> {
  _$DiagnosticoRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DiagnosticoRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clienteId = null,
    Object? latenciaGoogleMs = null,
    Object? latenciaIspMs = null,
    Object? velocidadBajadaMbps = null,
    Object? velocidadSubidaMbps = null,
    Object? fibraPotenciaDbm = null,
    Object? fibraEstado = null,
  }) {
    return _then(
      _value.copyWith(
            clienteId: null == clienteId
                ? _value.clienteId
                : clienteId // ignore: cast_nullable_to_non_nullable
                      as String,
            latenciaGoogleMs: null == latenciaGoogleMs
                ? _value.latenciaGoogleMs
                : latenciaGoogleMs // ignore: cast_nullable_to_non_nullable
                      as int,
            latenciaIspMs: null == latenciaIspMs
                ? _value.latenciaIspMs
                : latenciaIspMs // ignore: cast_nullable_to_non_nullable
                      as int,
            velocidadBajadaMbps: null == velocidadBajadaMbps
                ? _value.velocidadBajadaMbps
                : velocidadBajadaMbps // ignore: cast_nullable_to_non_nullable
                      as double,
            velocidadSubidaMbps: null == velocidadSubidaMbps
                ? _value.velocidadSubidaMbps
                : velocidadSubidaMbps // ignore: cast_nullable_to_non_nullable
                      as double,
            fibraPotenciaDbm: null == fibraPotenciaDbm
                ? _value.fibraPotenciaDbm
                : fibraPotenciaDbm // ignore: cast_nullable_to_non_nullable
                      as String,
            fibraEstado: null == fibraEstado
                ? _value.fibraEstado
                : fibraEstado // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DiagnosticoRequestImplCopyWith<$Res>
    implements $DiagnosticoRequestCopyWith<$Res> {
  factory _$$DiagnosticoRequestImplCopyWith(
    _$DiagnosticoRequestImpl value,
    $Res Function(_$DiagnosticoRequestImpl) then,
  ) = __$$DiagnosticoRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String clienteId,
    int latenciaGoogleMs,
    int latenciaIspMs,
    double velocidadBajadaMbps,
    double velocidadSubidaMbps,
    String fibraPotenciaDbm,
    String fibraEstado,
  });
}

/// @nodoc
class __$$DiagnosticoRequestImplCopyWithImpl<$Res>
    extends _$DiagnosticoRequestCopyWithImpl<$Res, _$DiagnosticoRequestImpl>
    implements _$$DiagnosticoRequestImplCopyWith<$Res> {
  __$$DiagnosticoRequestImplCopyWithImpl(
    _$DiagnosticoRequestImpl _value,
    $Res Function(_$DiagnosticoRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DiagnosticoRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clienteId = null,
    Object? latenciaGoogleMs = null,
    Object? latenciaIspMs = null,
    Object? velocidadBajadaMbps = null,
    Object? velocidadSubidaMbps = null,
    Object? fibraPotenciaDbm = null,
    Object? fibraEstado = null,
  }) {
    return _then(
      _$DiagnosticoRequestImpl(
        clienteId: null == clienteId
            ? _value.clienteId
            : clienteId // ignore: cast_nullable_to_non_nullable
                  as String,
        latenciaGoogleMs: null == latenciaGoogleMs
            ? _value.latenciaGoogleMs
            : latenciaGoogleMs // ignore: cast_nullable_to_non_nullable
                  as int,
        latenciaIspMs: null == latenciaIspMs
            ? _value.latenciaIspMs
            : latenciaIspMs // ignore: cast_nullable_to_non_nullable
                  as int,
        velocidadBajadaMbps: null == velocidadBajadaMbps
            ? _value.velocidadBajadaMbps
            : velocidadBajadaMbps // ignore: cast_nullable_to_non_nullable
                  as double,
        velocidadSubidaMbps: null == velocidadSubidaMbps
            ? _value.velocidadSubidaMbps
            : velocidadSubidaMbps // ignore: cast_nullable_to_non_nullable
                  as double,
        fibraPotenciaDbm: null == fibraPotenciaDbm
            ? _value.fibraPotenciaDbm
            : fibraPotenciaDbm // ignore: cast_nullable_to_non_nullable
                  as String,
        fibraEstado: null == fibraEstado
            ? _value.fibraEstado
            : fibraEstado // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DiagnosticoRequestImpl implements _DiagnosticoRequest {
  const _$DiagnosticoRequestImpl({
    required this.clienteId,
    required this.latenciaGoogleMs,
    required this.latenciaIspMs,
    required this.velocidadBajadaMbps,
    required this.velocidadSubidaMbps,
    required this.fibraPotenciaDbm,
    required this.fibraEstado,
  });

  factory _$DiagnosticoRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$DiagnosticoRequestImplFromJson(json);

  @override
  final String clienteId;
  @override
  final int latenciaGoogleMs;
  @override
  final int latenciaIspMs;
  @override
  final double velocidadBajadaMbps;
  @override
  final double velocidadSubidaMbps;
  @override
  final String fibraPotenciaDbm;
  @override
  final String fibraEstado;

  @override
  String toString() {
    return 'DiagnosticoRequest(clienteId: $clienteId, latenciaGoogleMs: $latenciaGoogleMs, latenciaIspMs: $latenciaIspMs, velocidadBajadaMbps: $velocidadBajadaMbps, velocidadSubidaMbps: $velocidadSubidaMbps, fibraPotenciaDbm: $fibraPotenciaDbm, fibraEstado: $fibraEstado)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiagnosticoRequestImpl &&
            (identical(other.clienteId, clienteId) ||
                other.clienteId == clienteId) &&
            (identical(other.latenciaGoogleMs, latenciaGoogleMs) ||
                other.latenciaGoogleMs == latenciaGoogleMs) &&
            (identical(other.latenciaIspMs, latenciaIspMs) ||
                other.latenciaIspMs == latenciaIspMs) &&
            (identical(other.velocidadBajadaMbps, velocidadBajadaMbps) ||
                other.velocidadBajadaMbps == velocidadBajadaMbps) &&
            (identical(other.velocidadSubidaMbps, velocidadSubidaMbps) ||
                other.velocidadSubidaMbps == velocidadSubidaMbps) &&
            (identical(other.fibraPotenciaDbm, fibraPotenciaDbm) ||
                other.fibraPotenciaDbm == fibraPotenciaDbm) &&
            (identical(other.fibraEstado, fibraEstado) ||
                other.fibraEstado == fibraEstado));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    clienteId,
    latenciaGoogleMs,
    latenciaIspMs,
    velocidadBajadaMbps,
    velocidadSubidaMbps,
    fibraPotenciaDbm,
    fibraEstado,
  );

  /// Create a copy of DiagnosticoRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiagnosticoRequestImplCopyWith<_$DiagnosticoRequestImpl> get copyWith =>
      __$$DiagnosticoRequestImplCopyWithImpl<_$DiagnosticoRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DiagnosticoRequestImplToJson(this);
  }
}

abstract class _DiagnosticoRequest implements DiagnosticoRequest {
  const factory _DiagnosticoRequest({
    required final String clienteId,
    required final int latenciaGoogleMs,
    required final int latenciaIspMs,
    required final double velocidadBajadaMbps,
    required final double velocidadSubidaMbps,
    required final String fibraPotenciaDbm,
    required final String fibraEstado,
  }) = _$DiagnosticoRequestImpl;

  factory _DiagnosticoRequest.fromJson(Map<String, dynamic> json) =
      _$DiagnosticoRequestImpl.fromJson;

  @override
  String get clienteId;
  @override
  int get latenciaGoogleMs;
  @override
  int get latenciaIspMs;
  @override
  double get velocidadBajadaMbps;
  @override
  double get velocidadSubidaMbps;
  @override
  String get fibraPotenciaDbm;
  @override
  String get fibraEstado;

  /// Create a copy of DiagnosticoRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiagnosticoRequestImplCopyWith<_$DiagnosticoRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DiagnosticoSaveResult _$DiagnosticoSaveResultFromJson(
  Map<String, dynamic> json,
) {
  return _DiagnosticoSaveResult.fromJson(json);
}

/// @nodoc
mixin _$DiagnosticoSaveResult {
  bool get success => throw _privateConstructorUsedError;
  String get diagnosticoId => throw _privateConstructorUsedError;
  String get resultado => throw _privateConstructorUsedError;

  /// Serializes this DiagnosticoSaveResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DiagnosticoSaveResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DiagnosticoSaveResultCopyWith<DiagnosticoSaveResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiagnosticoSaveResultCopyWith<$Res> {
  factory $DiagnosticoSaveResultCopyWith(
    DiagnosticoSaveResult value,
    $Res Function(DiagnosticoSaveResult) then,
  ) = _$DiagnosticoSaveResultCopyWithImpl<$Res, DiagnosticoSaveResult>;
  @useResult
  $Res call({bool success, String diagnosticoId, String resultado});
}

/// @nodoc
class _$DiagnosticoSaveResultCopyWithImpl<
  $Res,
  $Val extends DiagnosticoSaveResult
>
    implements $DiagnosticoSaveResultCopyWith<$Res> {
  _$DiagnosticoSaveResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DiagnosticoSaveResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? diagnosticoId = null,
    Object? resultado = null,
  }) {
    return _then(
      _value.copyWith(
            success: null == success
                ? _value.success
                : success // ignore: cast_nullable_to_non_nullable
                      as bool,
            diagnosticoId: null == diagnosticoId
                ? _value.diagnosticoId
                : diagnosticoId // ignore: cast_nullable_to_non_nullable
                      as String,
            resultado: null == resultado
                ? _value.resultado
                : resultado // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DiagnosticoSaveResultImplCopyWith<$Res>
    implements $DiagnosticoSaveResultCopyWith<$Res> {
  factory _$$DiagnosticoSaveResultImplCopyWith(
    _$DiagnosticoSaveResultImpl value,
    $Res Function(_$DiagnosticoSaveResultImpl) then,
  ) = __$$DiagnosticoSaveResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, String diagnosticoId, String resultado});
}

/// @nodoc
class __$$DiagnosticoSaveResultImplCopyWithImpl<$Res>
    extends
        _$DiagnosticoSaveResultCopyWithImpl<$Res, _$DiagnosticoSaveResultImpl>
    implements _$$DiagnosticoSaveResultImplCopyWith<$Res> {
  __$$DiagnosticoSaveResultImplCopyWithImpl(
    _$DiagnosticoSaveResultImpl _value,
    $Res Function(_$DiagnosticoSaveResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DiagnosticoSaveResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? diagnosticoId = null,
    Object? resultado = null,
  }) {
    return _then(
      _$DiagnosticoSaveResultImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        diagnosticoId: null == diagnosticoId
            ? _value.diagnosticoId
            : diagnosticoId // ignore: cast_nullable_to_non_nullable
                  as String,
        resultado: null == resultado
            ? _value.resultado
            : resultado // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DiagnosticoSaveResultImpl implements _DiagnosticoSaveResult {
  const _$DiagnosticoSaveResultImpl({
    required this.success,
    required this.diagnosticoId,
    required this.resultado,
  });

  factory _$DiagnosticoSaveResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$DiagnosticoSaveResultImplFromJson(json);

  @override
  final bool success;
  @override
  final String diagnosticoId;
  @override
  final String resultado;

  @override
  String toString() {
    return 'DiagnosticoSaveResult(success: $success, diagnosticoId: $diagnosticoId, resultado: $resultado)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiagnosticoSaveResultImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.diagnosticoId, diagnosticoId) ||
                other.diagnosticoId == diagnosticoId) &&
            (identical(other.resultado, resultado) ||
                other.resultado == resultado));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, success, diagnosticoId, resultado);

  /// Create a copy of DiagnosticoSaveResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiagnosticoSaveResultImplCopyWith<_$DiagnosticoSaveResultImpl>
  get copyWith =>
      __$$DiagnosticoSaveResultImplCopyWithImpl<_$DiagnosticoSaveResultImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DiagnosticoSaveResultImplToJson(this);
  }
}

abstract class _DiagnosticoSaveResult implements DiagnosticoSaveResult {
  const factory _DiagnosticoSaveResult({
    required final bool success,
    required final String diagnosticoId,
    required final String resultado,
  }) = _$DiagnosticoSaveResultImpl;

  factory _DiagnosticoSaveResult.fromJson(Map<String, dynamic> json) =
      _$DiagnosticoSaveResultImpl.fromJson;

  @override
  bool get success;
  @override
  String get diagnosticoId;
  @override
  String get resultado;

  /// Create a copy of DiagnosticoSaveResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiagnosticoSaveResultImplCopyWith<_$DiagnosticoSaveResultImpl>
  get copyWith => throw _privateConstructorUsedError;
}
