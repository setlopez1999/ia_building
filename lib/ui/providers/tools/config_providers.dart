import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/core/domain/entities/tools/remote_config.dart';
import 'package:tvapp/core/infraestructure/datasource/tools/tools_api_client.dart';
import 'package:tvapp/core/infraestructure/repositories/tools/config_repository.dart';
import 'package:tvapp/core/infraestructure/repositories/tools/config_repository_impl.dart';

final configRepositoryProvider = Provider<ConfigRepository>((ref) {
  return ConfigRepositoryImpl(ToolsApiClient());
});

final appRemoteConfigProvider = FutureProvider<AppRemoteConfig>((ref) async {
  return ref.watch(configRepositoryProvider).getConfig();
});
