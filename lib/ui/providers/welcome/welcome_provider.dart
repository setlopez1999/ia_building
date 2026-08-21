import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tvapp/core/application/states/auth/auth_state.dart';
import 'package:tvapp/core/application/states/content/content_state.dart';
import 'package:tvapp/core/application/use_cases/content/get_welcome_use_case.dart';
import 'package:tvapp/core/domain/entities/slides/slide_entity.dart';
import 'package:tvapp/core/providers/repository_providers.dart';
import 'package:tvapp/ui/providers/auth/auth_provider.dart';

part 'welcome_provider.g.dart';

@riverpod
class Welcome extends _$Welcome {
  @override
  ContentState<List<Slide>> build() {
    return const ContentState.initial();
  }

  Future<void> get() async {
    state = const ContentState.loading();
    final useCase = GetWelcomeUseCase(ref.read(slideRepositoryProvider));

    await ref.read(authProvider).maybeWhen(
      success: (user) async {
        final result = await useCase.execute();
        result.fold(
              (error) => state = ContentState.error(error),
              (content) => state = ContentState.success(content),
        );
      },
      orElse: () {},
    );
  }
}