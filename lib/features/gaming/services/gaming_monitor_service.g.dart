// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gaming_monitor_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$gamingMonitorHash() => r'b7739e9d321e9b5c8189a7c71b1b35bdd34bdb0e';

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

abstract class _$GamingMonitor extends BuildlessAutoDisposeNotifier<void> {
  late final String gameId;

  void build(String gameId);
}

/// See also [GamingMonitor].
@ProviderFor(GamingMonitor)
const gamingMonitorProvider = GamingMonitorFamily();

/// See also [GamingMonitor].
class GamingMonitorFamily extends Family<void> {
  /// See also [GamingMonitor].
  const GamingMonitorFamily();

  /// See also [GamingMonitor].
  GamingMonitorProvider call(String gameId) {
    return GamingMonitorProvider(gameId);
  }

  @override
  GamingMonitorProvider getProviderOverride(
    covariant GamingMonitorProvider provider,
  ) {
    return call(provider.gameId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'gamingMonitorProvider';
}

/// See also [GamingMonitor].
class GamingMonitorProvider
    extends AutoDisposeNotifierProviderImpl<GamingMonitor, void> {
  /// See also [GamingMonitor].
  GamingMonitorProvider(String gameId)
    : this._internal(
        () => GamingMonitor()..gameId = gameId,
        from: gamingMonitorProvider,
        name: r'gamingMonitorProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$gamingMonitorHash,
        dependencies: GamingMonitorFamily._dependencies,
        allTransitiveDependencies:
            GamingMonitorFamily._allTransitiveDependencies,
        gameId: gameId,
      );

  GamingMonitorProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.gameId,
  }) : super.internal();

  final String gameId;

  @override
  void runNotifierBuild(covariant GamingMonitor notifier) {
    return notifier.build(gameId);
  }

  @override
  Override overrideWith(GamingMonitor Function() create) {
    return ProviderOverride(
      origin: this,
      override: GamingMonitorProvider._internal(
        () => create()..gameId = gameId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        gameId: gameId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<GamingMonitor, void> createElement() {
    return _GamingMonitorProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GamingMonitorProvider && other.gameId == gameId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, gameId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GamingMonitorRef on AutoDisposeNotifierProviderRef<void> {
  /// The parameter `gameId` of this provider.
  String get gameId;
}

class _GamingMonitorProviderElement
    extends AutoDisposeNotifierProviderElement<GamingMonitor, void>
    with GamingMonitorRef {
  _GamingMonitorProviderElement(super.provider);

  @override
  String get gameId => (origin as GamingMonitorProvider).gameId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
