// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streaming_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$streamingRepositoryHash() =>
    r'6d7948f46bc571e819185cd10541c0f9c61fb499';

/// See also [streamingRepository].
@ProviderFor(streamingRepository)
final streamingRepositoryProvider =
    AutoDisposeProvider<StreamingRepository>.internal(
      streamingRepository,
      name: r'streamingRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$streamingRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StreamingRepositoryRef = AutoDisposeProviderRef<StreamingRepository>;
String _$streamingPlatformsHash() =>
    r'a0afb0de12601f412ae83ae4e34e373727d2f624';

/// See also [streamingPlatforms].
@ProviderFor(streamingPlatforms)
final streamingPlatformsProvider =
    AutoDisposeStreamProvider<List<StreamingPlatform>>.internal(
      streamingPlatforms,
      name: r'streamingPlatformsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$streamingPlatformsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StreamingPlatformsRef =
    AutoDisposeStreamProviderRef<List<StreamingPlatform>>;
String _$streamingPlatformDetailHash() =>
    r'70e17a760cf2c44b9f43885f183a5a8b5174a3bb';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [streamingPlatformDetail].
@ProviderFor(streamingPlatformDetail)
const streamingPlatformDetailProvider = StreamingPlatformDetailFamily();

/// See also [streamingPlatformDetail].
class StreamingPlatformDetailFamily
    extends Family<AsyncValue<StreamingPlatform?>> {
  /// See also [streamingPlatformDetail].
  const StreamingPlatformDetailFamily();

  /// See also [streamingPlatformDetail].
  StreamingPlatformDetailProvider call(String id) {
    return StreamingPlatformDetailProvider(id);
  }

  @override
  StreamingPlatformDetailProvider getProviderOverride(
    covariant StreamingPlatformDetailProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'streamingPlatformDetailProvider';
}

/// See also [streamingPlatformDetail].
class StreamingPlatformDetailProvider
    extends AutoDisposeStreamProvider<StreamingPlatform?> {
  /// See also [streamingPlatformDetail].
  StreamingPlatformDetailProvider(String id)
    : this._internal(
        (ref) => streamingPlatformDetail(ref as StreamingPlatformDetailRef, id),
        from: streamingPlatformDetailProvider,
        name: r'streamingPlatformDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$streamingPlatformDetailHash,
        dependencies: StreamingPlatformDetailFamily._dependencies,
        allTransitiveDependencies:
            StreamingPlatformDetailFamily._allTransitiveDependencies,
        id: id,
      );

  StreamingPlatformDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    Stream<StreamingPlatform?> Function(StreamingPlatformDetailRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StreamingPlatformDetailProvider._internal(
        (ref) => create(ref as StreamingPlatformDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<StreamingPlatform?> createElement() {
    return _StreamingPlatformDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StreamingPlatformDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin StreamingPlatformDetailRef
    on AutoDisposeStreamProviderRef<StreamingPlatform?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _StreamingPlatformDetailProviderElement
    extends AutoDisposeStreamProviderElement<StreamingPlatform?>
    with StreamingPlatformDetailRef {
  _StreamingPlatformDetailProviderElement(super.provider);

  @override
  String get id => (origin as StreamingPlatformDetailProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
