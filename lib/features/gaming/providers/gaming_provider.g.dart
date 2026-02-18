// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gaming_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$gamingRepositoryHash() => r'c3c3d5e7bf352429e0f462baa6085437b28c43ff';

/// See also [gamingRepository].
@ProviderFor(gamingRepository)
final gamingRepositoryProvider = AutoDisposeProvider<GamingRepository>.internal(
  gamingRepository,
  name: r'gamingRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$gamingRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GamingRepositoryRef = AutoDisposeProviderRef<GamingRepository>;
String _$gamesHash() => r'5aa6a9413471a2349ee43a42444d0f065fc1cbce';

/// See also [games].
@ProviderFor(games)
final gamesProvider = AutoDisposeStreamProvider<List<Game>>.internal(
  games,
  name: r'gamesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$gamesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GamesRef = AutoDisposeStreamProviderRef<List<Game>>;
String _$gameDetailHash() => r'a4a3ece6989ba8570868e8d83f7050789066b393';

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

/// See also [gameDetail].
@ProviderFor(gameDetail)
const gameDetailProvider = GameDetailFamily();

/// See also [gameDetail].
class GameDetailFamily extends Family<AsyncValue<Game?>> {
  /// See also [gameDetail].
  const GameDetailFamily();

  /// See also [gameDetail].
  GameDetailProvider call(String id) {
    return GameDetailProvider(id);
  }

  @override
  GameDetailProvider getProviderOverride(
    covariant GameDetailProvider provider,
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
  String? get name => r'gameDetailProvider';
}

/// See also [gameDetail].
class GameDetailProvider extends AutoDisposeStreamProvider<Game?> {
  /// See also [gameDetail].
  GameDetailProvider(String id)
    : this._internal(
        (ref) => gameDetail(ref as GameDetailRef, id),
        from: gameDetailProvider,
        name: r'gameDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$gameDetailHash,
        dependencies: GameDetailFamily._dependencies,
        allTransitiveDependencies: GameDetailFamily._allTransitiveDependencies,
        id: id,
      );

  GameDetailProvider._internal(
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
  Override overrideWith(Stream<Game?> Function(GameDetailRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: GameDetailProvider._internal(
        (ref) => create(ref as GameDetailRef),
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
  AutoDisposeStreamProviderElement<Game?> createElement() {
    return _GameDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GameDetailProvider && other.id == id;
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
mixin GameDetailRef on AutoDisposeStreamProviderRef<Game?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _GameDetailProviderElement extends AutoDisposeStreamProviderElement<Game?>
    with GameDetailRef {
  _GameDetailProviderElement(super.provider);

  @override
  String get id => (origin as GameDetailProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
