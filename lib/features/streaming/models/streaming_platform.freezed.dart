// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'streaming_platform.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StreamingPlatform _$StreamingPlatformFromJson(Map<String, dynamic> json) {
  return _StreamingPlatform.fromJson(json);
}

/// @nodoc
mixin _$StreamingPlatform {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get logoAsset => throw _privateConstructorUsedError;
  String get downloadSpeed => throw _privateConstructorUsedError;
  String get uploadSpeed => throw _privateConstructorUsedError;
  String get serverName => throw _privateConstructorUsedError;
  String get serverLocation => throw _privateConstructorUsedError;

  /// Serializes this StreamingPlatform to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StreamingPlatform
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StreamingPlatformCopyWith<StreamingPlatform> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StreamingPlatformCopyWith<$Res> {
  factory $StreamingPlatformCopyWith(
    StreamingPlatform value,
    $Res Function(StreamingPlatform) then,
  ) = _$StreamingPlatformCopyWithImpl<$Res, StreamingPlatform>;
  @useResult
  $Res call({
    String id,
    String name,
    String logoAsset,
    String downloadSpeed,
    String uploadSpeed,
    String serverName,
    String serverLocation,
  });
}

/// @nodoc
class _$StreamingPlatformCopyWithImpl<$Res, $Val extends StreamingPlatform>
    implements $StreamingPlatformCopyWith<$Res> {
  _$StreamingPlatformCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StreamingPlatform
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? logoAsset = null,
    Object? downloadSpeed = null,
    Object? uploadSpeed = null,
    Object? serverName = null,
    Object? serverLocation = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            logoAsset: null == logoAsset
                ? _value.logoAsset
                : logoAsset // ignore: cast_nullable_to_non_nullable
                      as String,
            downloadSpeed: null == downloadSpeed
                ? _value.downloadSpeed
                : downloadSpeed // ignore: cast_nullable_to_non_nullable
                      as String,
            uploadSpeed: null == uploadSpeed
                ? _value.uploadSpeed
                : uploadSpeed // ignore: cast_nullable_to_non_nullable
                      as String,
            serverName: null == serverName
                ? _value.serverName
                : serverName // ignore: cast_nullable_to_non_nullable
                      as String,
            serverLocation: null == serverLocation
                ? _value.serverLocation
                : serverLocation // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StreamingPlatformImplCopyWith<$Res>
    implements $StreamingPlatformCopyWith<$Res> {
  factory _$$StreamingPlatformImplCopyWith(
    _$StreamingPlatformImpl value,
    $Res Function(_$StreamingPlatformImpl) then,
  ) = __$$StreamingPlatformImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String logoAsset,
    String downloadSpeed,
    String uploadSpeed,
    String serverName,
    String serverLocation,
  });
}

/// @nodoc
class __$$StreamingPlatformImplCopyWithImpl<$Res>
    extends _$StreamingPlatformCopyWithImpl<$Res, _$StreamingPlatformImpl>
    implements _$$StreamingPlatformImplCopyWith<$Res> {
  __$$StreamingPlatformImplCopyWithImpl(
    _$StreamingPlatformImpl _value,
    $Res Function(_$StreamingPlatformImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StreamingPlatform
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? logoAsset = null,
    Object? downloadSpeed = null,
    Object? uploadSpeed = null,
    Object? serverName = null,
    Object? serverLocation = null,
  }) {
    return _then(
      _$StreamingPlatformImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        logoAsset: null == logoAsset
            ? _value.logoAsset
            : logoAsset // ignore: cast_nullable_to_non_nullable
                  as String,
        downloadSpeed: null == downloadSpeed
            ? _value.downloadSpeed
            : downloadSpeed // ignore: cast_nullable_to_non_nullable
                  as String,
        uploadSpeed: null == uploadSpeed
            ? _value.uploadSpeed
            : uploadSpeed // ignore: cast_nullable_to_non_nullable
                  as String,
        serverName: null == serverName
            ? _value.serverName
            : serverName // ignore: cast_nullable_to_non_nullable
                  as String,
        serverLocation: null == serverLocation
            ? _value.serverLocation
            : serverLocation // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StreamingPlatformImpl implements _StreamingPlatform {
  const _$StreamingPlatformImpl({
    required this.id,
    required this.name,
    required this.logoAsset,
    required this.downloadSpeed,
    required this.uploadSpeed,
    required this.serverName,
    required this.serverLocation,
  });

  factory _$StreamingPlatformImpl.fromJson(Map<String, dynamic> json) =>
      _$$StreamingPlatformImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String logoAsset;
  @override
  final String downloadSpeed;
  @override
  final String uploadSpeed;
  @override
  final String serverName;
  @override
  final String serverLocation;

  @override
  String toString() {
    return 'StreamingPlatform(id: $id, name: $name, logoAsset: $logoAsset, downloadSpeed: $downloadSpeed, uploadSpeed: $uploadSpeed, serverName: $serverName, serverLocation: $serverLocation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamingPlatformImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.logoAsset, logoAsset) ||
                other.logoAsset == logoAsset) &&
            (identical(other.downloadSpeed, downloadSpeed) ||
                other.downloadSpeed == downloadSpeed) &&
            (identical(other.uploadSpeed, uploadSpeed) ||
                other.uploadSpeed == uploadSpeed) &&
            (identical(other.serverName, serverName) ||
                other.serverName == serverName) &&
            (identical(other.serverLocation, serverLocation) ||
                other.serverLocation == serverLocation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    logoAsset,
    downloadSpeed,
    uploadSpeed,
    serverName,
    serverLocation,
  );

  /// Create a copy of StreamingPlatform
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StreamingPlatformImplCopyWith<_$StreamingPlatformImpl> get copyWith =>
      __$$StreamingPlatformImplCopyWithImpl<_$StreamingPlatformImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$StreamingPlatformImplToJson(this);
  }
}

abstract class _StreamingPlatform implements StreamingPlatform {
  const factory _StreamingPlatform({
    required final String id,
    required final String name,
    required final String logoAsset,
    required final String downloadSpeed,
    required final String uploadSpeed,
    required final String serverName,
    required final String serverLocation,
  }) = _$StreamingPlatformImpl;

  factory _StreamingPlatform.fromJson(Map<String, dynamic> json) =
      _$StreamingPlatformImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get logoAsset;
  @override
  String get downloadSpeed;
  @override
  String get uploadSpeed;
  @override
  String get serverName;
  @override
  String get serverLocation;

  /// Create a copy of StreamingPlatform
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StreamingPlatformImplCopyWith<_$StreamingPlatformImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
