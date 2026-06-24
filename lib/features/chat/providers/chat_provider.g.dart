// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatRepositoryHash() => r'350e657a0514d104829e0f70476279b45b59cdc0';

/// See also [chatRepository].
@ProviderFor(chatRepository)
final chatRepositoryProvider = AutoDisposeProvider<ChatRepository>.internal(
  chatRepository,
  name: r'chatRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chatRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChatRepositoryRef = AutoDisposeProviderRef<ChatRepository>;
String _$chatHash() => r'056cd0776067f3cb78fd23ec6467f4f86f658d7e';

/// See also [Chat].
@ProviderFor(Chat)
final chatProvider =
    AutoDisposeNotifierProvider<Chat, List<ChatMessage>>.internal(
      Chat.new,
      name: r'chatProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$chatHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Chat = AutoDisposeNotifier<List<ChatMessage>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
