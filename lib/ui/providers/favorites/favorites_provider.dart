import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tvapp/core/application/states/content/content_state.dart';
import 'package:tvapp/core/application/use_cases/auth/get_session_use_case.dart';
import 'package:tvapp/core/application/use_cases/content/delete_favorite_use_case.dart';
import 'package:tvapp/core/application/use_cases/content/get_favorites_use_case.dart';
import 'package:tvapp/core/application/use_cases/content/set_favorite_use_case.dart';
import 'package:tvapp/core/domain/entities/channel/channel_entity.dart';
import 'package:tvapp/core/domain/entities/sensitive_data/sensitive_data_entity.dart';
import 'package:tvapp/core/providers/repository_providers.dart';

part 'favorites_provider.g.dart';

@Riverpod(keepAlive: true)
class Favorites extends _$Favorites {
  @override
  ContentState<List<Channel>> build() {
    return const ContentState.initial();
  }

  Future<void> get({bool silent = false}) async {
    if (!silent) {
      state = const ContentState.loading();
    }
    final channelsRepo = ref.read(channelsRepositoryProvider);
    final useCase = GetFavoritesUseCase(channelsRepo);
    final sessionUsecase = GetSessionUseCase(ref.read(authRepositoryProvider));

    final session = await sessionUsecase.execute();

    session.fold((error) => state = ContentState.error(error), (session) async {
      final result = await useCase.execute(session.email);
      result.fold(
        (error) => state = ContentState.error(error),
        (content) => state = ContentState.success(content),
      );
    });
  }

  bool isFavorite(int number) {
    return state.maybeWhen(
      orElse: () => false,
      success: (channels) => (channels as List<Channel>).any((element) => element.number == number),
    );
  }

  Future<void> toggleFavorite(Channel channel) async {
    final channelsRepository = ref.read(channelsRepositoryProvider);
    final sessionUseCase = GetSessionUseCase(ref.read(authRepositoryProvider));
    final setFavorite = SetFavoriteUseCase(channelsRepository);
    final deleteFavorite = DeleteFavoriteUseCase(channelsRepository);
    final session = await sessionUseCase.execute();

    final value = session.getRight();
    final data = value.getOrElse(() => const SensitiveDataEntity(email: '', token: '', parental: '', userID: '', deviceId: ''));

    if (isFavorite(channel.number)) {
      await deleteFavorite.execute(channel, data.email);
    } else {
      await setFavorite.execute(channel, data.email);
    }
  }
}
