import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/config_repository.dart';
import '../data/repositories/config_repository_impl.dart';
import '../../../shared/data/models/remote_config.dart';
import '../../../core/providers/providers.dart';

final configRepositoryProvider = Provider<ConfigRepository>((ref) {
  return ConfigRepositoryImpl(ref.watch(apiClientProvider));
});

final appRemoteConfigProvider = FutureProvider<AppRemoteConfig>((ref) async {
  return ref.watch(configRepositoryProvider).getConfig();
});
