// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streaming_monitor_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$streamingMonitorHash() => r'5b24351219da2fee8705dbe8f76ea58d41fa4870';

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

abstract class _$StreamingMonitor extends BuildlessAutoDisposeNotifier<void> {
  late final String platformId;

  void build(String platformId);
}

/// See also [StreamingMonitor].
@ProviderFor(StreamingMonitor)
const streamingMonitorProvider = StreamingMonitorFamily();

/// See also [StreamingMonitor].
class StreamingMonitorFamily extends Family<void> {
  /// See also [StreamingMonitor].
  const StreamingMonitorFamily();

  /// See also [StreamingMonitor].
  StreamingMonitorProvider call(String platformId) {
    return StreamingMonitorProvider(platformId);
  }

  @override
  StreamingMonitorProvider getProviderOverride(
    covariant StreamingMonitorProvider provider,
  ) {
    return call(provider.platformId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'streamingMonitorProvider';
}

/// See also [StreamingMonitor].
class StreamingMonitorProvider
    extends AutoDisposeNotifierProviderImpl<StreamingMonitor, void> {
  /// See also [StreamingMonitor].
  StreamingMonitorProvider(String platformId)
    : this._internal(
        () => StreamingMonitor()..platformId = platformId,
        from: streamingMonitorProvider,
        name: r'streamingMonitorProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$streamingMonitorHash,
        dependencies: StreamingMonitorFamily._dependencies,
        allTransitiveDependencies:
            StreamingMonitorFamily._allTransitiveDependencies,
        platformId: platformId,
      );

  StreamingMonitorProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.platformId,
  }) : super.internal();

  final String platformId;

  @override
  void runNotifierBuild(covariant StreamingMonitor notifier) {
    return notifier.build(platformId);
  }

  @override
  Override overrideWith(StreamingMonitor Function() create) {
    return ProviderOverride(
      origin: this,
      override: StreamingMonitorProvider._internal(
        () => create()..platformId = platformId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        platformId: platformId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<StreamingMonitor, void> createElement() {
    return _StreamingMonitorProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StreamingMonitorProvider && other.platformId == platformId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, platformId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin StreamingMonitorRef on AutoDisposeNotifierProviderRef<void> {
  /// The parameter `platformId` of this provider.
  String get platformId;
}

class _StreamingMonitorProviderElement
    extends AutoDisposeNotifierProviderElement<StreamingMonitor, void>
    with StreamingMonitorRef {
  _StreamingMonitorProviderElement(super.provider);

  @override
  String get platformId => (origin as StreamingMonitorProvider).platformId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
