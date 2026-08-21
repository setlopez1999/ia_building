import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/core/application/use_cases/settings/get_settings_use_case.dart';
import 'package:tvapp/core/domain/entities/settings/settings_entity.dart';
import 'package:tvapp/core/providers/repository_providers.dart';

final settingsProvider = FutureProvider.autoDispose<Settings>((ref) async {
  final result = await GetSettingsUseCase(ref.watch(settingsRepositoryProvider)).execute();
  return result.fold(
    (error) => throw Exception(error.message),
    (settings) => settings,
  );
});
