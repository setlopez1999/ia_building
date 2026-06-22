// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NetworkTargets _$NetworkTargetsFromJson(Map<String, dynamic> json) {
  return _NetworkTargets.fromJson(json);
}

/// @nodoc
mixin _$NetworkTargets {
  String get googlePingTarget => throw _privateConstructorUsedError;
  String get ispPingTarget => throw _privateConstructorUsedError;

  /// Serializes this NetworkTargets to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NetworkTargets
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NetworkTargetsCopyWith<NetworkTargets> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NetworkTargetsCopyWith<$Res> {
  factory $NetworkTargetsCopyWith(
    NetworkTargets value,
    $Res Function(NetworkTargets) then,
  ) = _$NetworkTargetsCopyWithImpl<$Res, NetworkTargets>;
  @useResult
  $Res call({String googlePingTarget, String ispPingTarget});
}

/// @nodoc
class _$NetworkTargetsCopyWithImpl<$Res, $Val extends NetworkTargets>
    implements $NetworkTargetsCopyWith<$Res> {
  _$NetworkTargetsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NetworkTargets
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? googlePingTarget = null, Object? ispPingTarget = null}) {
    return _then(
      _value.copyWith(
            googlePingTarget: null == googlePingTarget
                ? _value.googlePingTarget
                : googlePingTarget // ignore: cast_nullable_to_non_nullable
                      as String,
            ispPingTarget: null == ispPingTarget
                ? _value.ispPingTarget
                : ispPingTarget // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NetworkTargetsImplCopyWith<$Res>
    implements $NetworkTargetsCopyWith<$Res> {
  factory _$$NetworkTargetsImplCopyWith(
    _$NetworkTargetsImpl value,
    $Res Function(_$NetworkTargetsImpl) then,
  ) = __$$NetworkTargetsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String googlePingTarget, String ispPingTarget});
}

/// @nodoc
class __$$NetworkTargetsImplCopyWithImpl<$Res>
    extends _$NetworkTargetsCopyWithImpl<$Res, _$NetworkTargetsImpl>
    implements _$$NetworkTargetsImplCopyWith<$Res> {
  __$$NetworkTargetsImplCopyWithImpl(
    _$NetworkTargetsImpl _value,
    $Res Function(_$NetworkTargetsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NetworkTargets
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? googlePingTarget = null, Object? ispPingTarget = null}) {
    return _then(
      _$NetworkTargetsImpl(
        googlePingTarget: null == googlePingTarget
            ? _value.googlePingTarget
            : googlePingTarget // ignore: cast_nullable_to_non_nullable
                  as String,
        ispPingTarget: null == ispPingTarget
            ? _value.ispPingTarget
            : ispPingTarget // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NetworkTargetsImpl implements _NetworkTargets {
  const _$NetworkTargetsImpl({
    required this.googlePingTarget,
    required this.ispPingTarget,
  });

  factory _$NetworkTargetsImpl.fromJson(Map<String, dynamic> json) =>
      _$$NetworkTargetsImplFromJson(json);

  @override
  final String googlePingTarget;
  @override
  final String ispPingTarget;

  @override
  String toString() {
    return 'NetworkTargets(googlePingTarget: $googlePingTarget, ispPingTarget: $ispPingTarget)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetworkTargetsImpl &&
            (identical(other.googlePingTarget, googlePingTarget) ||
                other.googlePingTarget == googlePingTarget) &&
            (identical(other.ispPingTarget, ispPingTarget) ||
                other.ispPingTarget == ispPingTarget));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, googlePingTarget, ispPingTarget);

  /// Create a copy of NetworkTargets
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NetworkTargetsImplCopyWith<_$NetworkTargetsImpl> get copyWith =>
      __$$NetworkTargetsImplCopyWithImpl<_$NetworkTargetsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$NetworkTargetsImplToJson(this);
  }
}

abstract class _NetworkTargets implements NetworkTargets {
  const factory _NetworkTargets({
    required final String googlePingTarget,
    required final String ispPingTarget,
  }) = _$NetworkTargetsImpl;

  factory _NetworkTargets.fromJson(Map<String, dynamic> json) =
      _$NetworkTargetsImpl.fromJson;

  @override
  String get googlePingTarget;
  @override
  String get ispPingTarget;

  /// Create a copy of NetworkTargets
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NetworkTargetsImplCopyWith<_$NetworkTargetsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AppConfig _$AppConfigFromJson(Map<String, dynamic> json) {
  return _AppConfig.fromJson(json);
}

/// @nodoc
mixin _$AppConfig {
  String get assetsVersion => throw _privateConstructorUsedError;
  String get assetsCdnUrl => throw _privateConstructorUsedError;
  Map<String, String> get icons => throw _privateConstructorUsedError;
  NetworkTargets get networkTargets => throw _privateConstructorUsedError;

  /// Serializes this AppConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppConfigCopyWith<AppConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppConfigCopyWith<$Res> {
  factory $AppConfigCopyWith(AppConfig value, $Res Function(AppConfig) then) =
      _$AppConfigCopyWithImpl<$Res, AppConfig>;
  @useResult
  $Res call({
    String assetsVersion,
    String assetsCdnUrl,
    Map<String, String> icons,
    NetworkTargets networkTargets,
  });

  $NetworkTargetsCopyWith<$Res> get networkTargets;
}

/// @nodoc
class _$AppConfigCopyWithImpl<$Res, $Val extends AppConfig>
    implements $AppConfigCopyWith<$Res> {
  _$AppConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? assetsVersion = null,
    Object? assetsCdnUrl = null,
    Object? icons = null,
    Object? networkTargets = null,
  }) {
    return _then(
      _value.copyWith(
            assetsVersion: null == assetsVersion
                ? _value.assetsVersion
                : assetsVersion // ignore: cast_nullable_to_non_nullable
                      as String,
            assetsCdnUrl: null == assetsCdnUrl
                ? _value.assetsCdnUrl
                : assetsCdnUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            icons: null == icons
                ? _value.icons
                : icons // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
            networkTargets: null == networkTargets
                ? _value.networkTargets
                : networkTargets // ignore: cast_nullable_to_non_nullable
                      as NetworkTargets,
          )
          as $Val,
    );
  }

  /// Create a copy of AppConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NetworkTargetsCopyWith<$Res> get networkTargets {
    return $NetworkTargetsCopyWith<$Res>(_value.networkTargets, (value) {
      return _then(_value.copyWith(networkTargets: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AppConfigImplCopyWith<$Res>
    implements $AppConfigCopyWith<$Res> {
  factory _$$AppConfigImplCopyWith(
    _$AppConfigImpl value,
    $Res Function(_$AppConfigImpl) then,
  ) = __$$AppConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String assetsVersion,
    String assetsCdnUrl,
    Map<String, String> icons,
    NetworkTargets networkTargets,
  });

  @override
  $NetworkTargetsCopyWith<$Res> get networkTargets;
}

/// @nodoc
class __$$AppConfigImplCopyWithImpl<$Res>
    extends _$AppConfigCopyWithImpl<$Res, _$AppConfigImpl>
    implements _$$AppConfigImplCopyWith<$Res> {
  __$$AppConfigImplCopyWithImpl(
    _$AppConfigImpl _value,
    $Res Function(_$AppConfigImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? assetsVersion = null,
    Object? assetsCdnUrl = null,
    Object? icons = null,
    Object? networkTargets = null,
  }) {
    return _then(
      _$AppConfigImpl(
        assetsVersion: null == assetsVersion
            ? _value.assetsVersion
            : assetsVersion // ignore: cast_nullable_to_non_nullable
                  as String,
        assetsCdnUrl: null == assetsCdnUrl
            ? _value.assetsCdnUrl
            : assetsCdnUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        icons: null == icons
            ? _value._icons
            : icons // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
        networkTargets: null == networkTargets
            ? _value.networkTargets
            : networkTargets // ignore: cast_nullable_to_non_nullable
                  as NetworkTargets,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppConfigImpl implements _AppConfig {
  const _$AppConfigImpl({
    required this.assetsVersion,
    required this.assetsCdnUrl,
    required final Map<String, String> icons,
    required this.networkTargets,
  }) : _icons = icons;

  factory _$AppConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppConfigImplFromJson(json);

  @override
  final String assetsVersion;
  @override
  final String assetsCdnUrl;
  final Map<String, String> _icons;
  @override
  Map<String, String> get icons {
    if (_icons is EqualUnmodifiableMapView) return _icons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_icons);
  }

  @override
  final NetworkTargets networkTargets;

  @override
  String toString() {
    return 'AppConfig(assetsVersion: $assetsVersion, assetsCdnUrl: $assetsCdnUrl, icons: $icons, networkTargets: $networkTargets)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppConfigImpl &&
            (identical(other.assetsVersion, assetsVersion) ||
                other.assetsVersion == assetsVersion) &&
            (identical(other.assetsCdnUrl, assetsCdnUrl) ||
                other.assetsCdnUrl == assetsCdnUrl) &&
            const DeepCollectionEquality().equals(other._icons, _icons) &&
            (identical(other.networkTargets, networkTargets) ||
                other.networkTargets == networkTargets));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    assetsVersion,
    assetsCdnUrl,
    const DeepCollectionEquality().hash(_icons),
    networkTargets,
  );

  /// Create a copy of AppConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppConfigImplCopyWith<_$AppConfigImpl> get copyWith =>
      __$$AppConfigImplCopyWithImpl<_$AppConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppConfigImplToJson(this);
  }
}

abstract class _AppConfig implements AppConfig {
  const factory _AppConfig({
    required final String assetsVersion,
    required final String assetsCdnUrl,
    required final Map<String, String> icons,
    required final NetworkTargets networkTargets,
  }) = _$AppConfigImpl;

  factory _AppConfig.fromJson(Map<String, dynamic> json) =
      _$AppConfigImpl.fromJson;

  @override
  String get assetsVersion;
  @override
  String get assetsCdnUrl;
  @override
  Map<String, String> get icons;
  @override
  NetworkTargets get networkTargets;

  /// Create a copy of AppConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppConfigImplCopyWith<_$AppConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

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
