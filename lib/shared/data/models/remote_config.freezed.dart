// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'remote_config.dart';

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

AppRemoteConfig _$AppRemoteConfigFromJson(Map<String, dynamic> json) {
  return _AppRemoteConfig.fromJson(json);
}

/// @nodoc
mixin _$AppRemoteConfig {
  String get assetsVersion => throw _privateConstructorUsedError;
  String get assetsCdnUrl => throw _privateConstructorUsedError;
  Map<String, String> get icons => throw _privateConstructorUsedError;
  NetworkTargets get networkTargets => throw _privateConstructorUsedError;

  /// Serializes this AppRemoteConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppRemoteConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppRemoteConfigCopyWith<AppRemoteConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppRemoteConfigCopyWith<$Res> {
  factory $AppRemoteConfigCopyWith(
    AppRemoteConfig value,
    $Res Function(AppRemoteConfig) then,
  ) = _$AppRemoteConfigCopyWithImpl<$Res, AppRemoteConfig>;
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
class _$AppRemoteConfigCopyWithImpl<$Res, $Val extends AppRemoteConfig>
    implements $AppRemoteConfigCopyWith<$Res> {
  _$AppRemoteConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppRemoteConfig
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

  /// Create a copy of AppRemoteConfig
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
abstract class _$$AppRemoteConfigImplCopyWith<$Res>
    implements $AppRemoteConfigCopyWith<$Res> {
  factory _$$AppRemoteConfigImplCopyWith(
    _$AppRemoteConfigImpl value,
    $Res Function(_$AppRemoteConfigImpl) then,
  ) = __$$AppRemoteConfigImplCopyWithImpl<$Res>;
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
class __$$AppRemoteConfigImplCopyWithImpl<$Res>
    extends _$AppRemoteConfigCopyWithImpl<$Res, _$AppRemoteConfigImpl>
    implements _$$AppRemoteConfigImplCopyWith<$Res> {
  __$$AppRemoteConfigImplCopyWithImpl(
    _$AppRemoteConfigImpl _value,
    $Res Function(_$AppRemoteConfigImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppRemoteConfig
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
      _$AppRemoteConfigImpl(
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
class _$AppRemoteConfigImpl implements _AppRemoteConfig {
  const _$AppRemoteConfigImpl({
    required this.assetsVersion,
    required this.assetsCdnUrl,
    required final Map<String, String> icons,
    required this.networkTargets,
  }) : _icons = icons;

  factory _$AppRemoteConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppRemoteConfigImplFromJson(json);

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
    return 'AppRemoteConfig(assetsVersion: $assetsVersion, assetsCdnUrl: $assetsCdnUrl, icons: $icons, networkTargets: $networkTargets)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppRemoteConfigImpl &&
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

  /// Create a copy of AppRemoteConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppRemoteConfigImplCopyWith<_$AppRemoteConfigImpl> get copyWith =>
      __$$AppRemoteConfigImplCopyWithImpl<_$AppRemoteConfigImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AppRemoteConfigImplToJson(this);
  }
}

abstract class _AppRemoteConfig implements AppRemoteConfig {
  const factory _AppRemoteConfig({
    required final String assetsVersion,
    required final String assetsCdnUrl,
    required final Map<String, String> icons,
    required final NetworkTargets networkTargets,
  }) = _$AppRemoteConfigImpl;

  factory _AppRemoteConfig.fromJson(Map<String, dynamic> json) =
      _$AppRemoteConfigImpl.fromJson;

  @override
  String get assetsVersion;
  @override
  String get assetsCdnUrl;
  @override
  Map<String, String> get icons;
  @override
  NetworkTargets get networkTargets;

  /// Create a copy of AppRemoteConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppRemoteConfigImplCopyWith<_$AppRemoteConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
