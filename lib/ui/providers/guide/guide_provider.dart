import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tvapp/core/application/states/content/content_state.dart';
import 'package:tvapp/core/application/use_cases/auth/get_session_use_case.dart';
import 'package:tvapp/core/application/use_cases/content/get_guide_use_case.dart';
import 'package:tvapp/core/domain/entities/channel/channel_entity.dart';
import 'package:tvapp/core/providers/repository_providers.dart';

part 'guide_provider.g.dart';

@Riverpod(keepAlive: true)
class Guide extends _$Guide {
  @override
  ContentState<List<Channel>> build() {
    return const ContentState.initial();
  }

  Future<void> get() async {
    state = const ContentState.loading();
    final useCase = GetGuideUseCase(ref.read(guideRepositoryProvider));
    final sessionUsecase = GetSessionUseCase(ref.read(authRepositoryProvider));

    final session = await sessionUsecase.execute();

    session.fold(
      (error) => state = ContentState.error(error),
      (session) async {
        final result = await useCase.execute(session.email);
        result.fold(
              (error) => state = ContentState.error(error),
              (content) => state = ContentState.success(content),
        );
      }
    );
  }
}